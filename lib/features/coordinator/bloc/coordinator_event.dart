import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class CoordinatorEvent {}

class CreateTaskEvent extends CoordinatorEvent {
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

class FetchTasksEvent extends CoordinatorEvent {}

class DeleteTaskEvent extends CoordinatorEvent {
  final int taskId;
  DeleteTaskEvent({required this.taskId});
}

class CreateResourceRequestEvent extends CoordinatorEvent {
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

class AddResourceEvent extends CoordinatorEvent {
  final String resource;
  final int quantity;
  final String address;
  final LatLng location;

  AddResourceEvent({
    required this.resource,
    required this.quantity,
    required this.address,
    required this.location,
  });
}

class FetchUsersEvent extends CoordinatorEvent {}

class FetchResourcesEvent extends CoordinatorEvent {}