import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final Map<String, dynamic> user;
  AuthSuccess({required this.message, required this.user});

  @override
  List<Object> get props => [message, user];
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

class AuthModeState extends AuthState {
  final bool isLogin;
  AuthModeState({required this.isLogin});
}
