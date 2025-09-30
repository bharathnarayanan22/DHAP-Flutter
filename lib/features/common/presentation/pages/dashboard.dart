import 'package:dhap_flutter_project/features/common/presentation/pages/profile_page.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/drawerList.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/coordinatorDashboard.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/donorDashboard.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/switchButton.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/volunteerDashboard.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> userDetails;

  const DashboardPage({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    final String role = userDetails['role'] ?? 'User';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("$role Dashboard"),
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF0A2744),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => profilePage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 30,
                    left: 16,
                    right: 16,
                  ),
                  decoration: const BoxDecoration(color: Color(0xFF0A2744)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          "${(userDetails['name'] as String?)?.isNotEmpty == true ? (userDetails['name'] as String).substring(0, 1).toUpperCase() : 'U'}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2744),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${userDetails['name'] ?? 'User'}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Role: $role",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    RoleBasedDrawerItems(role: role),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        floatingActionButton: (role == 'Volunteer' || role == 'Donor') ? SwitchButton(role: userDetails['role']) : null,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: switch (role) {
              'Coordinator' => coordinatorDashboard(userDetails: userDetails),
              'Volunteer' => volunteerDashboard(userDetails: userDetails),
              'Donor' => donorDashboard(userDetails: userDetails),
              _ => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, ${userDetails['name'] ?? 'User'}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Email: ${userDetails['email']}'),
                    Text('Role: $role'),
                  ],
                ),
              ),
            },
          ),
        ),
      ),
    );
  }
}