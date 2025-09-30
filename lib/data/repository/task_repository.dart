import '../model/task_model.dart';

class TaskRepository {

  TaskRepository() {}

  final List<Task> _tasks = [];

  void addTask(Task task) {
    _tasks.add(task);
  }

  List<Task> getAllTasks() {
    return List.unmodifiable(_tasks);
  }

  void deleteTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  void clearTasks() {
    _tasks.clear();
  }
}
