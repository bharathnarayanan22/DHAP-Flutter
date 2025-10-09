import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:flutter/cupertino.dart';

class Sessiondb_helper {
  final _core = CouchbaseCoreHelper();
  Future<void> saveSession(String email, String role) async {
    final db = await _core.database;
    final sessionDoc = MutableDocument.withId(
      'session',
      {
        'type': 'session',
        'isLoggedIn': true,
        'email': email,
      },
    );
    await db!.saveDocument(sessionDoc);
    debugPrint("Session saved in Couchbase: $email");
  }

  Future<bool> isLoggedIn() async {
    final db = await _core.database;
    final sessionDoc = await db!.document('session');
    return sessionDoc?.boolean('isLoggedIn') ?? false;
  }

  Future<String> getUserEmail() async {
    final db = await _core.database;
    final sessionDoc = await db!.document('session');
    //if (sessionDoc == null) return null;

    final email = sessionDoc?.string('email');
    return email ?? '';

  }

  Future<void> clearSession() async {
    final db = await _core.database;
    final sessionDoc = await db!.document('session');
    if(sessionDoc != null) {
      await db!.deleteDocument(sessionDoc);
      debugPrint("Session cleared in Couchbase");
    }
  }

}