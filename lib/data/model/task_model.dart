import 'package:latlong2/latlong.dart';

class Proof {
  final String message;
  final List<String> mediaPaths;
  Proof({required this.message, this.mediaPaths = const []});
}


class Task {
  static int _counter = 0;
  final int id;

  final String title;
  final String description;
  final int volunteer;
  int volunteersAccepted;
  final String StartAddress;
  final String EndAddress;
  final LatLng StartLocation;
  final LatLng EndLocation;
  String Status;

  List<Proof> proofs;

  Task({
    int? id,
    required this.title,
    required this.description,
    required this.volunteer,
    this.volunteersAccepted = 0,
    required this.StartAddress,
    required this.EndAddress,
    required this.StartLocation,
    required this.EndLocation,
    this.Status = "In Progress",
    this.proofs = const [],
  }) : id = id ?? ++_counter;
}
