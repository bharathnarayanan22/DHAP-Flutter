import 'package:dhap_flutter_project/data/db/userdb_helper.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';


class UserRepository {
  final Userdb_helper _dbHelper = Userdb_helper();

  Future<void> addUser(User user) async {
    await _dbHelper.saveUser(user);
  }

  Future<List<User>> getAllUsers() async {
    return await _dbHelper.getAllUsers();
  }

  Future<User?> getUserByEmail(String email) async {
    return await _dbHelper.getUserByEmail(email);
  }

  Future<void> acceptTask(String taskId, String userEmail) async {
    await _dbHelper.acceptTask(taskId, userEmail);
  }

  Future<void> updateUserRole(String email, String newRole) async {
    await _dbHelper.updateUserRole(email, newRole);
  }
}
