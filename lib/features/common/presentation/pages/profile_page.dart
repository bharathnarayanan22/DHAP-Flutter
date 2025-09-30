import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profilePage extends StatelessWidget {
  const profilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF0A2744),
      ),
    );
  }
}
