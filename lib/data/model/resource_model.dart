import 'package:latlong2/latlong.dart';

class ResourceModel {
  static int _counter = 0;
  final int id;
  final String resource;
  final int quantity;
  final String address;
  final LatLng location;
  final String DonorName;

  ResourceModel({
    required this.resource,
    required this.quantity,
    required this.address,
    required this.location,
    required this.DonorName,
  }) : id = ++_counter;
}