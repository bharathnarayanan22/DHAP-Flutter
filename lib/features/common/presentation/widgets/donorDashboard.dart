import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/builtMetricCard.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/dashboardCards.dart';
import 'package:dhap_flutter_project/features/donor/presentation/pages/donateResources.dart';
import 'package:dhap_flutter_project/features/donor/presentation/pages/myContributions_page.dart';
import 'package:dhap_flutter_project/features/donor/presentation/pages/viewResourcerequests_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color successColor = Color(0xFF66BB6A);

class donorDashboard extends StatelessWidget {
  // final Map<String, dynamic> userDetails;
  final User userDetails;

  const donorDashboard({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    int availableTasks = 10;
    int tasksDone =  3;
    String status = 'Available';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.waving_hand, color: primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Welcome,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '${userDetails.name ?? 'Volunteer'}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     MetricCard(
          //       title: 'Res. Requests',
          //       value: availableTasks,
          //       icon: Icons.list_alt,
          //       color: accentColor,
          //     ),
          //     MetricCard(
          //       title: 'Res. Donated',
          //       value: tasksDone,
          //       icon: Icons.check_circle_outline,
          //       color: successColor,
          //     ),
          //   ],
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: MetricCard(
                  title: 'Resource Requests',
                  value: availableTasks,
                  icon: Icons.pending_actions,
                  color: accentColor,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: MetricCard(
                  title: 'Resource Donated',
                  value: tasksDone,
                  icon: Icons.volunteer_activism,
                  color: successColor,
                ),
              ),
            ],
          ),


          const SizedBox(height: 20),
          Divider(color: Colors.grey),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.flash_on),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          DashboardCard(
            icon: Icons.campaign,
            title: 'Resource Requests',
            imageAsset: 'images/r1.svg',
            description:
            'View current resource needs and respond to communities in need.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewResourceRequestsPage(userDetails: userDetails,)),
              );
            },
          ),
          const SizedBox(height: 12),
          DashboardCard(
            icon: Icons.inventory,
            title: 'Donate Resources',
            imageAsset: 'images/r3.svg',
            description:
            'Offer food, clothing, medicine, or other essentials to support relief efforts.',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DonateResourcesPage())),
          ),
          const SizedBox(height: 12),
          DashboardCard(
            icon: Icons.handshake,
            title: 'My Contributions',
            imageAsset: 'images/r4.svg',
            description:
            'Review your past donations and see the difference you’ve made.',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyContributionsPage())),
          ),
        ],
      ),
    );
  }
}