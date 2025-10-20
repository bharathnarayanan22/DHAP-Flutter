import 'package:uuid/uuid.dart';

final uuid = Uuid();

class CoordinatorApplication {
  final String id;
  final String email;
  final String message;
  final String status;
  final DateTime submittedAt;

  CoordinatorApplication({
    String? id,
    required this.email,
    required this.message,
    this.status = 'pending',
    DateTime? submittedAt,
  }) : submittedAt = submittedAt ?? DateTime.now(),
       id = id ?? uuid.v4();

}