import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonBloc.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonEvent.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonState.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/builtMetricCard.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/dashboardCards.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_bloc.dart';
import 'package:dhap_flutter_project/features/donor/presentation/pages/donateResources.dart';
import 'package:dhap_flutter_project/features/donor/presentation/pages/myContributions_page.dart';
import 'package:dhap_flutter_project/features/donor/presentation/pages/viewResourcerequests_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color successColor = Color(0xFF66BB6A);

class donorDashboard extends StatefulWidget {
  final User userDetails;

  const donorDashboard({super.key, required this.userDetails});

  @override
  State<donorDashboard> createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<donorDashboard> {
  late User _userDetails;

  @override
  void initState() {
    super.initState();
    _userDetails = widget.userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => commonBloc()..add(FetchDataEvent()),
      child: BlocBuilder<commonBloc, commonState>(
        builder: (context, state) {
          if (state is commonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchDataSuccess) {
            print(_userDetails.resourceIds);
            final requests = state.requests
                .where((r) => r.status == 'Pending')
                .length;

            final resources = _userDetails.resourceIds.length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.waving_hand,
                          color: primaryColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Welcome, ${_userDetails.name}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: MetricCard(
                          title: 'Resource Requests',
                          value: requests,
                          icon: Icons.pending_actions,
                          color: accentColor,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: MetricCard(
                          title: 'Resource Donated',
                          value: resources,
                          icon: Icons.volunteer_activism,
                          color: successColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 15),
                  Row(
                    children: const [
                      Icon(Icons.flash_on),
                      SizedBox(width: 6),
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
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => DonorBloc(),
                            child:
                            ViewResourceRequestsPage(userDetails: _userDetails),
                          ),
                        ),
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => DonorBloc(),
                          child:
                          DonateResourcesPage(userDetails: _userDetails),
                        ),
                      ),
                    ).then((result) {
                      if (result is User) {
                        setState(() {
                          _userDetails = result;
                        });
                        context.read<commonBloc>().add(FetchDataEvent());
                      }
                    }),
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    icon: Icons.handshake,
                    title: 'My Contributions',
                    imageAsset: 'images/r4.svg',
                    description:
                    'Review your past donations and see the difference you’ve made.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyContributionsPage(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is commonFailure) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

