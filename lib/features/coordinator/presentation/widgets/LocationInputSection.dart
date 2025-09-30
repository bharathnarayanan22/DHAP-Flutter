import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationInputSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final TextEditingController addressController;
  final LatLng? currentLocation;
  final Function(String) onAddressSubmitted;
  final Function(LatLng) onMapTap;
  final Color mapColor;
  final IconData mapIcon;

  const LocationInputSection({
    required this.title,
    required this.icon,
    required this.addressController,
    required this.currentLocation,
    required this.onAddressSubmitted,
    required this.onMapTap,
    required this.mapColor,
    required this.mapIcon,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0A2744);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: 'Location Name / Address',
            labelStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.pin_drop_outlined, color: primaryColor, size: 20),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: primaryColor),
              onPressed: () => onAddressSubmitted(addressController.text),
            ),
            // border: OutlineInputBorder(bordeTricrRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          ),
          onFieldSubmitted: onAddressSubmitted,
          validator: (value) => (value!.isEmpty && currentLocation == null) ? 'Please enter address or tap on map' : null,
        ),
        const SizedBox(height: 16),

        Container(
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(
              color: currentLocation == null ? Colors.redAccent : mapColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: currentLocation ?? const LatLng(20.5937, 78.9629),
                initialZoom: currentLocation != null ? 10 : 4,
                onTap: (tapPosition, point) => onMapTap(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.app',
                ),
                if (currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLocation!,
                        width: 30,
                        height: 30,
                        child: Icon(
                          mapIcon,
                          size: 30,
                          color: mapColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),

        if (currentLocation != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "Coordinates: Lat: ${currentLocation!.latitude.toStringAsFixed(4)}, Lon: ${currentLocation!.longitude.toStringAsFixed(4)}",
              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),

        if (currentLocation == null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "⚠️ Please tap the map or search the address to set the location.",
              style: TextStyle(fontSize: 14, color: Colors.yellow),
            ),
          ),
      ],
    );
  }
}