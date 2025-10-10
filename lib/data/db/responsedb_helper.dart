import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class ResponsedbHelper {
  final _core = CouchbaseCoreHelper();

  Future<void> addResponse(ResponseModel response) async {
    final db = await _core.database;
    final doc = MutableDocument.withId(
      '${response.id}',
      {
        'type': 'response',
        'id': response.id,
        'requestId': response.requestId,
        'responderName': response.responderName,
        'message': response.message,
        'quantityProvided': response.quantityProvided,
        'taskAssigned': response.taskAssigned,
        'location': '${response.location.latitude},${response.location.longitude}',
      },
    );

    await db.saveDocument(doc);
    debugPrint("Response saved in Couchbase: ${response.id}, RequestId: ${response.requestId}");
  }

  Future<List<ResponseModel>> getAllResponses() async {
    final db = await _core.database;
    final dbName = 'dhap';

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.database(db))
        .where(
      Expression.property('type').equalTo(Expression.string('response')),
    );

    final result = await query.execute();

    final List<ResponseModel> responses = [];

    await for (final row in result.asStream()) {
      final data = row.dictionary(dbName);

      if (data != null) {
        final dataMap = Map<String, dynamic>.from(data.toPlainMap());
        final geoParts = (dataMap['location'] as String? ?? "0,0").split(',');
        responses.add(
          ResponseModel(
            id: data.integer('id'),
            requestId: data.integer('requestId'),
            responderName: data.string('responderName') ?? '',
            message: data.string('message') ?? '',
            quantityProvided: data.integer('quantityProvided'),
            address: data.string('address') ?? '',
            taskAssigned: data.boolean('taskAssigned'),
            location: LatLng(
              double.tryParse(geoParts[0]) ?? 0.0,
              double.tryParse(geoParts[1]) ?? 0.0
            ),
          ),
        );
      }
    }

    return responses;
  }

  Future<List<ResponseModel>> getResponsesForRequest(int requestId) async {
    final db = await _core.database;

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.database(db))
        .where(
      Expression.property('type').equalTo(Expression.string('response'))
          .and(Expression.property('requestId').equalTo(Expression.integer(requestId))),
    );

    final result = await query.execute();
    final List<ResponseModel> responses = [];

    await for (final row in result.asStream()) {
      final dict = row.dictionary(db.name);
      if (dict == null) continue;

      final locationString = dict.string('location') ?? "0,0";
      final parts = locationString.split(',');

      responses.add(
        ResponseModel(
          requestId: dict.integer('requestId'),
          responderName: dict.string('responderName') ?? '',
          message: dict.string('message') ?? '',
          quantityProvided: dict.integer('quantityProvided'),
          taskAssigned: dict.boolean('taskAssigned'),
          address: dict.string('address') ?? '',
          location: LatLng(
            double.tryParse(parts[0]) ?? 0.0,
            double.tryParse(parts[1]) ?? 0.0,
          ),
        ),
      );
    }

    return responses;
  }

  Future<void> assignTaskFromResponse(int responseId) async {
    final db = await _core.database;

    final doc = await db.document('${responseId}');

    if (doc == null) {
      debugPrint("Response not found: $responseId");
      return;
    }

    final mutableDoc = doc.toMutable();
    mutableDoc.setBoolean(key: 'taskAssigned', true);
    await db.saveDocument(mutableDoc);
    debugPrint("Task assigned to response: $responseId");
  }
}