import 'package:dhap_flutter_project/data/db/taskdb_helper.dart';
import 'package:flutter/cupertino.dart';
import '../model/task_model.dart';

class TaskRepository {

  TaskRepository();

  final List<Task> _tasks = [
    // Task(
    //   id: 1,
    //   title: "Deliver Water Bottles",
    //   description: "Transport 100 bottles from Chennai warehouse to Bangalore relief center.",
    //   volunteer: 1,
    //   StartAddress: "Chennai Warehouse, Tamil Nadu",
    //   EndAddress: "Relief Center, Bangalore, Karnataka",
    //   StartLocation: LatLng(13.0827, 80.2707), // Chennai
    //   EndLocation: LatLng(12.9716, 77.5946),   // Bangalore
    //   Status: "In Progress",
    // ),
    // Task(
    //   id: 2,
    //   title: "Medical Supplies",
    //   description: "Deliver first aid kits from Coimbatore to Kochi.",
    //   volunteer: 2,
    //   StartAddress: "Health Center, Coimbatore, Tamil Nadu",
    //   EndAddress: "Community Clinic, Kochi, Kerala",
    //   StartLocation: LatLng(11.0168, 76.9558), // Coimbatore
    //   EndLocation: LatLng(9.9312, 76.2673),    // Kochi
    //   Status: "In Verification",
    // ),
    // Task(
    //   id: 3,
    //   title: "Food Packets Distribution",
    //   description: "Send 500 food packets from Hyderabad to Vijayawada flood relief camp.",
    //   volunteer: 3,
    //   StartAddress: "NGO Office, Hyderabad, Telangana",
    //   EndAddress: "Relief Camp, Vijayawada, Andhra Pradesh",
    //   StartLocation: LatLng(17.3850, 78.4867), // Hyderabad
    //   EndLocation: LatLng(16.5062, 80.6480),   // Vijayawada
    //   Status: "Completed",
    // ),
    // Task(
    //   id: 4,
    //   title: "Blanket Transport",
    //   description: "Move blankets from Delhi to Lucknow for winter relief.",
    //   volunteer: 4,
    //   StartAddress: "Central Warehouse, Delhi",
    //   EndAddress: "Relief Center, Lucknow, UP",
    //   StartLocation: LatLng(28.7041, 77.1025), // Delhi
    //   EndLocation: LatLng(26.8467, 80.9462),   // Lucknow
    //   Status: "Completed",
    // ),
    // Task(
    //   id: 5,
    //   title: "Education Kit Delivery",
    //   description: "Distribute school kits from Pune to Nagpur rural schools.",
    //   volunteer: 5,
    //   StartAddress: "Education Store, Pune, Maharashtra",
    //   EndAddress: "Government School, Nagpur, Maharashtra",
    //   StartLocation: LatLng(18.5204, 73.8567), // Pune
    //   EndLocation: LatLng(21.1458, 79.0882),   // Nagpur
    //   Status: "Pending",
    // ),
  ];

  final TaskdbHelper _dbHelper = TaskdbHelper();

  Future<void> addTask(Task task) async{
    await _dbHelper.addTask(task);
  }

  Future<List<Task>> getAllTasks() async{
    final tasks = await _dbHelper.getAllTasks();
    debugPrint("Fetched tasks: $tasks");
    return tasks;
  }

  Future<void> deleteTask(String id) async {
    await _dbHelper.deleteTask(id);
  }

  void clearTasks() {
    _tasks.clear();
  }

  Task getTaskById(String id) {
    return _tasks.firstWhere((task) => task.id == id);
  }


  Future<void> updateTask(Task updatedTask) async {
    await _dbHelper.updateTask(updatedTask);
  }
}
