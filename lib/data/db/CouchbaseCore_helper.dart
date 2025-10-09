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
    if (initialized) return;
    await CouchbaseLiteFlutter.init();
    initialized = true;
    _db ??= await Database.openAsync(_dbName);
    debugPrint("Couchbase DB opened: $_dbName");
    await _loadInitialUsersIfEmpty();
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  Future<void> _loadInitialUsersIfEmpty() async {
    final db = await database;

    debugPrint("Loading initial users from JSON...");

    final jsonString = await rootBundle.loadString('lib/assets/data/users.json');
    final List<dynamic> userList = jsonDecode(jsonString);

    for (final raw in userList) {
      if (raw is! Map<String, dynamic>) continue;

      final Map<String, dynamic> userData = raw;
      final id = (userData['email'] is String) ? userData['email'] as String : null;

      final MutableDocument doc = (id != null)
          ? MutableDocument.withId(id, userData)
          : MutableDocument(userData);

      await db.saveDocument(doc);
    }

    debugPrint("Initial users imported from user.json");
  }

}