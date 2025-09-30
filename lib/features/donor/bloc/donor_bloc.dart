import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:dhap_flutter_project/data/repository/resource_repository.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_event.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final ResourceRepository _resourceRepository = ResourceRepository();


class DonorBloc extends Bloc<DonorEvent, DonorState> {
  DonorBloc() : super(DonorInitial()) {
    on<AddResourceEvent>((event, emit) async {
      emit(DonorLoading());
      try {
        final resource = Resource(
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
          emit(
            DonorSuccess(
              message: 'Request created successfully',
            ),
          );
        }
      } catch (e) {
        emit(DonorFailure(error: e.toString()));
      }
    });
  }
}