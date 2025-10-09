import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class TaskdbHelper {
  final _core = CouchbaseCoreHelper();

  Future<void> addTask(Task task) async {
    final db = await _core.database;
    final doc = MutableDocument.withId(
        '${task.id}',
        {
      'type': 'task',
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'volunteer': task.volunteer,
      'volunteersAccepted': task.volunteersAccepted,
      'StartAddress': task.StartAddress,
      'EndAddress': task.EndAddress,
      'StartLocation': '${task.StartLocation.latitude},${task.StartLocation.longitude}',
      'EndLocation': '${task.EndLocation.latitude},${task.EndLocation.longitude}',
      'Status': task.Status,
      'proofs': task.proofs.map((p) => {
        'message': p.message,
        'mediaPaths': p.mediaPaths,
      }).toList(),
    });

    await db!.saveDocument(doc);
    debugPrint("Task saved in Couchbase: ${task.title}");
  }

  Future<List<Task>> getAllTasks() async {
    final db = await _core.database;
    final dbName = 'dhap';

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.database(db!))
        .where(Expression.property('type').equalTo(Expression.string('task')));

    final result = await query.execute();

    final List<Task> tasks = [];

    await for (final row in result.asStream()) {
      final data = row.dictionary(dbName);

      if (data != null) {
        final dataMap = Map<String, dynamic>.from(data.toPlainMap());
        final startParts = (dataMap['StartLocation'] as String? ?? "0,0").split(',');
        final endParts = (dataMap['EndLocation'] as String? ?? "0,0").split(',');

        tasks.add(
          Task(
            id: data.integer('id'),
            title: data.string('title') ?? '',
            description: data.string('description') ?? '',
            volunteer: data.integer('volunteer'),
            volunteersAccepted: data.integer('volunteersAccepted'),
            StartAddress: data.string('StartAddress') ?? '',
            EndAddress: data.string('EndAddress') ?? '',
            StartLocation: LatLng(
              double.tryParse(startParts[0]) ?? 0.0,
              double.tryParse(startParts[1]) ?? 0.0,
            ),
            EndLocation: LatLng(
              double.tryParse(endParts[0]) ?? 0.0,
              double.tryParse(endParts[1]) ?? 0.0,
            ),
            Status: data.string('Status') ?? '',
            proofs: (dataMap['proofs'] as List<dynamic>? ?? [])
                .map(
                  (e) => Proof(
                    message: e['message'] ?? '',
                    mediaPaths: List<String>.from(e['mediaPaths'] ?? []),
                  ),
                )
                .toList(),
          ),
        );
      }
    }

    return tasks;
  }

  Future<void> deleteTask(int id) async {
    debugPrint("Deleting task with id: $id");
    final db = await _core.database;
    final doc = await db.document(id.toString());
    debugPrint("Task to be deleted: $doc");
    if (doc != null) {
      await db.deleteDocument(doc);
      debugPrint("Task deleted: $id");
    }
  }

  Future<Task> getTaskById(int id) async {
    final db = await _core.database;
    final doc = await db!.document(id.toString());
    if (doc == null) {
      throw Exception('Task not found');
    }
    final data = doc.dictionary('dhap');
    final startParts = (data?['StartLocation'] as String? ?? "0,0").split(',');
    final endParts = (data?['EndLocation'] as String? ?? "0,0").split(',');

    return Task(
      id: data?.integer('id'),
      title: data?.string('title') ?? '',
      description: data?.string('description') ?? '',
      volunteer: data?.integer('volunteer') ?? 0,
      volunteersAccepted: data?.integer('volunteersAccepted') ?? 0,
      StartAddress: data?.string('StartAddress') ?? '',
      EndAddress: data?.string('EndAddress') ?? '',
      StartLocation: LatLng(
        double.tryParse(startParts[0]) ?? 0.0,
        double.tryParse(startParts[1]) ?? 0.0,
      ),
      EndLocation: LatLng(
        double.tryParse(endParts[0]) ?? 0.0,
        double.tryParse(endParts[1]) ?? 0.0,
      ),
      Status: data?.string('Status') ?? '',
      proofs: (data?['proofs'] as List<dynamic>? ?? [])
          .map(
            (e) => Proof(
          message: e['message'] ?? '',
          mediaPaths: List<String>.from(e['mediaPaths'] ?? []),
        ),
      )
          .toList(),
    );
  }

  Future<void> updateTask(Task updatedTask) async {
    final db = await _core.database;
    final doc = MutableDocument.withId(
      updatedTask.id.toString(),
      {
        'type': 'task',
        'id': updatedTask.id,
        'title': updatedTask.title,
        'description': updatedTask.description,
        'volunteer': updatedTask.volunteer,
        'volunteersAccepted': updatedTask.volunteersAccepted,
        'StartAddress': updatedTask.StartAddress,
        'EndAddress': updatedTask.EndAddress,
        'StartLocation': updatedTask.StartLocation,
        'EndLocation': updatedTask.EndLocation,
        'Status': updatedTask.Status,
      }
    );
    await db.saveDocument(doc);
    debugPrint("Task updated in Couchbase: ${updatedTask.title}");
  }
}
