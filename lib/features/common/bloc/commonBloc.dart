import 'package:dhap_flutter_project/data/db/sessiondb_helper.dart';
import 'package:dhap_flutter_project/data/repository/user_repository.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonEvent.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final UserRepository _userRepository = UserRepository();

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
      emit(SwitchRoleSuccess(message: "Switch role successful"));
    });
  }

}