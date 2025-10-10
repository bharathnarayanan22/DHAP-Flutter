import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_event.dart';


const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF0072CD);

class ResponsesListScreen extends StatelessWidget {
  final Request request;
  final List<ResponseModel> responses;
  final CoordinatorBloc bloc;

  const ResponsesListScreen({
    super.key,
    required this.request,
    required this.responses,
    required this.bloc,
  });

  String _calculateDistance(LatLng loc1, LatLng loc2) {
    const Distance distance = Distance();
    final double km = distance(loc1, loc2) / 1000;
    return '${km.toStringAsFixed(1)} km away';
  }

  void _showAssignTaskDialog(
      BuildContext context, ResponseModel response, Request request) {
    final titleController = TextEditingController(
        text: 'Task for: ${request.resource} (${response.responderName})');
    final descController = TextEditingController(
        text:
        'Deliver ${response.quantityProvided} units of ${request.resource} from ${response.responderName} to ${request.address}.');
    final volunteerController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Assign Delivery Task'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) => v!.isEmpty ? 'Title is required' : null,
                  ),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  TextFormField(
                    controller: volunteerController,
                    decoration: const InputDecoration(
                        labelText: 'Volunteers Needed'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v!.isEmpty) return 'Required';
                      if (int.tryParse(v) == null) return 'Must be a number';
                      if (int.parse(v) <= 0) return 'Must be positive';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: primaryColor)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
              ),
              child: const Text('Assign Task',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  //final bloc = dialogContext.read<CoordinatorBloc>();
                  final volunteers = int.parse(volunteerController.text);

                  bloc.add(
                    CreateTaskEvent(
                      title: titleController.text,
                      description: descController.text,
                      volunteer: volunteers,
                      StartAddress: 'address',
                      EndAddress: request.address,
                      StartLocation: response.location,
                      EndLocation: request.location,
                    ),
                  );

                  bloc.add(
                    MarkResponseTaskAssignedEvent(response.id),
                  );

                  response.taskAssigned = true;

                  Navigator.pop(dialogContext, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Task assigned and database updated for ${response.responderName}')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Responses for - ${request.resource}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CoordinatorBloc, CoordinatorState>(
        bloc: bloc, // important
        builder: (context, state) {
          if (state is CoordinatorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchRequestResponseSuccess) {
            // Re-fetch updated response list for this request
            final updatedResponses = state.responses
                .where((r) => r.requestId == request.id)
                .toList();

            if (updatedResponses.isEmpty) {
              return const Center(
                child: Text(
                  'No responses recorded for this request.',
                  style: TextStyle(fontSize: 16, color: primaryColor),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: updatedResponses.length,
              itemBuilder: (context, index) {
                final response = updatedResponses[index];
                final String distanceString = _calculateDistance(
                  request.location,
                  response.location,
                );

                return Card(
                  elevation: 4,
                  margin:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              response.responderName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            Chip(
                              label: Text(
                                'Quantity: ${response.quantityProvided}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                              backgroundColor: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: accentColor,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              response.message,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: primaryColor),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.pin_drop,
                                        size: 16, color: accentColor),
                                    const SizedBox(width: 6),
                                    Text(
                                      distanceString,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: response.taskAssigned
                                      ? null
                                      : () {
                                    _showAssignTaskDialog(
                                        context, response, request);
                                  },
                                  icon: Icon(
                                      response.taskAssigned
                                          ? Icons.check_circle
                                          : Icons.assignment_turned_in,
                                      color: Colors.white),
                                  label: Text(
                                      response.taskAssigned
                                          ? 'Task Assigned'
                                          : 'Assign Task',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: response.taskAssigned
                                        ? Colors.grey
                                        : primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    elevation: 8,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is CoordinatorFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }



  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey[200],
  //     appBar: AppBar(
  //       title: Text(
  //         'Responses for - ${request.resource}',
  //         style: const TextStyle(
  //             fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
  //       ),
  //       backgroundColor: primaryColor,
  //       foregroundColor: Colors.white,
  //     ),
  //     body: responses.isEmpty
  //         ? const Center(
  //       child: Text(
  //         'No responses recorded for this request.',
  //         style: TextStyle(fontSize: 16, color: primaryColor),
  //       ),
  //     )
  //         : ListView.builder(
  //       padding: const EdgeInsets.all(12.0),
  //       itemCount: responses.length,
  //       itemBuilder: (context, index) {
  //         final response = responses[index];
  //
  //         final String distanceString = _calculateDistance(
  //           request.location,
  //           response.location,
  //         );
  //
  //         return Card(
  //           elevation: 4,
  //           margin:
  //           const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10)),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(16.0),
  //                 decoration: const BoxDecoration(
  //                   color: primaryColor,
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(10),
  //                     topRight: Radius.circular(10),
  //                   ),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       response.responderName,
  //                       style: const TextStyle(
  //                           fontWeight: FontWeight.w800,
  //                           fontSize: 18,
  //                           color: Colors.white),
  //                     ),
  //                     Chip(
  //                       label: Text(
  //                         'Quantity: ${response.quantityProvided}',
  //                         style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 14,
  //                             color: Colors.white),
  //                       ),
  //                       backgroundColor: accentColor,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                         side: const BorderSide(
  //                           color: accentColor,
  //                           width: 0.5,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       response.message,
  //                       style: TextStyle(
  //                           fontSize: 14,
  //                           fontStyle: FontStyle.italic,
  //                           color: primaryColor),
  //                       maxLines: 3,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                     const SizedBox(height: 12),
  //                     const Divider(),
  //                     const SizedBox(height: 12),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             const Icon(Icons.pin_drop,
  //                                 size: 16, color: accentColor),
  //                             const SizedBox(width: 6),
  //                             Text(
  //                               distanceString,
  //                               style: const TextStyle(
  //                                   fontSize: 14,
  //                                   color: Colors.blueGrey,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(width: 12),
  //                         ElevatedButton.icon(
  //                           onPressed: response.taskAssigned
  //                               ? null
  //                               : () {
  //                             _showAssignTaskDialog(
  //                                 context, response, request);
  //                           },
  //                           icon: Icon(
  //                               response.taskAssigned
  //                                   ? Icons.check_circle
  //                                   : Icons.assignment_turned_in,
  //                               color: Colors.white),
  //                           label: Text(
  //                               response.taskAssigned
  //                                   ? 'Task Assigned'
  //                                   : 'Assign Task',
  //                               style: const TextStyle(
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold)),
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: response.taskAssigned
  //                                 ? Colors.grey
  //                                 : primaryColor,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 24, vertical: 12),
  //                             elevation: 8,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 16),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}

