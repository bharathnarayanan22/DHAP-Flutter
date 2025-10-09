import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_bloc.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_event.dart';
import 'package:dhap_flutter_project/data/model/task_model.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF4CAF50);

class AvailTaskCard extends StatelessWidget {
  final Task task;
  final User user;

  const AvailTaskCard({super.key, required this.task, required this.user});

  Future<void> _openMap(BuildContext context, LatLng start, LatLng end) async {
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&origin=${start.latitude},${start.longitude}"
      "&destination=${end.latitude},${end.longitude}"
      "&travelmode=driving",
    );

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, size: 16, color: primaryColor),
          if (icon != null) const SizedBox(width: 8),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stillNeeded = task.volunteer - task.volunteersAccepted;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      debugPrint(user.inTask.toString());
                      user.inTask
                          ? null
                          : (context.read<volunteerBloc>().add(
                              AcceptTaskEvent(
                                taskId: task.id,
                                userEmail: user.email,
                              ),
                            ));
                    },
                    icon: const Icon(Icons.check_circle_outline, size: 20),
                    label: const Text(
                      "Accept",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      task.description,
                      style: const TextStyle(color: primaryColor),
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 10, thickness: 1),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                    label: "Volunteers Needed",
                    value: task.volunteer.toString(),
                    icon: Icons.group,
                  ),
                  _buildDetailRow(
                    label: "Accepted",
                    value: task.volunteersAccepted.toString(),
                    icon: Icons.done_all,
                  ),
                  _buildDetailRow(
                    label: "Still Needed",
                    value: stillNeeded.toString(),
                    icon: Icons.waving_hand,
                  ),
                  const Divider(color: Colors.grey, height: 10, thickness: 1),

                  const SizedBox(height: 12),

                  _buildDetailRow(
                    label: "From",
                    value: task.StartAddress,
                    icon: Icons.arrow_upward,
                  ),
                  _buildDetailRow(
                    label: "To",
                    value: task.EndAddress,
                    icon: Icons.arrow_downward,
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.white38),
                        ),
                      ),
                      onPressed: () => _openMap(
                        context,
                        task.StartLocation,
                        task.EndLocation,
                      ),
                      icon: const Icon(
                        Icons.map,
                        size: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "View Route",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
