import 'package:dhap_flutter_project/data/model/request_model.dart';

class RequestRepository {
  RequestRepository() {}

  final List<Request> _requests = [];

  void addRequest(Request request) {
    _requests.add(request);
  }

  List<Request> getAllRequests() {
    return List.unmodifiable(_requests);
  }

}