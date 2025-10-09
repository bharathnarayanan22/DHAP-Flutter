import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class RequestdbHelper {
  final _core = CouchbaseCoreHelper();

  Future<void> addRequest(Request request) async {
    final db = await _core.database;

    final doc = MutableDocument(
      // task.title,
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

    await db!.saveDocument(doc);
    debugPrint("Task saved in Couchbase: ${request.resource}");
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

      if (data != null) {
        final dataMap = Map<String, dynamic>.from(data.toPlainMap());
        final geoParts = (dataMap['location'] as String? ?? "0,0").split(',');
        requests.add(
          Request(
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
}