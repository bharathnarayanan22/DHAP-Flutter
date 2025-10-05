import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoApplication extends StatefulWidget {
  const CoApplication({super.key});

  @override
  State<CoApplication> createState() => _CoApplicationState();
}

class _CoApplicationState extends State<CoApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz, color: Colors.white,
                size: 24),
            SizedBox(width: 8),
            Text(
              "Become A Co",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color(0xFF0A2744),
        foregroundColor: Colors.white,
      ),
    );
  }
}
