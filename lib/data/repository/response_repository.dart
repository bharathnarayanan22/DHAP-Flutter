import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:latlong2/latlong.dart';

class ResponseRepository {
  final List<ResponseModel> _responses = [
    // ResponseModel(
    //   requestId: 1,
    //   responderName: "Alice Johnson",
    //   message: "I can provide 50 units of bottled water for the relief effort.",
    //   quantityProvided: 50,
    //   location: LatLng(37.7749, -122.4194),
    // ),
    // ResponseModel(
    //   requestId: 1,
    //   responderName: "Bob Smith",
    //   message: "Donating 20 blankets to the shelter.",
    //   quantityProvided: 20,
    //   location: LatLng(37.7749, -122.4194),
    // ),
    // ResponseModel(
    //   requestId: 2,
    //   responderName: "Clara Williams",
    //   message: "I have 10 first-aid kits available for delivery tomorrow.",
    //   quantityProvided: 10,
    //   location: LatLng(37.7749, -122.4194),
    // ),
    // ResponseModel(
    //   requestId: 3,
    //   responderName: "David Brown",
    //   message: "Providing 100 meals for the community kitchen.",
    //   quantityProvided: 100,
    //   location: LatLng(37.7749, -122.4194),
    // ),
    // ResponseModel(
    //   requestId: 2,
    //   responderName: "Emma Davis",
    //   message: "Can supply 5 boxes of non-perishable food items.",
    //   quantityProvided: 5,
    //   location: LatLng(37.7749, -122.4194),
    // ),
  ];

  void addResponse(ResponseModel response) {
    _responses.add(response);
  }

  List<ResponseModel> getAllResponses() {
    return List.unmodifiable(_responses);
  }

  List<ResponseModel> getResponsesForRequest(int requestId) {
    return _responses.where((res) => res.requestId == requestId).toList();
  }
}
