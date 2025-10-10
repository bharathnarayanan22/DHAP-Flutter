import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class RequestdbHelper {
  final _core = CouchbaseCoreHelper();

  Future<void> addRequest(Request request) async {
    final db = await _core.database;
    debugPrint('DB: ${db.name}');

    final doc = MutableDocument.withId(
      '${request.id}',
      {
        'type': 'request',
        'id': request.id,
        'resource': request.resource,
        'quantity': request.quantity,
        'description': request.description,
        'address': request.address,
        'location': '${request.location.latitude},${request.location.longitude}',
        'status': request.status,
        'responseIds': request.responseIds,
      },
    );

    debugPrint("Request document: $doc");

    await db.saveDocument(doc);
    debugPrint("Request saved in Couchbase: ${request.resource}");
  }

  Future<List<Request>> getAllRequests() async {
    final db = await _core.database;
    final dbName = 'dhap';

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.database(db!))
        .where(
      Expression.property('type').equalTo(Expression.string('request')),
    );

    final result = await query.execute();

    final List<Request> requests = [];

    await for (final row in result.asStream()) {
      final data = row.dictionary(dbName);

      debugPrint('Data: $data');

      if (data != null) {
        final dataMap = Map<String, dynamic>.from(data.toPlainMap());
        final geoParts = (dataMap['location'] as String? ?? "0,0").split(',');
        requests.add(
          Request(
            id: data.integer('id'),
            resource: data.string('resource') ?? '',
            quantity: data.integer('quantity'),
            address: data.string('address') ?? '',
            description: data.string('description') ?? '',
            location: LatLng(
              double.tryParse(geoParts[0]) ?? 0.0,
              double.tryParse(geoParts[1]) ?? 0.0,
            ),
            status: data.string('status') ?? '',
            responseIds: List<int>.from(data.array('responseIds')?.toList() ?? []),
          ),
        );
      }
    }

    return requests;
  }

  Future<void> AddResponseID(int requestId, int responseId) async {
    final db = await _core.database;
    debugPrint('DB: ${db.name}');
    debugPrint("Adding response ID $responseId to request $requestId");
    final doc = await db.document('$requestId');
    debugPrint("Request document: $doc");
    if (doc == null) {
      debugPrint("Request not found: $requestId");
      return;
    }

    final mutableDoc = doc.toMutable();
    final existingResponseIds = List<int>.from(
      mutableDoc.array('responseIds')?.toList() ?? [],
    );

    if (!existingResponseIds.contains(responseId)) {
      existingResponseIds.add(responseId);
      mutableDoc.setArray(key: 'responseIds', MutableArray(existingResponseIds));
      await db.saveDocument(mutableDoc);
      debugPrint("Response ID $responseId added to request $requestId");
    } else {
      debugPrint("Response ID already exists for request $requestId");
    }
  }


}