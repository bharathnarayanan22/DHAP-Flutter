import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class ResourcedbHelper {
  final _core = CouchbaseCoreHelper();

  Future<void> addResource(ResourceModel resource) async {
    final db = await _core.database;
    final doc = MutableDocument.withId(
      resource.id,
      {
        'type': 'resource',
        'id': resource.id,
        'resource': resource.resource,
        'quantity': resource.quantity,
        'address': resource.address,
        'DonorName': resource.DonorName,
        'location': '${resource.location.latitude},${resource.location.longitude}',
      },
    );

    await db.saveDocument(doc);
    debugPrint("Task saved in Couchbase: ${resource.resource}");
  }

  // Future<List<ResourceModel>> getAllResources() async {
  //   final db = await _core.database;
  //   final dbName = 'dhap';
  //
  //   final query = await QueryBuilder.createAsync()
  //       .select(SelectResult.all())
  //       .from(DataSource.database(db))
  //       .where(
  //         Expression.property('type').equalTo(Expression.string('resource')),
  //       );
  //
  //   final result = await query.execute();
  //
  //   final List<ResourceModel> resources = [];
  //
  //   await for (final row in result.asStream()) {
  //     final data = row.dictionary(dbName);
  //
  //     if (data != null) {
  //       final dataMap = Map<String, dynamic>.from(data.toPlainMap());
  //       final geoParts = (dataMap['location'] as String? ?? "0,0").split(',');
  //       resources.add(
  //         ResourceModel(
  //           id: data.string('id') ?? '',
  //           resource: data.string('resource') ?? '',
  //           quantity: data.integer('quantity'),
  //           address: data.string('address') ?? '',
  //           DonorName: data.string('DonorName') ?? '',
  //           location: LatLng(
  //             double.tryParse(geoParts[0]) ?? 0.0,
  //             double.tryParse(geoParts[1]) ?? 0.0,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  //
  //   return resources;
  // }

  Future<List<ResourceModel>> getAllResources() async {
    final db = await _core.database;
    final dbName = 'dhap';

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.database(db))
        .where(
      Expression.property('type').equalTo(Expression.string('resource')),
    );

    final result = await query.execute();

    final List<ResourceModel> resources = [];

    await for (final row in result.asStream()) {
      final data = row.dictionary(dbName);
      if (data == null) continue;

      final dataMap = Map<String, dynamic>.from(data.toPlainMap());

      double lat = 0.0, lng = 0.0;

      final locationRaw = dataMap['location'];
      if (locationRaw is String) {
        final parts = locationRaw.split(',');
        lat = double.tryParse(parts[0]) ?? 0.0;
        lng = double.tryParse(parts[1]) ?? 0.0;
      } else if (locationRaw is Map) {
        lat = (locationRaw['latitude'] as num?)?.toDouble() ?? 0.0;
        lng = (locationRaw['longitude'] as num?)?.toDouble() ?? 0.0;
      }

      resources.add(
        ResourceModel(
          id: data.string('id') ?? '',
          resource: data.string('resource') ?? '',
          quantity: data.integer('quantity'),
          address: data.string('address') ?? '',
          DonorName: data.string('DonorName') ?? '',
          location: LatLng(lat, lng),
        ),
      );
    }

    return resources;
  }

  Future<void> deleteResource(String id) async {
    final db = await _core.database;
    final doc = await db.document(id);
    if (doc != null) {
      await db.deleteDocument(doc);
      debugPrint("Task deleted: $id");
    }
  }
}
