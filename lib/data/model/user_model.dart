import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:dhap_flutter_project/data/model/task_model.dart';

class User {
  static int Counter = 0;
  final int id;
  final String name;
  final String email;
  final String password;
  final String mobile;
  final String addressLine;
  final String city;
  final String country;
  final String pincode;
  final String role;

  final List<int> taskIds;
  final List<int> resourceIds;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    required this.addressLine,
    required this.city,
    required this.country,
    required this.pincode,
    required this.role,
    List<int>? taskIds,
    List<int>? resourceIds,
  }) : id = ++Counter,
     taskIds = taskIds ?? [],
     resourceIds = resourceIds ?? [];
}
