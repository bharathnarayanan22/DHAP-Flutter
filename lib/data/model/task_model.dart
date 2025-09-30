import 'package:latlong2/latlong.dart';

class Task {
  static int _counter = 0;
  final int id;

  final String title;
  final String description;
  final int volunteer;
  final String StartAddress;
  final String EndAddress;
  final LatLng StartLocation;
  final LatLng EndLocation;
  String Status;

  Task({
    required this.title,
    required this.description,
    required this.volunteer,
    required this.StartAddress,
    required this.EndAddress,
    required this.StartLocation,
    required this.EndLocation,
    this.Status = "In Progress",
  }) : id = ++_counter;

}
