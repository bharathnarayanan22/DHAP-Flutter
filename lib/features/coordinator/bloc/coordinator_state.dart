import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class CoordinatorState extends Equatable {
  const CoordinatorState();

  @override
  List<Object?> get props => [];
}

class CoordinatorInitial extends CoordinatorState {}

class CoordinatorLoading extends CoordinatorState {}

class CoordinatorSuccess extends CoordinatorState {
  final String message;
  final List<Task> tasks;
  const CoordinatorSuccess({required this.message, required this.tasks});

  @override
  List<Object?> get props => [message, tasks];
}

class CoordinatorFailure extends CoordinatorState {
  final String error;

  const CoordinatorFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserSuccess extends CoordinatorState {
  final String message;
  final List<User> users;
  const UserSuccess({required this.message, required this.users});

  @override
  List<Object?> get props => [message, users];
}

class UserFailure extends CoordinatorState {
  final String error;
  const UserFailure({required this.error});
}

class RequestSuccess extends CoordinatorState {
  final String message;
  const RequestSuccess({required this.message});
}

class RequestFailure extends CoordinatorState {
  final String error;
  const RequestFailure({required this.error});
}

class ResourceSuccess extends CoordinatorState {
  final String message;
  final List<Resource> resources;
  const ResourceSuccess({required this.message, required this.resources});
}

class ResourceFailure extends CoordinatorState {
  final String error;
  const ResourceFailure({required this.error});
}

class FetchRequestSuccess extends CoordinatorState {
  final String msg;
  final List<Request> requests;
  const FetchRequestSuccess({required this.msg, required this.requests});
}

class FetchRequestFailure extends CoordinatorState {
  final String error;
  const FetchRequestFailure({required this.error});
}

class FetchResponseSuccess extends CoordinatorState {
  final String msg;
  final List<ResponseModel> responses;
  const FetchResponseSuccess({required this.msg, required this.responses});
}

class FetchRequestResponseSuccess extends CoordinatorState {
  final String message;
  final List<Request> requests;
  final List<ResponseModel> responses;
  const FetchRequestResponseSuccess({required this.message, required this.requests, required this.responses});
}