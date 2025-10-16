import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class volunteerState extends Equatable {
  const volunteerState();
  @override
  List<Object?> get props => [];
}

class volunteerInitial extends volunteerState {}

class volunteerLoading extends volunteerState {}

class volunteerSuccess extends volunteerState {
  final String message;
  final List<Task> tasks;
  //final User user;
  const volunteerSuccess({required this.message, required this.tasks});
}

class volunteerFailure extends volunteerState {
  final String error;
  const volunteerFailure({required this.error});
}

class AcceptSuccess extends volunteerState {
  final String message;
  const AcceptSuccess({required this.message});
}