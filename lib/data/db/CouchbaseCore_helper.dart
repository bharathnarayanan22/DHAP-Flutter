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


  // Future<void> close() async {
  //   await _db?.close();
  //   _db = null;
  // }

  // Future<void> _loadInitialUsersIfEmpty() async {
  //   final db = await database;
  //
  //   debugPrint("Loading initial users from JSON...");
  //
  //   final jsonString = await rootBundle.loadString('lib/assets/data/users.json');
  //   final List<dynamic> userList = jsonDecode(jsonString);
  //
  //   for (final raw in userList) {
  //     if (raw is! Map<String, dynamic>) continue;
  //
  //     final Map<String, dynamic> userData = raw;
  //     final id = (userData['email'] is String) ? userData['email'] as String : null;
  //
  //     final MutableDocument doc = (id != null)
  //         ? MutableDocument.withId(id, userData)
  //         : MutableDocument(userData);
  //
  //     await db.saveDocument(doc);
  //   }
  //
  //   debugPrint("Initial users imported from user.json");
  // }

  Future<void> _loadInitialUsersIfEmpty() async {
    final db = await database;


    final query = await QueryBuilder.createAsync()
        .select(SelectResult.expression(Meta.id))
        .from(DataSource.database(db))
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
          await db.saveDocument(doc);
        } else {
          await db.saveDocument(MutableDocument(userData));
        }
      }

      debugPrint("Initial users imported from users.json");
    } catch (e) {
      debugPrint("Error loading users.json: $e");
    }
  }

  // Future<void> _loadInitialUsers() async {
  //   final db = await database;
  //
  //   debugPrint("Deleting existing users from DB...");
  //
  //   // Query all user documents
  //   final query = await QueryBuilder.createAsync()
  //       .select(SelectResult.expression(Meta.id))
  //       .from(DataSource.database(db))
  //       .where(Expression.property('type').equalTo(Expression.string('user')));
  //
  //   final result = await query.execute();
  //
  //   await for (final row in result.asStream()) {
  //     final docId = row.string('id');
  //     if (docId != null) {
  //       final doc = await db.document(docId);
  //       if (doc != null) {
  //         await db.deleteDocument(doc);
  //       }
  //     }
  //   }
  //
  //   debugPrint("Existing users deleted. Loading new users from JSON...");
  //
  //   try {
  //     final jsonString = await rootBundle.loadString('lib/assets/data/users.json');
  //     final List<dynamic> userList = jsonDecode(jsonString);
  //
  //     for (final raw in userList) {
  //       if (raw is! Map<String, dynamic>) continue;
  //
  //       final Map<String, dynamic> userData = raw;
  //       final id = (userData['email'] is String) ? userData['email'] as String : null;
  //
  //       if (id != null) {
  //         final MutableDocument doc = MutableDocument.withId(id, userData);
  //         await db.saveDocument(doc);
  //       } else {
  //         await db.saveDocument(MutableDocument(userData));
  //       }
  //     }
  //
  //     debugPrint("Users imported from users.json");
  //   } catch (e) {
  //     debugPrint("Error loading users.json: $e");
  //   }
  // }


  Future<void> _loadInitialResourcesIfEmpty() async {
    final db = await database;

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.expression(Meta.id))
        .from(DataSource.database(db))
        .where(Expression.property('type').equalTo(Expression.string('resource')));

    final result = await query.execute();
    final hasResources = await result.asStream().isEmpty == false;

    // if (hasResources) {
    //   debugPrint("Resources already exist in DB — skipping JSON load.");
    //   return;
    // }

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

        await db.saveDocument(doc);
      }

      debugPrint("Initial resources imported from resources.json");
    } catch (e) {
      debugPrint("Error loading resources.json: $e");
    }
  }
}