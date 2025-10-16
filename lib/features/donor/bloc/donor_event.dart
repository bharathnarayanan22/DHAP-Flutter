import 'package:latlong2/latlong.dart';

abstract class DonorEvent {}

class AddResourceEvent extends DonorEvent {
  final String resource;
  final int quantity;
  final String address;
  final LatLng location;
  final String DonorName;
  final String userEmail;
  final String ResourceType;


  AddResourceEvent({
    required this.resource,
    required this.quantity,
    required this.address,
    required this.location,
    required this.DonorName,
    required this.userEmail,
    required this.ResourceType,
  });
}

class FetchRequestsEvent extends DonorEvent {}

class RespondEvent extends DonorEvent {
  final String requestId;
  final String message;
  final int quantityProvided;
  final LatLng location;
  final String address;
  final String user;
  final String userEmail;
  //final DateTime timestamp;



  RespondEvent({
    required this.requestId,
    required this.message,
    required this.quantityProvided,
    required this.location,
    required this.address,
    required this.user,
    required this.userEmail,
  });

  @override
  List<Object> get props => [requestId, message, quantityProvided, location, user, address, userEmail];
}

