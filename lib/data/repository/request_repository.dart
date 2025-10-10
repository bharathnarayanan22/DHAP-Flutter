import 'package:dhap_flutter_project/data/db/requestdb_helper.dart';
import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:latlong2/latlong.dart';

class RequestRepository {
  RequestRepository();

  final List<Request> _requests = [
    // Request(
    //   resource: "Bottled Water",
    //   quantity: 100,
    //   description: "Urgent need for bottled water for flood relief camp.",
    //   address: "Relief Camp, Coimbatore, India",
    //   location: LatLng(10.9973691, 76.9588876),
    //   status: "Pending",
    //   responseIds: [1, 2],
    // ),
    // Request(
    //   resource: "Medical Supplies",
    //   quantity: 20,
    //   description: "Need first-aid kits and bandages for medical outreach.",
    //   address: "Community Clinic, Trichy, India",
    //   location: LatLng(10.7904833, 78.7046725),
    //   status: "Pending",
    //   responseIds: [3, 5],
    // ),
    // Request(
    //   resource: "Meals",
    //   quantity: 200,
    //   description: "Hot meals required for community kitchen serving displaced families.",
    //   address: "Community Kitchen, Chennai, India",
    //   location: LatLng(13.0826802, 80.2707184),
    //   status: "Pending",
    //   responseIds: [],
    // ),
    // Request(
    //   resource: "Blankets",
    //   quantity: 50,
    //   description: "Blankets needed for temporary shelter during cold weather.",
    //   address: "Shelter Home, Madurai, India",
    //   location: LatLng(9.9252007, 78.1197754),
    //   status: "Completed",
    //   responseIds: [2],
    // ),
    // Request(
    //   resource: "Non-Perishable Food",
    //   quantity: 30,
    //   description: "Canned food and dry goods for emergency food distribution.",
    //   address: "Distribution Center, Salem, India",
    //   location: LatLng(11.664325, 78.1460142),
    //   status: "Pending",
    //   responseIds: [5],
    // ),
  ];

  final RequestdbHelper _dbHelper =RequestdbHelper();

  Future<void> addRequest(Request request) async {
    await _dbHelper.addRequest(request);
  }

  Future<List<Request>> getAllRequests() async {
    return await _dbHelper.getAllRequests();
  }

}