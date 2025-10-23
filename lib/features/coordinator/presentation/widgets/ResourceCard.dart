import 'package:dhap_flutter_project/data/model/resource_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);

class ResourceCard extends StatelessWidget {
  final ResourceModel resource;
  const ResourceCard({required this.resource, super.key});
  //
  // Future<void> _openMap(double lat, double lng) async {
  //   final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _openMap(double lat, double lng) async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print('Tapped on resource: ${resource.resource}');
          print(resource.location.latitude);
          print(resource.location.longitude);
          _openMap(resource.location.latitude, resource.location.longitude);
        },
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withAlpha((0.25 * 255).round()),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,

                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    resource.resource,
                                    style: const TextStyle(
                                      color: primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'Qty: ${resource.quantity}',
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                          )
                      ),

                      Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InfoRow(
                                  icon: Icons.person_pin_circle,
                                  label: 'Donor',
                                  value: resource.DonorName,
                                  iconColor: Colors.white,
                                  labelColor: Colors.white,
                                  valueColor: Colors.white70,
                                ),
                                const SizedBox(height: 8),

                                InfoRow(
                                  icon: Icons.location_on,
                                  label: 'Address',
                                  value: resource.address,
                                  maxLines: 2,
                                  iconColor: Colors.white,
                                  labelColor: Colors.white,
                                  valueColor: Colors.white70,
                                ),
                              ]
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int maxLines;
  final Color iconColor;
  final Color labelColor;
  final Color valueColor;

  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
    this.iconColor = Colors.black,
    this.labelColor = Colors.black,
    this.valueColor = Colors.black,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: valueColor),
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }
}
