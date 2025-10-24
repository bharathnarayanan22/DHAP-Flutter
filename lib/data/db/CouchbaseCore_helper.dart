import 'dart:convert';
import 'package:cbl/cbl.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class CouchbaseCoreHelper {
  static final CouchbaseCoreHelper _instance = CouchbaseCoreHelper._internal();
  static const _dbName = "dhap";
  static bool initialized = false;
  Database? _db;

  CouchbaseCoreHelper._internal();

  factory CouchbaseCoreHelper() => _instance;

  Future<Database> get database async {

    if (_db == null) await init();
    return _db!;
  }


  Future<void> init() async {
    if (!initialized) {
      await CouchbaseLiteFlutter.init();
      initialized = true;
      debugPrint("Couchbase Lite initialized.");
    }

    if (_db == null) {
      final config = DatabaseConfiguration();
      _db = await Database.openAsync(_dbName, config);
      debugPrint("Couchbase DB opened: $_dbName");

      // await _loadInitialUsersIfEmpty();
      await _loadInitialUsersIfEmpty();
      await _loadInitialResourcesIfEmpty();
    }
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      debugPrint("Couchbase DB closed: $_dbName");
    }
  }

  Future<void> _loadInitialUsersIfEmpty() async {
    final db = await database;
    final collection = await db.defaultCollection;

    final query = QueryBuilder.createAsync()
        .select(SelectResult.expression(Meta.id))
        .from(DataSource.collection(collection))
        .where(Expression.property('type').equalTo(Expression.string('user')));

    final result = await query.execute();
    final hasUsers = await result.asStream().isEmpty == false;

    if (hasUsers) {
      debugPrint("Users already exist in DB — skipping JSON load.");
      return;
    }

    debugPrint("Loading initial users from JSON...");

    try {
      final jsonString = await rootBundle.loadString('lib/assets/data/users.json');
      final List<dynamic> userList = jsonDecode(jsonString);

      for (final raw in userList) {
        if (raw is! Map<String, dynamic>) continue;

        final Map<String, dynamic> userData = raw;
        final id = (userData['email'] is String) ? userData['email'] as String : null;

        if (id != null) {
          final MutableDocument doc = MutableDocument.withId(id, userData);
          await collection.saveDocument(doc);
        } else {
          await collection.saveDocument(MutableDocument(userData));
        }
      }

      debugPrint("Initial users imported from users.json");
    } catch (e) {
      debugPrint("Error loading users.json: $e");
    }
  }

  Future<void> _loadInitialResourcesIfEmpty() async {
    final db = await database;
    final collection = await db.defaultCollection;

    final query = QueryBuilder.createAsync()
        .select(SelectResult.expression(Meta.id))
        .from(DataSource.collection(collection))
        .where(Expression.property('type').equalTo(Expression.string('resource')));

    final result = await query.execute();
    final hasResources = await result.asStream().isEmpty == false;

    if (hasResources) {
      debugPrint("Resources already exist in DB — skipping JSON load.");
      return;
    }

    debugPrint("Loading initial resources from JSON...");

    try {
      final jsonString = await rootBundle.loadString('lib/assets/data/resources.json');
      final List<dynamic> resourceList = jsonDecode(jsonString);

      for (final raw in resourceList) {
        if (raw is! Map<String, dynamic>) continue;
        final Map<String, dynamic> resourceData = raw;

        final id = resourceData['id']?.toString() ?? null;

        final MutableDocument doc = (id != null)
            ? MutableDocument.withId(id, resourceData)
            : MutableDocument(resourceData);

        await collection.saveDocument(doc);
      }

      debugPrint("Initial resources imported from resources.json");
    } catch (e) {
      debugPrint("Error loading resources.json: $e");
    }
  }
}


// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:sqflite/sqlite_api.dart';
//
// class SQLiteCoreHelper {
//   static final SQLiteCoreHelper _instance = SQLiteCoreHelper._internal();
//   static Database? _db;
//   static const _dbName = "dhap.db";
//   static const _dbVersion = 1;
//
//   SQLiteCoreHelper._internal();
//   factory SQLiteCoreHelper() => _instance;
//
//   Future<Database> get database async {
//     if (_db != null) return _db!;
//     await _init();
//     return _db!;
//   }
//
//   Future<void> _init() async {
//     final dbPath = await sql.getDatabasesPath();
//     final path = join(dbPath, _dbName);
//
//     _db = await sql.openDatabase(
//       path,
//       version: _dbVersion,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE users (
//             email TEXT PRIMARY KEY,
//             name TEXT,
//             mobile TEXT,
//             addressLine TEXT,
//             city TEXT,
//             country TEXT,
//             pincode TEXT,
//             role TEXT
//           )
//         ''');
//
//         await db.execute('''
//           CREATE TABLE resources (
//             id TEXT PRIMARY KEY,
//             name TEXT,
//             type TEXT,
//             description TEXT,
//             otherData TEXT
//           )
//         ''');
//       },
//     );
//
//     debugPrint("SQLite DB initialized at $path");
//
//     await _loadInitialUsersIfEmpty();
//     await _loadInitialResourcesIfEmpty();
//   }
//
//   Future<void> close() async {
//     if (_db != null) {
//       await _db!.close();
//       _db = null;
//       debugPrint("SQLite DB closed");
//     }
//   }
//
//   Future<void> _loadInitialUsersIfEmpty() async {
//     final db = await database;
//     final count = sql.Sqflite.firstIntValue(
//         await db.rawQuery('SELECT COUNT(*) FROM users'));
//
//     if ((count ?? 0) > 0) {
//       debugPrint("Users already exist — skipping JSON load.");
//       return;
//     }
//
//     debugPrint("Loading initial users from JSON...");
//
//     try {
//       final jsonString = await rootBundle.loadString('lib/assets/data/users.json');
//       final List<dynamic> userList = jsonDecode(jsonString);
//
//       final batch = db.batch();
//       for (final raw in userList) {
//         if (raw is! Map<String, dynamic>) continue;
//         final userData = raw;
//
//         batch.insert('users', userData,
//             conflictAlgorithm: ConflictAlgorithm.replace);
//       }
//       await batch.commit(noResult: true);
//
//       debugPrint("Initial users imported from users.json");
//     } catch (e) {
//       debugPrint("Error loading users.json: $e");
//     }
//   }
//
//   Future<void> _loadInitialResourcesIfEmpty() async {
//     final db = await database;
//     final count = sql.Sqflite.firstIntValue(
//         await db.rawQuery('SELECT COUNT(*) FROM resources'));
//
//     if ((count ?? 0) > 0) {
//       debugPrint("Resources already exist — skipping JSON load.");
//       return;
//     }
//
//     debugPrint("Loading initial resources from JSON...");
//
//     try {
//       final jsonString = await rootBundle.loadString('lib/assets/data/resources.json');
//       final List<dynamic> resourceList = jsonDecode(jsonString);
//
//       final batch = db.batch();
//       for (final raw in resourceList) {
//         if (raw is! Map<String, dynamic>) continue;
//         final resourceData = Map<String, dynamic>.from(raw);
//
//         batch.insert('resources', resourceData,
//             conflictAlgorithm: ConflictAlgorithm.replace);
//       }
//       await batch.commit(noResult: true);
//
//       debugPrint("Initial resources imported from resources.json");
//     } catch (e) {
//       debugPrint("Error loading resources.json: $e");
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     final db = await database;
//     return db.query('users');
//   }
//
//   Future<List<Map<String, dynamic>>> getAllResources() async {
//     final db = await database;
//     return db.query('resources');
//   }
// }
