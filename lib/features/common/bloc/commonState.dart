import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class commonState extends Equatable {
  const commonState();

  @override
  List<Object> get props => [];
}

class commonInitial extends commonState {}

class commonLoading extends commonState {}

class commonSuccess extends commonState {
  final String message;
  final List<User> user;
  commonSuccess({required this.message, required this.user});
}

class commonFailure extends commonState {
  final String error;
  commonFailure({required this.error});
}

class LogoutSuccess extends commonState {
  final String message;
  LogoutSuccess({required this.message});
}

class SwitchRoleSuccess extends commonState {
  final String message;
  SwitchRoleSuccess({required this.message});
}

class FetchDataSuccess extends commonState {
  final String message;
  final List<User> users;
  final List<Task> tasks;
  final List<ResourceModel> resources;
  final List<Request> requests;
  final List<ResponseModel> responses;
  FetchDataSuccess({
    required this.message,
    required this.users,
    required this.tasks,
    required this.resources,
    required this.requests,
    required this.responses,
  });
}
