import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Proof {
  final String message;
  final List<String> mediaPaths;

  Proof({required this.message, this.mediaPaths = const []});
}

class Task {
  final String id;
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
    String? id,
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
  }) : id = id ?? uuid.v4(); // 🔹 auto-generate UUID if not provided
}
