import 'package:dhap_flutter_project/data/db/requestdb_helper.dart';
import 'package:dhap_flutter_project/data/db/responsedb_helper.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:flutter/cupertino.dart';
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

  final ResponsedbHelper _dbHelper = ResponsedbHelper();
  final RequestdbHelper _requestdbHelper = RequestdbHelper();


  Future<void> addResponse(ResponseModel response) async {
    await _dbHelper.addResponse(response);
    debugPrint("Response added: ${response.id}, ${response.requestId}");
    await _requestdbHelper.AddResponseID(response.requestId, response.id);

  }

  Future<List<ResponseModel>> getAllResponses() async {
    return await _dbHelper.getAllResponses();
  }


  List<ResponseModel> getResponsesForRequest(int requestId) {
    return _responses.where((res) => res.requestId == requestId).toList();
  }

  Future<void> assignTaskFromResponse(int responseId) async {
    await _dbHelper.assignTaskFromResponse(responseId);
  }
}
