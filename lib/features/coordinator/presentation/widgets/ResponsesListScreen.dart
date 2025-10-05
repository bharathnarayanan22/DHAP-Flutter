import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF0072CD);

class ResponsesListScreen extends StatelessWidget {
  final Request request;
  final List<ResponseModel> responses;

  const ResponsesListScreen({ super.key,
    required this.request,
    required this.responses,
  });

  String _calculateDistance(LatLng loc1, LatLng loc2) {
    const Distance distance = Distance();
    final double km = distance(loc1, loc2) / 1000;
    return '${km.toStringAsFixed(1)} km away';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Responses for - ${request.resource}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: responses.isEmpty
          ? const Center(
        child: Text(
          'No responses recorded for this request.',
          style: TextStyle(fontSize: 16, color: primaryColor),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: responses.length,
        itemBuilder: (context, index) {
          final response = responses[index];

          final String distanceString = _calculateDistance(
            request.location,
            response.location,
          );

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                            fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white),
                      ),
                      Chip(
                        label: Text(
                          'Quantity: ${response.quantityProvided}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: accentColor,
                            width: 0.5,
                          )
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
                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: primaryColor),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      const Divider(),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(child: Row(
                            children: [
                              Icon(Icons.pin_drop, size: 16, color: accentColor),
                              const SizedBox(width: 6),
                              Text(
                                distanceString,
                                style: const TextStyle(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),

                          const SizedBox(width: 12),ElevatedButton.icon(
                            onPressed: () {
                              print("Task Assigned");
                            },
                            icon: const Icon(Icons.assignment_turned_in, color: Colors.white),
                            label: const Text('Assign Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              elevation: 8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Center(
                      //   child: ElevatedButton.icon(
                      //     onPressed: () {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         SnackBar(content: Text('Task assigned to ${response.responderName}')),
                      //       );
                      //     },
                      //     icon: const Icon(Icons.assignment_turned_in, color: Colors.white),
                      //     label: const Text('Assign Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: primaryColor,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      //       elevation: 8,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}