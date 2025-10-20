import 'package:dhap_flutter_project/data/db/applicationdb_helper.dart';
import 'package:dhap_flutter_project/data/model/application_model.dart';

class ApplicationRepository {
  final ApplicationDbHelper _dbHelper = ApplicationDbHelper();
  Future<void> addApplication(String email, String message) async {
    await _dbHelper.addApplication(email, message);
  }

  Future<void> acceptApplication(String applicationId, {bool promoteUser = true}) async {
    await _dbHelper.acceptApplication(applicationId, promoteUser: promoteUser);
  }

  Future<void> rejectApplication(String applicationId) async {
    await _dbHelper.rejectApplication(applicationId);
  }

  Future<List<CoordinatorApplication>> getAllApplications() async {
    return await _dbHelper.getAllApplications();
  }

}