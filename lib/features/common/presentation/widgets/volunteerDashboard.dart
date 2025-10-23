// import 'package:dhap_flutter_project/features/common/presentation/widgets/builtMetricCard.dart';
// import 'package:dhap_flutter_project/features/common/presentation/widgets/dashboardCards.dart';
// import 'package:dhap_flutter_project/features/volunteer/presentation/pages/myTasks_page.dart';
// import 'package:dhap_flutter_project/features/volunteer/presentation/pages/tasks_page.dart';
// import 'package:flutter/material.dart';
//
// const Color primaryColor = Color(0xFF0A2744);
// const Color accentColor = Color(0xFF42A5F5);
// const Color successColor = Color(0xFF66BB6A);
//
// class volunteerDashboard extends StatelessWidget {
//   final Map<String, dynamic> userDetails;
//
//   const volunteerDashboard({super.key, required this.userDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     int availableTasks = userDetails['availableTasks'] ?? 10;
//     int tasksDone = userDetails['tasksDone'] ?? 3;
//     String status = userDetails['status'] ?? 'Available';
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.waving_hand, color: primaryColor, size: 24),
//               const SizedBox(width: 8),
//               Text(
//                 'Welcome,',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: primaryColor,
//                 ),
//               ),
//               SizedBox(width: 8),
//               Text(
//                 '${userDetails['name'] ?? 'Volunteer'}!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: primaryColor,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               MetricCard(
//                 title: 'Available Tasks',
//                 value: availableTasks,
//                 icon: Icons.list_alt,
//                 color: accentColor,
//               ),
//               MetricCard(
//                 title: 'Tasks Completed',
//                 value: tasksDone,
//                 icon: Icons.check_circle_outline,
//                 color: successColor,
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           Divider(color: Colors.grey),
//
//           const SizedBox(height: 15),
//
//           Row(
//             children: [
//               Icon(Icons.flash_on),
//               Text(
//                 'Quick Actions',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: primaryColor,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//
//           DashboardCard(
//             icon: Icons.search,
//             title: 'Available Tasks',
//             imageAsset: 'images/accept_tasks.svg',
//             description:
//                 'Browse and accept tasks that are open for you to work on.',
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => tasksPage()),
//               );
//             },
//           ),
//           const SizedBox(height: 12),
//           DashboardCard(
//             icon: Icons.assignment_turned_in,
//             title: 'My Tasks',
//             imageAsset: 'images/Task.png',
//             description:
//                 'View the tasks you are currently assigned to and track progress.',
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyTasksPage())),
//           ),
//           const SizedBox(height: 12),
//           // DashboardCard(
//           //   //icon: Icons.swap_horiz,
//           //   title: 'Switch Role',
//           //   description: 'Switch to Donor or Coordinator roles if you have access.',
//           //   //cardColor: primaryColor.withOpacity(0.7),
//           // ),
//         ],
//       ),
//     );
//   }
// }

import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonBloc.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonEvent.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonState.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/builtMetricCard.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/dashboardCards.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_bloc.dart';
import 'package:dhap_flutter_project/features/volunteer/presentation/pages/myTasks_page.dart';
import 'package:dhap_flutter_project/features/volunteer/presentation/pages/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color successColor = Color(0xFF66BB6A);

class volunteerDashboard extends StatelessWidget {
  final User userDetails;

  const volunteerDashboard({super.key, required this.userDetails});


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => commonBloc()..add(FetchDataEvent()),
      child: BlocBuilder<commonBloc, commonState>(
        builder: (context, state) {
          final commonBloc dashboardBloc = context.read<commonBloc>();
          if (state is commonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchDataSuccess) {
            final availableTasks = state.tasks
                .where(
                  (task) =>
                      task.Status == 'Pending' ||
                      task.Status == 'In Progress' &&
                          task.volunteer > task.volunteersAccepted,
                )
                .length;
            final userTasks = state.tasks
                .where((task) => userDetails.taskIds.contains(task.id))
                .toList();

            print('userTasks: $userTasks');
            final completedTasks = userTasks
                .where((task) => task.Status == 'Completed')
                .toList();
            final tasksDone = completedTasks.length;

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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: MetricCard(
                          title: 'Available Tasks',
                          value: availableTasks,
                          icon: Icons.list_alt,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MetricCard(
                          title: 'Tasks Completed',
                          value: tasksDone,
                          icon: Icons.check_circle_outline,
                          color: successColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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
                    icon: Icons.search,
                    title: 'Available Tasks',
                    imageAsset: 'images/c2.svg',
                    description:
                        'Browse and accept tasks that are open for you to work on.',
                    onTap: () async {
                      final res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => volunteerBloc(),
                            child: tasksPage(user: userDetails),
                          ),
                        ),
                      );
                      print('=> res: ${res}');
                      if (res != null && res is User) {
                        userDetails.taskIds.clear();
                        userDetails.taskIds.addAll(res.taskIds);
                        print('=> user tasks: ${userDetails.taskIds.length}');
                        dashboardBloc.add(FetchDataEvent());
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    icon: Icons.assignment_turned_in,
                    title: 'My Tasks',
                    imageAsset: 'images/Task.png',
                    description:
                        'View the tasks you are currently assigned to and track progress.',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => volunteerBloc(),
                          child: MyTasksPage(userDetails: userDetails),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
