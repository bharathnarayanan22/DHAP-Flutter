import 'package:latlong2/latlong.dart';

class ResponseModel {
  static int _counter = 0;
  final int id;
  final int requestId;
  final String responderName;
  final String message;
  final int quantityProvided;
  final LatLng location;
  //final DateTime timestamp;

  ResponseModel({
    required this.requestId,
    required this.responderName,
    required this.message,
    required this.quantityProvided,
    required this.location,
    //DateTime? timestamp,
  })  : id = ++_counter;
}
