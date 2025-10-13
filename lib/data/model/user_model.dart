import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();
class User {
  //static int Counter = 100;
  final String id;
  final String name;
  final String email;
  final String password;
  final String mobile;
  final String addressLine;
  final String city;
  final String country;
  final String pincode;
  final String role;
  bool inTask;
  final List<String> taskIds;
  final List<String> resourceIds;

  User({
    String? id,
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    required this.addressLine,
    required this.city,
    required this.country,
    required this.pincode,
    required this.role,
    this.inTask = false,
    List<String>? taskIds,
    List<String>? resourceIds,
  }) : id = id ?? uuid.v4(),
     taskIds = taskIds ?? [],
     resourceIds = resourceIds ?? [];
}
