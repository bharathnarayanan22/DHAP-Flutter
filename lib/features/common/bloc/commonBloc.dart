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
        emit(commonSuccess(message: "Users fetched successfully", user: _userRepository.getAllUsers()));
      }
      catch (e) {
        emit(commonFailure(error: e.toString()));
      }

    });

  }
}