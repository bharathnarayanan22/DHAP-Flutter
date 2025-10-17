import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonBloc.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonState.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/ResourceRequestBarChart.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/TaskStatusPieChart.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/builtMetricCard.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/dashboardCards.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/createTask_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/requestResponse_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/resourceRequest_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/verifyTasks_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/viewHelpers_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/viewResources_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/viewTasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repository/request_repository.dart';
import '../../../../data/repository/resource_repository.dart';
import '../../../../data/repository/response_repository.dart';
import '../../../../data/repository/task_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../bloc/commonEvent.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color successColor = Color(0xFF66BB6A);
const Color warningColor = Color(0xFFFFC107);
const Color infoColor = Color(0xFF9E9E9E);
const Color secondaryAccentColor = Color(0xFF1E88E5);

class coordinatorDashboard extends StatelessWidget {
  final User userDetails;
  const coordinatorDashboard({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 16.0;
    const spacing = 16.0;
    const minCardWidth = 150.0;
    final availableWidth = screenWidth - 2 * padding;

    final cardsPerRow = (availableWidth / (minCardWidth + spacing))
        .floor()
        .clamp(1, 4);
    final cardWidth =
        (availableWidth - (spacing * (cardsPerRow - 1))) / cardsPerRow;

    return BlocProvider(
      create: (context) => commonBloc()..add(FetchDataEvent()),
      child: BlocBuilder<commonBloc, commonState>(
        builder: (context, state) {
          final commonBloc dashboardBloc = context.read<commonBloc>();
          if (state is commonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchDataSuccess) {
            final totalTasks = state.tasks.length;
            final completedTasks = state.tasks
                .where((t) => t.Status == 'Completed')
                .length;
            final inProgressTasks = state.tasks
                .where((t) => t.Status == 'In Progress')
                .length;
            final pendingTasks = state.tasks
                .where((t) => t.Status == 'Pending')
                .length;
            final unverifiedTasks = state.tasks
                .where((t) => t.Status == 'In Verification')
                .length;
            final activeVolunteers = state.users
                .where((u) => u.role == 'Volunteer' && u.inTask)
                .length;
            final pendingRequests = state.requests
                .where((r) => r.status == 'Pending')
                .length;

            final Fooditems = state.resources
                .where((r) => r.ResourceType == 'Food')
                .length;
            final Wateritems = state.resources
                .where((r) => r.ResourceType == 'Water')
                .length;
            final Medicalitems = state.resources
                .where((r) => r.ResourceType == 'Medicine')
                .length;
            final Shelteritems = state.resources
                .where((r) => r.ResourceType == 'Shelter')
                .length;

            final taskStatusData = [
              {
                'label': 'Completed',
                'value': completedTasks.toDouble(),
                'color': successColor,
              },
              {
                'label': 'In Progress',
                'value': inProgressTasks.toDouble(),
                'color': accentColor,
              },
              {
                'label': 'In Verification.',
                'value': unverifiedTasks.toDouble(),
                'color': warningColor,
              },
              {
                'label': 'Pending',
                'value': pendingTasks.toDouble(),
                'color': infoColor,
              },
            ];

            final resourceRequestData = [
              {
                'label': 'Food',
                'value': Fooditems.toDouble(),
                'color': warningColor,
              },
              {
                'label': 'Water',
                'value': Wateritems.toDouble(),
                'color': accentColor,
              },
              {
                'label': 'Medicine',
                'value': Medicalitems.toDouble(),
                'color': secondaryAccentColor,
              },
              {
                'label': 'Shelter Kits',
                'value': Shelteritems.toDouble(),
                'color': successColor,
              },
            ];
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
                        'Welcome, ${userDetails.name}!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Wrap(
                    spacing: spacing,
                    runSpacing: 16.0,
                    alignment: WrapAlignment.start,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: MetricCard(
                          title: 'Total Tasks',
                          value: totalTasks,
                          icon: Icons.list_alt,
                          color: accentColor,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: MetricCard(
                          title: 'Unverified Tasks',
                          value: unverifiedTasks,
                          icon: Icons.search,
                          color: accentColor,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: MetricCard(
                          title: 'Active Volunteers',
                          value: activeVolunteers,
                          icon: Icons.people,
                          color: successColor,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: MetricCard(
                          title: 'Pending Requests',
                          value: pendingRequests,
                          icon: Icons.inventory_2_outlined,
                          color: successColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Divider(color: Colors.grey),

                  const SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.dashboard, color: primaryColor, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Operational Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  TaskStatusPieChart(data: taskStatusData),

                  const SizedBox(height: 16),

                  ResourceRequestBarChart(
                    data: resourceRequestData,
                    unitLabel: 'Units Requested',
                  ),

                  const SizedBox(height: 30),

                  const Divider(color: Colors.grey),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      const Icon(Icons.flash_on, color: primaryColor),
                      const SizedBox(width: 8),
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
                    icon: Icons.add_task,
                    title: 'Create Tasks',
                    imageAsset: 'images/c1.svg',
                    description:
                        'Create and assign new tasks for volunteers to work on.',
                    onTap: () async {
                      final bool? res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => CoordinatorBloc(),
                            child: CreateTasksPage(),
                          ),
                        ),
                      );

                      if (res == true) {
                        dashboardBloc.add(FetchDataEvent());
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    icon: Icons.task,
                    title: 'View Tasks',
                    imageAsset: 'images/c8.svg',
                    description:
                        'See all active and completed tasks in your coordination list.',
                    onTap: () async {
                      final bool res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => CoordinatorBloc(),
                            child: ViewTasksPage(),
                          ),
                        ),
                      );
                      //print('res: ${res}');
                      if (res == true) {
                        dashboardBloc.add(FetchDataEvent());
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    icon: Icons.people,
                    title: 'View Helpers',
                    imageAsset: 'images/c4.svg',
                    description:
                        'Check the list of volunteers available to assist with tasks.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => CoordinatorBloc(),
                          child: ViewHelpersPage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    icon: Icons.verified,
                    title: 'Verify Tasks',
                    imageAsset: 'images/c3.svg',
                    description:
                        'Review and approve tasks once they are completed by volunteers.',
                    onTap: () async {
                      final bool res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => CoordinatorBloc(),
                            child: VerifyTasksPage(),
                          ),
                        ),
                      );
                     if (res == true) {
                        dashboardBloc.add(FetchDataEvent());
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    icon: Icons.request_page,
                    title: 'Resource Request',
                    imageAsset: 'images/c5.svg',
                    description:
                        'Submit or manage requests for essential relief resources.',
                    onTap: () async {
                      final bool res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => CoordinatorBloc(),
                            child: ResourceRequestPage(),
                          ),
                        ),
                      );
                      if (res == true) {
                        dashboardBloc.add(FetchDataEvent());
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    icon: Icons.food_bank_rounded,
                    title: 'View Resources',
                    imageAsset: 'images/c6.svg',
                    description:
                        'Browse available resources and track their distribution.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => CoordinatorBloc(),
                          child: ViewResourcesPage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    icon: Icons.question_answer_rounded,
                    title: 'Resource Responses',
                    imageAsset: 'images/c7.svg',
                    description:
                        'Monitor and manage responses from donors and volunteers to resource requests.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => CoordinatorBloc(),
                          child: ResourceResponsesPage(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
