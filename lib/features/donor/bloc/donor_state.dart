import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:equatable/equatable.dart';

abstract class DonorState extends Equatable {
  const DonorState();

  @override
  List<Object?> get props => [];
}

class DonorInitial extends DonorState {}

class DonorLoading extends DonorState {}

class DonorSuccess extends DonorState {
  final String message;
  const DonorSuccess({required this.message});
}

class DonorFailure extends DonorState {
  final String error;
  const DonorFailure({required this.error});
}

class FetchRequestSuccess extends DonorState {
  final String msg;
  final List<Request> requests;
  const FetchRequestSuccess({required this.msg, required this.requests});
}

class FetchRequestFailure extends DonorState {
  final String error;
  const FetchRequestFailure({required this.error});
}

