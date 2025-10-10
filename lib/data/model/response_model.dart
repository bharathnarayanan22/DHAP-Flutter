import 'package:latlong2/latlong.dart';

class ResponseModel {
  static int _counter = 500;
  final int id;
  final int requestId;
  final String responderName;
  final String message;
  final int quantityProvided;
  final String address;
  final LatLng location;
  bool taskAssigned;
  //final DateTime timestamp;

  ResponseModel({
    int? id,
    required this.requestId,
    required this.responderName,
    required this.message,
    required this.quantityProvided,
    required this.address,
    required this.location,
    this.taskAssigned = false,
    //DateTime? timestamp,
  })  : id = id ?? ++_counter;
}
