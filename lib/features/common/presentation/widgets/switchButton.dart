import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  final String role;
  const SwitchButton({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A2744), Color(0xFF4A90E2)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        // elevation: 0,
        onPressed: () {
          debugPrint("SwitchButton Clicked: $role");
        },
        icon: const Icon(Icons.swap_horiz, color: Colors.white),
        label: Text(
          role == "Volunteer" ? "Donor" : "Volunteer",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
