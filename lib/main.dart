import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/auth/presentation/pages/auth_page.dart';
import 'package:dhap_flutter_project/features/common/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final User userDetails = User(name: 'test user',
    email: 'testuser@gmail.com',
    password: '123456789',
    mobile: '7894561239',
    addressLine: 'a',
    city: 'b',
    country: 'c',
    pincode: '456456',
    role: 'Coordinator',
    taskIds: [1, 2, 3, 4],);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DHAP",
      // theme: ThemeData(
      //   useMaterial3: true,
      //   primaryColor: const Color(0xFF0A2744),
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: const Color(0xFF0A2744),
      //     primary: const Color(0xFF0A2744),
      //     secondary: const Color(0xFF4A90E2),
      //   ),
      //   scaffoldBackgroundColor: const Color(0xFF0A2744),
      // ),
      home: SafeArea(child: DashboardPage(userDetails:
          userDetails
      ))
      //   home: SafeArea(child: AuthPage()
      //   )
    );
  }
}