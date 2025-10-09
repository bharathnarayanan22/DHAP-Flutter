import 'package:flutter/material.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';

class SwitchButton extends StatelessWidget {
  final User userDetails;
  final VoidCallback onSwitch;

  const SwitchButton({
    super.key,
    required this.userDetails,
    required this.onSwitch,
  });

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
        onPressed: onSwitch, // just call the callback
        icon: const Icon(Icons.swap_horiz, color: Colors.white),
        label: Text(
          userDetails.role == "Volunteer" ? "Donor" : "Volunteer",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
