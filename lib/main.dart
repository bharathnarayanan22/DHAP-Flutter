import 'package:dhap_flutter_project/data/db/CouchbaseCore_helper.dart';
import 'package:dhap_flutter_project/data/db/sessiondb_helper.dart';
import 'package:dhap_flutter_project/data/db/userdb_helper.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/auth/presentation/pages/auth_page.dart';
import 'package:dhap_flutter_project/features/common/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CouchbaseCoreHelper().init();
  final sessionHelper = Sessiondb_helper();
  final isLoggedIn = await sessionHelper.isLoggedIn();
  final userHelper = Userdb_helper();
  User? userDetails;
  if(isLoggedIn) {
    final userEmail = await sessionHelper.getUserEmail();
    userDetails = await userHelper.getUserByEmail(userEmail);
  }

  runApp(MyApp(isLoggedIn: isLoggedIn, userDetails: userDetails));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final User? userDetails;
  MyApp({super.key, required this.isLoggedIn, required this.userDetails});

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
      // home: SafeArea(child: DashboardPage(userDetails:
      //     userDetails
      // ))
      home: SafeArea(
        child: isLoggedIn && userDetails != null
            ? DashboardPage(userDetails: userDetails!)
            : AuthPage(),
      ),
    );
  }
}
