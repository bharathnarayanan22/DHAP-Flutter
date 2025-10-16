import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();
class ResourceModel {
 // static int _counter = 300;
  final String id;
  final String resource;
  final int quantity;
  final String address;
  final LatLng location;
  final String DonorName;
  final String ResourceType;

  ResourceModel({
    String? id,
    required this.resource,
    required this.quantity,
    required this.address,
    required this.location,
    required this.DonorName,
    required this.ResourceType,
  }) : id = id ?? uuid.v4();
}