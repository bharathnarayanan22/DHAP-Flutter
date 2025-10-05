import 'package:latlong2/latlong.dart';

class Request {
  static int _counter = 0;
  final int id;
  final String resource;
  final int quantity;
  final String description;
  final String address;
  final LatLng location;
  String status;
  final List<int> responseIds;

  Request({
    required this.resource,
    required this.quantity,
    required this.description,
    required this.address,
    required this.location,
    this.status = 'Pending',
    List<int>? responseIds,
  }) : id = ++_counter,
        responseIds = responseIds ?? [];
}