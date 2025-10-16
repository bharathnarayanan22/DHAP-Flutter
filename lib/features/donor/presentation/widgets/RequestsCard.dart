import 'package:dhap_flutter_project/data/model/request_model.dart';
import 'package:dhap_flutter_project/data/model/response_model.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_bloc.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

const Color primaryColor = Color(0xFF0A2744);

class DonorLocationData {
  final LatLng location;
  final String address;
  DonorLocationData({required this.location, required this.address});
}

class RequestsCard extends StatelessWidget {
  final Request request;
  final String user;
  final String email;
  const RequestsCard({super.key, required this.request, required this.user, required this.email});

  Future<void> _openMap(double lat, double lng) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  Future<DonorLocationData?> _getCurrentLocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          throw Exception('Location permissions are required.');
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      final addressString = '${place.street}, ${place.locality}, ${place.country}';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location retrieved successfully!'), backgroundColor: Colors.green),
      );

      return DonorLocationData(
        location: LatLng(position.latitude, position.longitude),
        address: addressString,
      );

    } catch (e) {
      debugPrint('Location error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}'), backgroundColor: Colors.red),
      );
      return null;
    }
  }


  void _showRespondDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final messageController = TextEditingController();
    final quantityController = TextEditingController();

    final locationDataNotifier = ValueNotifier<DonorLocationData?>(null);
    final isLocatingNotifier = ValueNotifier<bool>(false);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Response: ', style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      labelText: 'Your Message/Details',
                      hintText: 'e.g., I have 10 units available now.',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'A message is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity You Can Provide',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final quantity = int.tryParse(value ?? '');
                      if (quantity == null || quantity <= 0) {
                        return 'Please enter a valid quantity (> 0).';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  ValueListenableBuilder<DonorLocationData?>(
                    valueListenable: locationDataNotifier,
                    builder: (context, locationData, child) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: locationData != null ? primaryColor.withOpacity(0.05) : Colors.red.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: locationData != null ? primaryColor : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locationData == null
                                  ? '⚠️ Location Not Set'
                                  : 'Selected Location:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: locationData == null ? Colors.red : primaryColor
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              locationData?.address ?? 'Click the button below to retrieve your current location.',
                              style: TextStyle(
                                fontSize: 14,
                                color: locationData == null ? Colors.black54 : Colors.black,
                                fontStyle: locationData == null ? FontStyle.italic : FontStyle.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),

                            ValueListenableBuilder<bool>(
                              valueListenable: isLocatingNotifier,
                              builder: (context, isLocating, child) {
                                return Center(
                                  child: ElevatedButton.icon(
                                    onPressed: isLocating ? null : () async {
                                      isLocatingNotifier.value = true;
                                      final newLocationData = await _getCurrentLocation(context);
                                      locationDataNotifier.value = newLocationData;
                                      isLocatingNotifier.value = false;
                                    },
                                    icon: isLocating
                                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                                        : const Icon(Icons.my_location, size: 18),
                                    label: Text(isLocating ? 'Getting Location...' : 'Get My Location'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ValueListenableBuilder<DonorLocationData?>(
              valueListenable: locationDataNotifier,
              builder: (innerContext, locationData, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: (locationData == null || isLocatingNotifier.value) ? null : () {
                    if (formKey.currentState!.validate()) {
                      context.read<DonorBloc>().add(
                        RespondEvent(
                          requestId: request.id,
                          message: messageController.text,
                          quantityProvided: int.parse(quantityController.text),
                          address: "Address",
                          location: locationData.location,
                          user: user,
                          userEmail: email,
                        ),
                      );
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: const Text('Submit Response'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          request.resource,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: const Icon(
                            Icons.location_on,
                            color: primaryColor,
                          ),
                        ),

                        label: const Text(
                          'View Location',
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide.none,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 0,
                        ),
                        onPressed: () {
                          _openMap(
                            request.location.latitude,
                            request.location.longitude,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Address: ${request.address}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    request.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black87),
                  ),

                  const Divider(
                    height: 30,
                    color: Colors.black12,
                    thickness: 2,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showRespondDialog(context),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Respond'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
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
