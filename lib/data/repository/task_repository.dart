// import 'package:dhap_flutter_project/data/db/taskdb_helper.dart';
// import 'package:flutter/cupertino.dart';
// import '../model/task_model.dart';
//
// class TaskRepository {
//
//   TaskRepository();
//
//
//   final TaskdbHelper _dbHelper = TaskdbHelper();
//
//   Future<void> addTask(Task task) async{
//     await _dbHelper.addTask(task);
//   }
//
//   Future<List<Task>> getAllTasks() async{
//     final tasks = await _dbHelper.getAllTasks();
//     debugPrint("Fetched tasks: $tasks");
//     return tasks;
//   }
//   Stream<List<Task>> watchAllTasks() async* {
//     final tasks = _dbHelper.watchAllTasks();
//     debugPrint("Fetched tasks: $tasks");
//     yield* tasks;
//   }
//
//
//   Future<void> deleteTask(String id) async {
//     await _dbHelper.deleteTask(id);
//   }
//
//
//
//
//   Future<void> updateTask(Task updatedTask) async {
//     await _dbHelper.updateTask(updatedTask);
//   }
// }
import 'dart:async';
import 'package:dhap_flutter_project/data/db/taskdb_helper.dart';
import 'package:flutter/cupertino.dart';
import '../model/task_model.dart';

class TaskRepository {
  TaskRepository() {
    _loadTasks();
  }

  final TaskdbHelper _dbHelper = TaskdbHelper();
  final _taskController = StreamController<List<Task>>.broadcast();
  List<Task> _tasks = [];

  Stream<List<Task>> watchAllTasks() => _taskController.stream;

  Future<void> _loadTasks() async {
    _tasks = await _dbHelper.getAllTasks();
    _taskController.add(_tasks);
  }

  Future<void> addTask(Task task) async {
    await _dbHelper.addTask(task);
    _tasks.add(task);
    _taskController.add(_tasks); // notify listeners
  }

  Future<List<Task>> getAllTasks() async {
    final tasks = await _dbHelper.getAllTasks();
    debugPrint("Fetched tasks: $tasks");
    return tasks;
  }

  Future<void> deleteTask(String id) async {
    await _dbHelper.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    _taskController.add(_tasks); // notify listeners
  }

  Future<void> updateTask(Task updatedTask) async {
    await _dbHelper.updateTask(updatedTask);
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _taskController.add(_tasks); // notify listeners
    }
  }

  void dispose() {
    _taskController.close();
  }
}
