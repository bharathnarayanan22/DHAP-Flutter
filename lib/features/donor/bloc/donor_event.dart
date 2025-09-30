import 'package:latlong2/latlong.dart';

abstract class DonorEvent {}

class AddResourceEvent extends DonorEvent {
  final String resource;
  final int quantity;
  final String address;
  final LatLng location;
  final String DonorName;

  AddResourceEvent({
    required this.resource,
    required this.quantity,
    required this.address,
    required this.location,
    required this.DonorName,
  });
}