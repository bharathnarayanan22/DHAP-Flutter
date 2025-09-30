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
