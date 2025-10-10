import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:dhap_flutter_project/data/repository/response_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/task_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/repository/resource_repository.dart';
import '../../../data/repository/request_repository.dart';
import '../../../data/model/task_model.dart';
import '../../../data/model/user_model.dart';

import '../../../data/model/resource_model.dart';
import 'coordinator_event.dart';
import 'coordinator_state.dart';

final TaskRepository _taskRepository = TaskRepository();
final UserRepository _userRepository = UserRepository();
final RequestRepository _requestRepository = RequestRepository();
final ResourceRepository _resourceRepository = ResourceRepository();
final ResponseRepository _responseRepository = ResponseRepository();


class CoordinatorBloc extends Bloc<CoordinatorEvent, CoordinatorState> {
  CoordinatorBloc() : super(CoordinatorInitial()) {
    on<CreateTaskEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        final task = Task(
          title: event.title,
          description: event.description,
          volunteer: event.volunteer,
          StartAddress: event.StartAddress,
          EndAddress: event.EndAddress,
          StartLocation: event.StartLocation,
          EndLocation: event.EndLocation,
        );

        debugPrint('${task.title}, ${task.description}, ${task.volunteer}, ${task.StartAddress}, ${task.EndAddress}, ${task.StartLocation}, ${task.EndLocation}');

        if (task.title.isEmpty ||
            task.description.isEmpty ||
            task.volunteer == 0 ||
            task.StartAddress.isEmpty ||
            task.EndAddress.isEmpty ||
            task.StartLocation == null ||
            task.EndLocation == null) {
          emit(CoordinatorFailure(error: 'All fields are required'));
          print('All fields are required');
          return;
        } else {
          await _taskRepository.addTask(task);
          print('Task created successfully');
          emit(
            CoordinatorSuccess(
              message: 'Task created successfully',
              tasks: await _taskRepository.getAllTasks(),
            ),
          );
        }
      } catch (e) {
        emit(CoordinatorFailure(error: e.toString()));
      }
    });

    on<FetchTasksEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        final tasks = await _taskRepository.getAllTasks();
        print("Fetched tasks: $tasks");
        emit(
          CoordinatorSuccess(
            message: 'Tasks fetched successfully',
            tasks: tasks,
          ),
        );
      } catch (e) {
        emit(CoordinatorFailure(error: e.toString()));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        await _taskRepository.deleteTask(event.taskId);
        emit(
          CoordinatorSuccess(
            message: 'Task deleted successfully',
            tasks: await _taskRepository.getAllTasks(),
          ),
        );
      } catch (e) {
        emit(CoordinatorFailure(error: e.toString()));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        await _taskRepository.updateTask(event.updatedTask);
        final tasks = await _taskRepository.getAllTasks();
        emit(CoordinatorSuccess(message: 'Task updated Successfully',tasks: tasks));
      } catch (e) {
        emit(CoordinatorFailure(error: e.toString()));
      }
    });

    on<FetchUsersEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        final users = await _userRepository.getAllUsers();
        emit(
          UserSuccess(
            message: 'Users fetched successfully',
            users: users,
          ),
        );
      } catch (e) {
        emit(UserFailure(error: e.toString()));
      }
    });

    on<CreateResourceRequestEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        final request = Request(
          resource: event.resource,
          quantity: event.quantity,
          description: event.description,
          address: event.address,
          location: event.location,
        );
        if (request.resource.isEmpty ||
            request.quantity == 0 ||
            request.description.isEmpty ||
            request.address.isEmpty ||
            request.location == null) {
          emit(CoordinatorFailure(error: 'All fields are required'));
          return;
        } else {
          _requestRepository.addRequest(request);
          print('Request created successfully');
          emit(
            RequestSuccess(
              message: 'Request created successfully',
            ),
          );
        }
      } catch (e) {
        emit(CoordinatorFailure(error: e.toString()));
      }
    });

    on<FetchResourcesEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        emit(
          ResourceSuccess(
            message: 'Resources fetched successfully',
            resources: await _resourceRepository.getAllResources(),
          ),
        );
      } catch (e) {
        emit(ResourceFailure(error: e.toString()));
      }
    });

    on<AddResourceEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        final resource = ResourceModel(
          resource: event.resource,
          quantity: event.quantity,
          address: event.address,
          location: event.location,
          DonorName: 'Tester',
        );
        if (resource.resource.isEmpty ||
            resource.quantity == 0 ||
            resource.address.isEmpty ||
            resource.location == null) {
          emit(CoordinatorFailure(error: 'All fields are required'));
          return;
        } else {
          await _resourceRepository.addResource(resource);
          emit(
            ResourceSuccess(
              message: 'Resource created successfully',
              resources: await _resourceRepository.getAllResources(),
            ),
          );
        }
      } catch (e) {
        emit(CoordinatorFailure(error: e.toString()));
      }
    });

    // on<FetchRequestsEvent>((event, emit) async {
    //   emit(CoordinatorLoading());
    //   try {
    //     final allRequests = _requestRepository.getAllRequests();
    //
    //     if (allRequests.isEmpty) {
    //       emit(const FetchRequestFailure(error: "No Requests found"));
    //     } else {
    //       emit(
    //         FetchRequestSuccess(
    //           msg: "Fetched requests successfully",
    //           requests: allRequests,
    //         ),
    //       );
    //     }
    //   } catch (e) {
    //     emit(FetchRequestFailure(error: e.toString()));
    //   }
    // });
    //
    // on<FetchResponsesEvent>((event, emit) async {
    //   emit(CoordinatorLoading());
    //   try {
    //     final allResponses = _responseRepository.getAllResponses();
    //
    //     if (allResponses.isEmpty) {
    //       emit(const FetchRequestFailure(error: "No Responses found"));
    //     } else {
    //       emit(
    //         FetchResponseSuccess(
    //           msg: "Fetched responses successfully",
    //           responses: allResponses,
    //         ),
    //       );
    //     }
    //   } catch (e) {
    //     emit(FetchRequestFailure(error: e.toString()));
    //   }
    // });

    on<FetchRequestsAndResponsesEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        final allRequests = await _requestRepository.getAllRequests();
        final allResponses = await _responseRepository.getAllResponses();
        print('Responses: ${allResponses}');


        if (allRequests.isEmpty) {
          emit(const FetchRequestFailure(error: "No Requests found"));
        } else {
          emit(
            FetchRequestResponseSuccess(
              message: "Fetched requests and responses successfully",
              requests: allRequests,
              responses: allResponses
            ),
          );
        }
      } catch (e) {
        emit(FetchRequestFailure(error: e.toString()));
      }
    });

    on<MarkResponseTaskAssignedEvent>((event, emit) async {
      emit(CoordinatorLoading());
      try {
        await _responseRepository.assignTaskFromResponse(event.responseId);
        final allRequests = await _requestRepository.getAllRequests();
        final allResponses = await _responseRepository.getAllResponses();
        emit(
          FetchRequestResponseSuccess(
              message: "Fetched requests and responses successfully",
              requests: allRequests,
              responses: allResponses
          ),
        );
      } catch (e) {
        emit(CoordinatorFailure(error: e.toString()));
      }
    });

  }
}
