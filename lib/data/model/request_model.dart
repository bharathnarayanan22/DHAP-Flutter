import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Request {
  //static int _counter = 400;
  final String id;
  final String resource;
  final int quantity;
  final String description;
  final String address;
  final LatLng location;
  String status;
  final List<String> responseIds;

  Request({
    String? id,
    required this.resource,
    required this.quantity,
    required this.description,
    required this.address,
    required this.location,
    this.status = 'Pending',
    List<String>? responseIds,
  }) : id = id ?? uuid.v4(),
        responseIds = responseIds ?? [];
}