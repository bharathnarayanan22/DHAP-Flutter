import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:dhap_flutter_project/data/repository/request_repository.dart';
import 'package:dhap_flutter_project/data/repository/resource_repository.dart';
import 'package:dhap_flutter_project/data/repository/response_repository.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_event.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final ResourceRepository _resourceRepository = ResourceRepository();
final RequestRepository _requestRepository = RequestRepository();
final ResponseRepository _responseRepository = ResponseRepository();

class DonorBloc extends Bloc<DonorEvent, DonorState> {
  DonorBloc() : super(DonorInitial()) {
    on<AddResourceEvent>((event, emit) async {
      emit(DonorLoading());
      try {
        final resource = ResourceModel(
          resource: event.resource,
          quantity: event.quantity,
          address: event.address,
          DonorName: event.DonorName,
          location: event.location,
        );
        if (resource.resource.isEmpty ||
            resource.quantity == 0 ||
            resource.address.isEmpty ||
            resource.location == null) {
          emit(DonorFailure(error: 'All fields are required'));
          return;
        } else {
          _resourceRepository.addResource(resource);
          print('Request created successfully');
          emit(DonorSuccess(message: 'Request created successfully'));
        }
      } catch (e) {
        emit(DonorFailure(error: e.toString()));
      }
    });

    on<FetchRequestsEvent>((event, emit) async {
      emit(DonorLoading());
      try {
        final allRequests = await _requestRepository.getAllRequests();

        final pendingRequests = allRequests
            .where((req) => req.status == "Pending")
            .toList();

        if (pendingRequests.isEmpty) {
          emit(const FetchRequestFailure(error: "No pending requests found"));
        } else {
          emit(
            FetchRequestSuccess(
              msg: "Fetched pending requests successfully",
              requests: pendingRequests,
            ),
          );
        }
      } catch (e) {
        emit(FetchRequestFailure(error: e.toString()));
      }
    });

    on<RespondEvent>((event, emit) async {
      emit(DonorLoading());
      try {
        final response = ResponseModel(
          requestId: event.requestId,
          responderName: event.user,
          message: event.message,
          quantityProvided: event.quantityProvided,
          address: event.address,
          location: event.location,
        );
        if (response.requestId == 0 ||
            response.responderName.isEmpty ||
            response.message.isEmpty ||
            response.quantityProvided == 0 ||
            response.location == null) {
          emit(DonorFailure(error: 'All fields are required'));
          return;
        } else {
          _responseRepository.addResponse(response);
          print('Response created successfully');
          final allRequests = await _requestRepository.getAllRequests();

          final pendingRequests = allRequests
              .where((req) => req.status == "Pending")
              .toList();

          if (pendingRequests.isEmpty) {
            emit(const FetchRequestFailure(error: "No pending requests found"));
          } else {
            emit(
              FetchRequestSuccess(
                msg: "Response Submitted successfully",
                requests: pendingRequests,
              ),
            );
          }
        }
      } catch (e) {
        emit(DonorFailure(error: e.toString()));
      }
    });
  }
}
