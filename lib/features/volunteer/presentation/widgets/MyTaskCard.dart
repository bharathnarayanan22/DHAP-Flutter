import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'dart:io';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);

class MyTaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback? onSubmitProof;
  final VoidCallback? onViewSubmission;
  final VoidCallback? onUpdateProof;

  const MyTaskCard({
    super.key,
    required this.task,
    this.onSubmitProof,
    this.onViewSubmission,
    this.onUpdateProof,
  });

  @override
  State<MyTaskCard> createState() => _MyTaskCardState();
}


class _MyTaskCardState extends State<MyTaskCard> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.task.Status;
  }

  void updateStatus(String newStatus) {
    setState(() {
      status = newStatus;
    });
  }

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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, size: 16, color: primaryColor),
          if (icon != null) const SizedBox(width: 8),
          Expanded(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget statusWithIcon(String currentStatus) {
    IconData icon;
    Color color;

    switch (currentStatus) {
      case "Completed":
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case "In Progress":
        icon = Icons.autorenew;
        color = Colors.orange;
        break;
      case "In Verification":
        icon = Icons.pending_actions;
        color = Colors.blue;
        break;
      default:
        icon = Icons.info;
        color = Colors.grey;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          currentStatus,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    String buttonLabel() {
      switch (status) {
        case "Completed":
          return "View Proof";
        case "In Progress":
          return "Submit Proof";
        case "In Verification":
          return "Update Proof";
        default:
          return "Submit";
      }
    }

    VoidCallback? buttonAction() {
      switch (status) {
        case "Completed":
          return widget.onViewSubmission;
        case "In Progress":
          return () {
            widget.onSubmitProof?.call();
          };
        case "In Verification":
          return widget.onUpdateProof;
        default:
          return null;
      }
    }
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
                      widget.task.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 7,
                      ),
                    ),
                    onPressed: buttonAction(),
                    icon: const Icon(Icons.upload_file, size: 20, color: primaryColor),
                    label: Text(
                      buttonLabel(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      widget.task.description,
                      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 10,
                    thickness: 2,
                  ),

                  const SizedBox(height: 12),

                  _buildDetailRow(
                    label: "From",
                    value: widget.task.StartAddress,
                    icon: Icons.arrow_upward,
                  ),
                  _buildDetailRow(
                    label: "To",
                    value: widget.task.EndAddress,
                    icon: Icons.arrow_downward,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: status == "Completed"
                              ? Colors.green
                              : status == "In Progress"
                              ? Colors.orange
                              : status == "In Verification"
                              ? Colors.blue
                              : Colors.blueGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: statusWithIcon(status),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                    ],
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
