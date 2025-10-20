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
  bool isCoordinator;
  bool isSubmitted;
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
    this.isCoordinator = false,
    this.isSubmitted = false,
    List<String>? taskIds,
    List<String>? resourceIds,
  }) : id = id ?? uuid.v4(),
     taskIds = taskIds ?? [],
     resourceIds = resourceIds ?? [];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? mobile,
    String? addressLine,
    String? city,
    String? country,
    String? pincode,
    String? role,
    List<String>? taskIds,
    List<String>? resourceIds,
    bool? inTask,
    bool? isCoordinator,
    bool? isSubmitted,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      mobile: mobile ?? this.mobile,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      role: role ?? this.role,
      taskIds: taskIds ?? this.taskIds,
      resourceIds: resourceIds ?? this.resourceIds,
      inTask: inTask ?? this.inTask,
      isCoordinator: isCoordinator ?? this.isCoordinator,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

}


