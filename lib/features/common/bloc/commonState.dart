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
  final List<User> user ;
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