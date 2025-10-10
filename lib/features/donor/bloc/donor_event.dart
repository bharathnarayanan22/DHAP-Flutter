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

class FetchRequestsEvent extends DonorEvent {}

class RespondEvent extends DonorEvent {
  final int requestId;
  final String message;
  final int quantityProvided;
  final LatLng location;
  final String address;
  final String user;
  //final DateTime timestamp;



  RespondEvent({
    required this.requestId,
    required this.message,
    required this.quantityProvided,
    required this.location,
    required this.address,
    required this.user,
  });

  @override
  List<Object> get props => [requestId, message, quantityProvided, location, user, address];
}

