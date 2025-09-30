import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class tasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyTasksPage'),
      ),
      body: Center(
        child: Text('This is the MyTasksPage.'),
      ),
    );

  }
}