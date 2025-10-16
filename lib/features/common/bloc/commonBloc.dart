import 'package:dhap_flutter_project/data/db/sessiondb_helper.dart';
import 'package:dhap_flutter_project/data/repository/task_repository.dart';
import 'package:dhap_flutter_project/data/repository/user_repository.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonEvent.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/request_repository.dart';
import '../../../data/repository/resource_repository.dart';
import '../../../data/repository/response_repository.dart';

final UserRepository _userRepository = UserRepository();
final TaskRepository _taskRepository = TaskRepository();
final ResourceRepository _resourceRepository = ResourceRepository();
final RequestRepository _requestRepository = RequestRepository();
final ResponseRepository _responseRepository = ResponseRepository();


class commonBloc extends Bloc<commonEvent, commonState> {
  commonBloc() : super(commonInitial()) {
    on<FetchUserData>((event, emit) async {
      emit(commonLoading());
      try {
        //final users = _userRepository.getAllUsers();
        final users = await _userRepository.getAllUsers();
        emit(commonSuccess(message: "Users fetched successfully", user: users));
      }
      catch (e) {
        emit(commonFailure(error: e.toString()));
      }

    });

    on<LogoutSubmitted>((event, emit) async {
      emit(commonLoading());
      await Future.delayed(const Duration(seconds: 1));
      final sessionHelper = Sessiondb_helper();
      await sessionHelper.clearSession();
      emit(LogoutSuccess(message: "Logout successful"));
    });

    on<SwitchRoleSubmitted>((event, emit) async {
      emit(commonLoading());
      await Future.delayed(const Duration(seconds: 1));
      await _userRepository.updateUserRole(event.email, event.newRole);
      emit(SwitchRoleSuccess(message: "Switch role successful", newRole: event.newRole));
    });

    on<FetchDataEvent>((event, emit) async {
      emit(commonLoading());
      try {
        final users = await _userRepository.getAllUsers();
        final tasks = await _taskRepository.getAllTasks();
        final resources = await _resourceRepository.getAllResources();
        final requests = await _requestRepository.getAllRequests();
        final responses = await _responseRepository.getAllResponses();
        emit(FetchDataSuccess(
          message: "Data fetched successfully",
          users: users,
          tasks: tasks,
          resources: resources,
          requests: requests,
          responses: responses,
        ));
      } catch (e) {
        emit(commonFailure(error: e.toString()));
      }
    });


  }

}