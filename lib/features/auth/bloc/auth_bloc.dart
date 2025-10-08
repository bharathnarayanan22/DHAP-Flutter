import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/data/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

final UserRepository _userRepository = UserRepository();


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isLoginMode = true;

  //static final List<Map<String, dynamic>> _users = [];

  AuthBloc() : super(AuthModeState(isLogin: true)) {

    on<ToggleAuthMode>((event, emit) {
      if (state is AuthModeState) {
        final currentState = state as AuthModeState;
        emit(AuthModeState(isLogin: !currentState.isLogin));
      } else {
        emit(AuthModeState(isLogin: false));
      }
    });

    on<LoginSubmitted>((event, emit) async {
      // emit(AuthLoading());
      // await Future.delayed(Duration(seconds: 1));
      // final user = _users.firstWhere((u) => u['email'] == event.email && u['password'] == event.password, orElse: () => {});
      // if (user.isNotEmpty) {
      //   debugPrint("Login Successful for ${user['email']}");
      //   emit(AuthSuccess(message: "Login Successful", user: user));
      // } else {
      //   debugPrint("Login failed");
      //   emit(AuthFailure(error: "Invalid Email or Password"));
      // }
      emit(AuthLoading());
      await Future.delayed(Duration(seconds: 1));
      final User user = _userRepository.getAllUsers().firstWhere((u) => u.email == event.email && u.password == event.password, orElse: () => User(name: '', email: '', password: '', mobile: '', addressLine: '', city: '', country: '', pincode: '', role: ''));
      if (user.name.isNotEmpty) {
        debugPrint("Login Successful for ${user.email}");
        emit(AuthSuccess(message: "Login Successful", user: user));
      } else {
        debugPrint("Login failed");
        emit(AuthFailure(error: "Invalid Email or Password"));
      }
    });

    // on<SignupSubmitted>((event, emit) async {
    //   emit(AuthLoading());
    //   await Future.delayed(Duration(seconds: 1));
    //
    //
    //   // final user = _users.any((u) => u['email'] == event.email);
    //   // if(user) {
    //   //   emit(AuthFailure(error: "Email already registered"));
    //   //   return;
    //   // }
    //   //
    //   final newUserDetails = {
    //     'name': event.name,
    //     'email': event.email,
    //     'password': event.password,
    //     'mobile': event.mobile,
    //     'addressLine': event.addressLine,
    //     'city': event.city,
    //     'country': event.country,
    //     'pincode': event.pincode,
    //     'role': event.role,
    //   };
    //
    //   //
    //   // _users.add(newUserDetails);
    //   //
    //   // debugPrint("Signup Successful: ${event.name}");
    //   // emit(AuthSuccess(message: "Signup successful", user: newUserDetails));
    //
    //
    //
    // });

    on<SignupSubmitted>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));

      final existingUser = _userRepository.getAllUsers().any((u) => u.email == event.email);
      if (existingUser) {
        emit(AuthFailure(error: "Email already registered"));
        return;
      }

      final newUser = User(
        name: event.name,
        email: event.email,
        password: event.password,
        mobile: event.mobile,
        addressLine: event.addressLine,
        city: event.city,
        country: event.country,
        pincode: event.pincode,
        role: event.role,
      );

      _userRepository.addUser(newUser);

      debugPrint("Signup Successful for ${newUser.name}");
      emit(AuthSuccess(message: "Signup successful", user: newUser));
    });

  }
}
