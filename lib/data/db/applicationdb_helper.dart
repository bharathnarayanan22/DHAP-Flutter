import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/application_model.dart';
import 'package:flutter/cupertino.dart';

class ApplicationDbHelper {
  final _core = CouchbaseCoreHelper();

  Future<void> addApplication(String email, String message) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final application = CoordinatorApplication(
      email: email,
      message: message,
    );

    final doc = MutableDocument.withId(application.id, {
      'type': 'coordinatorApplication',
      'id': application.id,
      'email': application.email,
      'message': application.message,
      'status': application.status,
      'submittedAt': application.submittedAt.toIso8601String(),
    });

    debugPrint("Coordinator application document: $doc");
    debugPrint("Coordinator application email: ${application.email}");

    await collection.saveDocument(doc);
    debugPrint("Coordinator application saved: ${application.email} id: ${application.id}");
  }

  Future<void> acceptApplication(String applicationId, {bool promoteUser = true}) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final appDoc = await collection.document(applicationId);
    if (appDoc == null) {
      debugPrint("Application not found: $applicationId");
      return;
    }

    final mutableApp = appDoc.toMutable();
    mutableApp.setString(key: 'status', 'accepted');
    await collection.saveDocument(mutableApp);
    debugPrint("Application accepted: $applicationId");

    if (promoteUser) {
      final userEmail = mutableApp.string('email');
      if (userEmail != null) {
        final userDoc = await collection.document(userEmail);
        if (userDoc != null) {
          final mutableUser = userDoc.toMutable();
          mutableUser.setBoolean(key: 'isCoordinator', true);
          mutableUser.setString(key: 'role', 'Coordinator');
          await collection.saveDocument(mutableUser);
          debugPrint("User promoted to Coordinator: $userEmail");
        }
      }
    }
  }

  Future<void> rejectApplication(String applicationId) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final appDoc = await collection.document(applicationId);
    if (appDoc == null) {
      debugPrint("Application not found: $applicationId");
      return;
    }

    final mutableApp = appDoc.toMutable();
    mutableApp.setString(key: 'status', 'rejected');
    await collection.saveDocument(mutableApp);
    debugPrint("Application rejected: $applicationId");
  }

  Future<List<CoordinatorApplication>> getAllApplications() async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.collection(collection))
        .where(Expression.property('type')
        .equalTo(Expression.string('coordinatorApplication')));

    final result = await query.execute();
    final List<CoordinatorApplication> applications = [];

    await for (final row in result.asStream()) {
      final data = row.dictionary(collection.name);
      if (data != null) {
        applications.add(CoordinatorApplication(
          id: data.string('id') ?? uuid.v4(),
          email: data.string('email') ?? '',
          message: data.string('message') ?? '',
          status: data.string('status') ?? 'pending',
          submittedAt: DateTime.tryParse(data.string('submittedAt') ?? '') ?? DateTime.now(),
        ));
      }
    }

    return applications;
  }
}
