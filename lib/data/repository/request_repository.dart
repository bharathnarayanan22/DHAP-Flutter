import 'package:dhap_flutter_project/data/db/requestdb_helper.dart';
import 'package:dhap_flutter_project/data/model/request_model.dart';

class RequestRepository {
  RequestRepository();


  final RequestdbHelper _dbHelper =RequestdbHelper();

  Future<void> addRequest(Request request) async {
    await _dbHelper.addRequest(request);
  }

  Future<List<Request>> getAllRequests() async {
    return await _dbHelper.getAllRequests();
  }

  Stream<List<Request>> watchAllRequests() async* {
    yield* _dbHelper.watchAllRequests();
  }
}