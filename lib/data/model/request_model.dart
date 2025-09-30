import 'package:latlong2/latlong.dart';

class Request {
  static int _counter = 0;
  final int id;
  final String resource;
  final int quantity;
  final String description;
  final String address;
  final LatLng location;

  Request({
    required this.resource,
    required this.quantity,
    required this.description,
    required this.address,
    required this.location,
  }) : id = ++_counter;
}