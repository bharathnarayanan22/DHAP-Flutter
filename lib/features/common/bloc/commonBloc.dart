import 'dart:async';
import 'dart:convert';

import 'package:dhap_flutter_project/data/db/sessiondb_helper.dart';
import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/data/repository/application_repository.dart';
import 'package:dhap_flutter_project/data/repository/task_repository.dart';
import 'package:dhap_flutter_project/data/repository/user_repository.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonEvent.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/request_repository.dart';
import '../../../data/repository/resource_repository.dart';
import '../../../data/repository/response_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

final UserRepository _userRepository = UserRepository();
final TaskRepository _taskRepository = TaskRepository();
final ResourceRepository _resourceRepository = ResourceRepository();
final RequestRepository _requestRepository = RequestRepository();
final ResponseRepository _responseRepository = ResponseRepository();
final ApplicationRepository _applicationRepository = ApplicationRepository();
StreamSubscription<List<User>>? _userSub;
StreamSubscription<List<Task>>? _taskSub;
StreamSubscription<List<ResourceModel>>? _resourceSub;
StreamSubscription<List<Request>>? _requestSub;
StreamSubscription<List<ResponseModel>>? _responseSub;

class commonBloc extends Bloc<commonEvent, commonState> {
  commonBloc() : super(commonInitial()) {
    on<FetchUserData>((event, emit) async {
      emit(commonLoading());
      try {
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

    // on<FetchDataEvent>((event, emit) async {
    //   emit(commonLoading());
    //   try {
    //     final users = await _userRepository.getAllUsers();
    //     final tasks = await _taskRepository.getAllTasks();
    //     final resources = await _resourceRepository.getAllResources();
    //     final requests = await _requestRepository.getAllRequests();
    //     final responses = await _responseRepository.getAllResponses();
    //     print('Fetching');
    //     print('task: ${tasks.length}');
    //     emit(FetchDataSuccess(
    //       message: "Data fetched successfully",
    //       users: users,
    //       tasks: tasks,
    //       resources: resources,
    //       requests: requests,
    //       responses: responses,
    //     ));
    //   } catch (e) {
    //     emit(commonFailure(error: e.toString()));
    //   }
    // });

    on<FetchDataEvent>((event, emit) async {
      emit(commonLoading());

      try {
        final users = await _userRepository.getAllUsers();
        final tasks = await _taskRepository.getAllTasks();
        final resources = await _resourceRepository.getAllResources();
        final requests = await _requestRepository.getAllRequests();
        final responses = await _responseRepository.getAllResponses();

        emit(FetchDataSuccess(
          message: "Initial load",
          users: users,
          tasks: tasks,
          resources: resources,
          requests: requests,
          responses: responses,
        ));

        final combinedStream = Rx.combineLatest5<
            List<User>,
            List<Task>,
            List<ResourceModel>,
            List<Request>,
            List<ResponseModel>,
            FetchDataSuccess>(
          _userRepository.watchAllUsers(),
          _taskRepository.watchAllTasks(),
          _resourceRepository.watchAllResources(),
          _requestRepository.watchAllRequests(),
          _responseRepository.watchAllResponses(),
              (users, tasks, resources, requests, responses) {
            return FetchDataSuccess(
              message: "Live update",
              users: users,
              tasks: tasks,
              resources: resources,
              requests: requests,
              responses: responses,
            );
          },
        );
        await emit.forEach<FetchDataSuccess>(
          combinedStream,
          onData: (data) => data,
        );
      } catch (e) {
        emit(commonFailure(error: e.toString()));
      }
    });



    on<BecomeCoSubmitted>((event, emit) async {
      emit(commonLoading());
      await Future.delayed(const Duration(seconds: 1));

      try {
        debugPrint('=> Bloc: email: ${event.email}, message: ${event.message}');
        await _applicationRepository.addApplication(event.email, event.message);
        await _userRepository.updateUserSubmissionStatus(event.email, true);

        emit(BecomeCoSuccess(message: "Application submitted successfully"));
      } catch (e, st) {
        debugPrint('Error submitting coordinator application: $e');
        debugPrintStack(stackTrace: st);
        emit(commonFailure(error: "Failed to submit application. Please try again."));
      }
    });

    on<CreateTaskEvent>((event, emit) async {
      emit(commonLoading());
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
            task.EndAddress.isEmpty) {
          emit(commonFailure(error: 'All fields are required'));
          print('All fields are required');
          return;
        } else {
          await _taskRepository.addTask(task);
          print('Task created successfully');
          emit(
            TaskCreationSuccess(
              message: 'Task created successfully',
            ),
          );
        }
      } catch (e) {
        emit(commonFailure(error: e.toString()));
      }
    });

    on<CreateResourceRequestEvent>((event, emit) async {
      emit(commonLoading());
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
            request.address.isEmpty ) {
          emit(commonFailure(error: 'All fields are required'));
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
        emit(commonFailure(error: e.toString()));
      }
    });

    // on<FetchNewsEvent>((event, emit) async {
    //   emit(FetchNewsLoading());
    //   try {
    //     final response = await http.get(Uri.parse(
    //         'https://gnews.io/api/v4/top-headlines?lang=en&max=20&apikey=a5c8343f0f1c07f31288edaef39ac5e9'));
    //     if (response.statusCode == 200) {
    //       final data = jsonDecode(response.body);
    //       emit(FetchNewsSuccess(data['articles']));
    //     } else {
    //       emit(commonFailure(error: 'Failed to fetch news: ${response.statusCode}'));
    //     }
    //   } catch (e) {
    //     emit(commonFailure(error: 'Error fetching news: $e'));
    //   }
    // });
    //
    Future<List<dynamic>> _fetchNewsStream() async {
      final response = await http.get(Uri.parse(
        'https://gnews.io/api/v4/top-headlines?apikey=a5c8343f0f1c07f31288edaef39ac5e9',
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List;

        final List<dynamic> partial = [];
        for (var article in articles) {
          partial.add(article);
          await Future.delayed(const Duration(milliseconds: 200));
        }
        return partial;
      } else {
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    }

    on<FetchNewsEvent>((event, emit) async {
      emit(FetchNewsLoading());

      try {
        final stream = Stream<List<dynamic>>.fromFuture(_fetchNewsStream());

        await emit.forEach<List<dynamic>>(
          stream,
          onData: (articles) => FetchNewsSuccess(articles),
          onError: (e, _) => commonFailure(error: e.toString()),
        );
      } catch (e) {
        emit(commonFailure(error: 'Error fetching news: $e'));
      }
    });

    // Stream<List<dynamic>> _fetchNewsStream() async* {
    //   final response = await http.get(Uri.parse(
    //     'https://gnews.io/api/v4/top-headlines?lang=en&max=20&apikey=a5c8343f0f1c07f31288edaef39ac5e9',
    //   ));
    //
    //   if (response.statusCode == 200) {
    //     final data = jsonDecode(response.body);
    //     final articles = data['articles'] as List;
    //
    //     final List<dynamic> partial = [];
    //     for (var article in articles) {
    //       partial.add(article);
    //       await Future.delayed(const Duration(milliseconds: 200));
    //       yield List<dynamic>.from(partial);
    //     }
    //   } else {
    //     throw Exception('Failed to fetch news: ${response.statusCode}');
    //   }
    // }
    //
    // on<FetchNewsEvent>((event, emit) async {
    //   emit(FetchNewsLoading());
    //   try {
    //     await for (final articles in _fetchNewsStream()) {
    //       emit(FetchNewsSuccess(articles));
    //     }
    //   } catch (e) {
    //     emit(commonFailure(error: 'Error fetching news: $e'));
    //   }
    // });




  }


}