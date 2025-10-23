import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class ResponsedbHelper {
  final _core = CouchbaseCoreHelper();

  Future<String> addResponse(ResponseModel response) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final doc = MutableDocument.withId(response.id, {
      'type': 'response',
      'id': response.id,
      'requestId': response.requestId,
      'responderName': response.responderName,
      'message': response.message,
      'quantityProvided': response.quantityProvided,
      'taskAssigned': response.taskAssigned,
      'location':
          '${response.location.latitude},${response.location.longitude}',
    });

    await collection.saveDocument(doc);
    debugPrint(
      "Response saved in Couchbase: ${response.id}, RequestId: ${response.requestId}",
    );
    return response.id;
  }

  Future<List<ResponseModel>> getAllResponses() async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final dbName = 'dhap';

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.collection(collection))
        .where(
          Expression.property('type').equalTo(Expression.string('response')),
        );

    final result = await query.execute();

    final List<ResponseModel> responses = [];

    await for (final row in result.asStream()) {
      final data = row.dictionary(collection.name);

      if (data != null) {
        final dataMap = Map<String, dynamic>.from(data.toPlainMap());
        final geoParts = (dataMap['location'] as String? ?? "0,0").split(',');
        responses.add(
          ResponseModel(
            id: data.string('id'),
            requestId: data.string('requestId') ?? " ",
            responderName: data.string('responderName') ?? '',
            message: data.string('message') ?? '',
            quantityProvided: data.integer('quantityProvided'),
            address: data.string('address') ?? '',
            taskAssigned: data.boolean('taskAssigned'),
            location: LatLng(
              double.tryParse(geoParts[0]) ?? 0.0,
              double.tryParse(geoParts[1]) ?? 0.0,
            ),
          ),
        );
      }
    }

    return responses;
  }

  Future<List<ResponseModel>> getResponsesForRequest(String requestId) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.collection(collection))
        .where(
          Expression.property('type')
              .equalTo(Expression.string('response'))
              .and(
                Expression.property(
                  'requestId',
                ).equalTo(Expression.string(requestId)),
              ),
        );

    final result = await query.execute();
    final List<ResponseModel> responses = [];

    await for (final row in result.asStream()) {
      final dict = row.dictionary(db.name);
      if (dict == null) continue;
      //debugPrint("dict: ${dict.string()}");

      final locationString = dict.string('location') ?? "0,0";
      final parts = locationString.split(',');

      responses.add(
        ResponseModel(
          id: dict.string('id') ?? '',
          requestId: dict.string('requestId') ?? '',
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

  Future<void> assignTaskFromResponse(String responseId) async {
    final db = await _core.database;
    final collection = await db.defaultCollection;

    final doc = await collection.document(responseId);

    if (doc == null) {
      debugPrint("Response not found: $responseId");
      return;
    }

    debugPrint("doc: $doc");

    final mutableDoc = doc.toMutable();
    mutableDoc.setBoolean(key: 'taskAssigned', true);
    await collection.saveDocument(mutableDoc);
    debugPrint("Task assigned to response: $responseId");
  }
}
