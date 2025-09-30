import 'package:dhap_flutter_project/data/model/user_model.dart';

class UserRepository {
  UserRepository() {}

  final List<User> _users = [
    User(
      name: "Arun Kumar",
      email: "arun@example.com",
      password: "pass123",
      mobile: "9876543210",
      addressLine: "12 Gandhi Street",
      city: "Chennai",
      country: "India",
      pincode: "600001",
      role: "Coordinator",
      taskIds: [1, 2],       // example task IDs
      resourceIds: [101],    // example resource IDs
    ),
    User(
      name: "Meera Sharma",
      email: "meera@example.com",
      password: "secure456",
      mobile: "9988776655",
      addressLine: "45 MG Road",
      city: "Bengaluru",
      country: "India",
      pincode: "560001",
      role: "Donor",
      taskIds: [],           // no tasks created
      resourceIds: [102, 103],
    ),
    User(
      name: "Ravi Patel",
      email: "ravi@example.com",
      password: "mypassword",
      mobile: "9123456789",
      addressLine: "22 Park Street",
      city: "Hyderabad",
      country: "India",
      pincode: "500001",
      role: "Volunteer",
      taskIds: [3],          // assigned to a task
      resourceIds: [],
    ),
    User(
      name: "Anita Singh",
      email: "anita@example.com",
      password: "volunteer789",
      mobile: "9871203456",
      addressLine: "88 Lake View Road",
      city: "Kolkata",
      country: "India",
      pincode: "700001",
      role: "Volunteer",
      taskIds: [2, 4],
      resourceIds: [],
    ),
    User(
      name: "Suresh Reddy",
      email: "suresh@example.com",
      password: "donor555",
      mobile: "9012345678",
      addressLine: "12 MG Street",
      city: "Chennai",
      country: "India",
      pincode: "600002",
      role: "Donor",
      taskIds: [],
      resourceIds: [104],
    ),
    User(
      name: "Arun Kumar",
      email: "arun@example.com",
      password: "pass123",
      mobile: "9876543210",
      addressLine: "12 Gandhi Street",
      city: "Chennai",
      country: "India",
      pincode: "600001",
      role: "Coordinator",
      taskIds: [1, 2],       // example task IDs
      resourceIds: [101],    // example resource IDs
    ),
    User(
      name: "Meera Sharma",
      email: "meera@example.com",
      password: "secure456",
      mobile: "9988776655",
      addressLine: "45 MG Road",
      city: "Bengaluru",
      country: "India",
      pincode: "560001",
      role: "Donor",
      taskIds: [],           // no tasks created
      resourceIds: [102, 103],
    ),User(
      name: "Arun Kumar",
      email: "arun@example.com",
      password: "pass123",
      mobile: "9876543210",
      addressLine: "12 Gandhi Street",
      city: "Chennai",
      country: "India",
      pincode: "600001",
      role: "Coordinator",
      taskIds: [1, 2],       // example task IDs
      resourceIds: [101],    // example resource IDs
    ),
    User(
      name: "Meera Sharma",
      email: "meera@example.com",
      password: "secure456",
      mobile: "9988776655",
      addressLine: "45 MG Road",
      city: "Bengaluru",
      country: "India",
      pincode: "560001",
      role: "Donor",
      taskIds: [],           // no tasks created
      resourceIds: [102, 103],
    ),User(
      name: "Arun Kumar",
      email: "arun@example.com",
      password: "pass123",
      mobile: "9876543210",
      addressLine: "12 Gandhi Street",
      city: "Chennai",
      country: "India",
      pincode: "600001",
      role: "Coordinator",
      taskIds: [1, 2],       // example task IDs
      resourceIds: [101],    // example resource IDs
    ),
    User(
      name: "Meera Sharma",
      email: "meera@example.com",
      password: "secure456",
      mobile: "9988776655",
      addressLine: "45 MG Road",
      city: "Bengaluru",
      country: "India",
      pincode: "560001",
      role: "Donor",
      taskIds: [],           // no tasks created
      resourceIds: [102, 103],
    ),
    User(
      name: "Arun Kumar",
      email: "arun@example.com",
      password: "pass123",
      mobile: "9876543210",
      addressLine: "12 Gandhi Street",
      city: "Chennai",
      country: "India",
      pincode: "600001",
      role: "Coordinator",
      taskIds: [1, 2],       // example task IDs
      resourceIds: [101],    // example resource IDs
    ),
    User(
      name: "Meera Sharma",
      email: "meera@example.com",
      password: "secure456",
      mobile: "9988776655",
      addressLine: "45 MG Road",
      city: "Bengaluru",
      country: "India",
      pincode: "560001",
      role: "Donor",
      taskIds: [],           // no tasks created
      resourceIds: [102, 103],
    ),


  ];


  void addUser(User user) {
    _users.add(user);
  }

  List<User> getAllUsers() {
    return List.unmodifiable(_users);
  }

}