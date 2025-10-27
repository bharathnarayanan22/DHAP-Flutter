import 'package:latlong2/latlong.dart';

abstract class commonEvent {}

class FetchUserData extends commonEvent {}

class LogoutSubmitted extends commonEvent {}

class SwitchRoleSubmitted extends commonEvent {
  final String email;
  final String newRole;
  SwitchRoleSubmitted({required this.email, required this.newRole});
}

class FetchDataEvent extends commonEvent {}

class BecomeCoSubmitted extends commonEvent {
  final String message;
  final String email;
  BecomeCoSubmitted({required this.message, required this.email});
}

class CreateTaskEvent extends commonEvent {
  final String title;
  final String description;
  final int volunteer;
  final String StartAddress;
  final String EndAddress;
  final LatLng StartLocation;
  final LatLng EndLocation;

  CreateTaskEvent({
    required this.title,
    required this.description,
    required this.volunteer,
    required this.StartAddress,
    required this.EndAddress,
    required this.StartLocation,
    required this.EndLocation,
  });
}

class CreateResourceRequestEvent extends commonEvent {
  final String resource;
  final int quantity;
  final String description;
  final String address;
  final LatLng location;

  CreateResourceRequestEvent({
    required this.resource,
    required this.quantity,
    required this.description,
    required this.address,
    required this.location,
  });
}

class FetchNewsEvent extends commonEvent {}
