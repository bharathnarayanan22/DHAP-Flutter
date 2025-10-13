import 'package:dhap_flutter_project/data/db/resourcedb_helper.dart';
import 'package:latlong2/latlong.dart';

import '../model/resource_model.dart';

class ResourceRepository {
  ResourceRepository();

  final List<ResourceModel> _resources = [
    // Resource(
    //   resource: "Water Bottles",
    //   quantity: 50,
    //   address: "Relief Camp, Main Road, Chennai",
    //   location: LatLng(13.0827, 80.2707), // Chennai
    //   DonorName: "Red Cross",
    // ),
    // Resource(
    //   resource: "Blankets",
    //   quantity: 30,
    //   address: "Community Hall, Kochi",
    //   location: LatLng(9.9312, 76.2673), // Kochi
    //   DonorName: "Helping Hands NGO",
    // ),
    // Resource(
    //   resource: "Rice Bags",
    //   quantity: 20,
    //   address: "Relief Center, Hyderabad",
    //   location: LatLng(17.3850, 78.4867), // Hyderabad
    //   DonorName: "Local Volunteers",
    // ),
    // Resource(
    //   resource: "First Aid Kits",
    //   quantity: 15,
    //   address: "Health Camp, Bengaluru",
    //   location: LatLng(12.9716, 77.5946), // Bengaluru
    //   DonorName: "Doctors Without Borders",
    // ),
    // Resource(
    //   resource: "Clothes",
    //   quantity: 40,
    //   address: "Distribution Point, Kolkata",
    //   location: LatLng(22.5726, 88.3639), // Kolkata
    //   DonorName: "Relief Foundation",
    // ),
    // Resource(
    //   resource: "Clothes",
    //   quantity: 40,
    //   address: "Distribution Point, Kolkata",
    //   location: LatLng(22.5726, 88.3639), // Kolkata
    //   DonorName: "Relief Foundation",
    // ),
    // Resource(
    //   resource: "Clothes",
    //   quantity: 40,
    //   address: "Distribution Point, Kolkata",
    //   location: LatLng(22.5726, 88.3639), // Kolkata
    //   DonorName: "Relief Foundation",
    // ),
    // Resource(
    //   resource: "Clothes",
    //   quantity: 40,
    //   address: "Distribution Point, Kolkata",
    //   location: LatLng(22.5726, 88.3639), // Kolkata
    //   DonorName: "Relief Foundation",
    // ),
    // Resource(
    //   resource: "Clothes",
    //   quantity: 40,
    //   address: "Distribution Point, Kolkata",
    //   location: LatLng(22.5726, 88.3639), // Kolkata
    //   DonorName: "Relief Foundation",
    // ),
    // Resource(
    //   resource: "Clothes",
    //   quantity: 40,
    //   address: "Distribution Point, Kolkata",
    //   location: LatLng(22.5726, 88.3639), // Kolkata
    //   DonorName: "Relief Foundation",
    // ),
  ];

  final ResourcedbHelper _dbHelper = ResourcedbHelper();

  Future<void> addResource(ResourceModel resource) async {
    await _dbHelper.addResource(resource);
  }

  Future<List<ResourceModel>> getAllResources() async {
    return await _dbHelper.getAllResources();
  }

  // List<ResourceModel> getResources() {
  //   return List.unmodifiable(_resources);
  // }

  void deleteResource(String id) {
    _resources.removeWhere((resource) => resource.id == id);
  }

  void clearResources() {
    _resources.clear();
  }
}