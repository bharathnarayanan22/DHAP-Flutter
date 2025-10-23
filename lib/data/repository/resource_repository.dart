import 'package:dhap_flutter_project/data/db/resourcedb_helper.dart';

import '../model/resource_model.dart';

class ResourceRepository {
  ResourceRepository();


  final ResourcedbHelper _dbHelper = ResourcedbHelper();

  Future<String> addResource(ResourceModel resource) async {
    final String id = await _dbHelper.addResource(resource);
    return id;
  }

  Future<List<ResourceModel>> getAllResources() async {
    return await _dbHelper.getAllResources();
  }

  // List<ResourceModel> getResources() {
  //   return List.unmodifiable(_resources);
  // }

  void deleteResource(String id) {
    //_resources.removeWhere((resource) => resource.id == id);
  }

  void clearResources() {
    //_resources.clear();
  }
}