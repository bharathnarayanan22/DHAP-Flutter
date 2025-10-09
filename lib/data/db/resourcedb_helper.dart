import 'package:cbl/cbl.dart';
import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class ResourcedbHelper {
  final _core = CouchbaseCoreHelper();

  Future<void> addResource(ResourceModel resource) async {
    final db = await _core.database;
    final doc = MutableDocument(
      // task.title,
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

    await db!.saveDocument(doc);
    debugPrint("Task saved in Couchbase: ${resource.resource}");
  }

  Future<List<ResourceModel>> getAllResources() async {
    final db = await _core.database;
    final dbName = 'dhap';

    final query = await QueryBuilder.createAsync()
        .select(SelectResult.all())
        .from(DataSource.database(db!))
        .where(
          Expression.property('type').equalTo(Expression.string('resource')),
        );

    final result = await query.execute();

    final List<ResourceModel> resources = [];

    await for (final row in result.asStream()) {
      final data = row.dictionary(dbName);

      if (data != null) {
        final dataMap = Map<String, dynamic>.from(data.toPlainMap());
        final geoParts = (dataMap['location'] as String? ?? "0,0").split(',');
        resources.add(
          ResourceModel(
            resource: data.string('resource') ?? '',
            quantity: data.integer('quantity'),
            address: data.string('address') ?? '',
            DonorName: data.string('DonorName') ?? '',
            location: LatLng(
              double.tryParse(geoParts[0]) ?? 0.0,
              double.tryParse(geoParts[1]) ?? 0.0,
            ),
          ),
        );
      }
    }

    return resources;
  }

  Future<void> deleteResource(int id) async {
    final db = await _core.database;
    final doc = await db.document(id.toString());
    if (doc != null) {
      await db.deleteDocument(doc);
      debugPrint("Task deleted: $id");
    }
  }
}
