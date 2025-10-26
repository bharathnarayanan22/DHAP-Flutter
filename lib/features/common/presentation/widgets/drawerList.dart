import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonBloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/donor/bloc/donor_bloc.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_bloc.dart';
import 'package:dhap_flutter_project/features/volunteer/presentation/pages/myTasks_page.dart';
import 'package:dhap_flutter_project/features/volunteer/presentation/pages/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/createTask_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/viewHelpers_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/viewResources_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/viewTasks_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/verifyTasks_page.dart';
import 'package:dhap_flutter_project/features/donor/presentation/pages/donateResources.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/requestResponse_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/resourceRequest_page.dart';
import 'package:dhap_flutter_project/features/donor/presentation/pages/viewResourcerequests_page.dart';

import 'package:dhap_flutter_project/features/coordinator/presentation/pages/coApplication_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleBasedDrawerItems extends StatelessWidget {
  final String role;
  //final Map<String, dynamic> userDetails;
  final User userDetails;
  final VoidCallback onRefresh;

  const RoleBasedDrawerItems({
    super.key,
    required this.role,
    required this.userDetails,
    required this.onRefresh,
  });
  static const Color drawerTextColor = Color(0xFF0A2744);
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      ListTile(
        leading: const Icon(Icons.home, color: drawerTextColor),
        title: const Text('Home', style: TextStyle(color: drawerTextColor)),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ];

    if (role == 'Coordinator') {
      items.addAll([
        ListTile(
          leading: const Icon(Icons.add_task, color: drawerTextColor),
          title: const Text('Create Tasks'),
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<commonBloc>(),
                  child: CreateTasksPage(),
                ),
              ),
            );

          },
        ),
        ListTile(
          leading: const Icon(Icons.task, color: drawerTextColor),
          title: const Text('View Tasks'),
          onTap: () async {
            Navigator.pop(context);
            final bool? res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CoordinatorBloc(),
                  child: ViewTasksPage(),
                ),
              ),
            );
            if (res == true) {
              onRefresh();
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.people, color: drawerTextColor),
          title: const Text('View Helpers'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CoordinatorBloc(),
                  child: ViewHelpersPage(),
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.verified, color: drawerTextColor),
          title: const Text('Verify Tasks'),
          onTap: () async {
            Navigator.pop(context);
            final bool? res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CoordinatorBloc(),
                  child: VerifyTasksPage(),
                ),
              ),
            );
            if (res == true) {
              onRefresh();
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.request_page, color: drawerTextColor),
          title: const Text('Resource Request'),
          onTap: () async {
            Navigator.pop(context);
             await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<commonBloc>(),
                  child: ResourceRequestPage(),
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.food_bank_rounded, color: drawerTextColor),
          title: const Text('View Resources'),
          onTap: () async {
            Navigator.pop(context);
            final bool? res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CoordinatorBloc(),
                  child: ViewResourcesPage(),
                ),
              ),
            );

            if (res == true) {
              onRefresh();
            }
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.question_answer_rounded,
            color: drawerTextColor,
          ),
          title: const Text('Resource Responses'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CoordinatorBloc(),
                  child: ResourceResponsesPage(),
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.assignment_ind, color: drawerTextColor),
          title: const Text('Coordinator Applications'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CoordinatorBloc(),
                  child: CoordinatorApplicationsPage(),
                ),
              ),
            );
          },
        ),
      ]);
    } else if (role == 'Volunteer') {
      items.addAll([
        ListTile(
          leading: const Icon(Icons.task_alt, color: drawerTextColor),
          title: const Text('Available Tasks'),
          onTap: () async {
            Navigator.pop(context);
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => volunteerBloc(),
                  child: tasksPage(user: userDetails),
                ),
              ),
            );
            if (res != null && res is User) {
              userDetails.taskIds.clear();
              userDetails.taskIds.addAll(res.taskIds);
              onRefresh();
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.assignment, color: drawerTextColor),
          title: const Text('My Tasks'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => volunteerBloc(),
                  child: MyTasksPage(userDetails: userDetails),
                ),
              ),
            );
          },
        ),

      ]);
    } else if (role == 'Donor') {
      items.addAll([
        ListTile(
          leading: const Icon(Icons.request_page, color: drawerTextColor),
          title: const Text('View Resource Requests'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => DonorBloc(),
                  child: ViewResourceRequestsPage(userDetails: userDetails),
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.volunteer_activism, color: drawerTextColor),
          title: const Text('Donate Resources'),
          onTap: () async {
            Navigator.pop(context);
            final res = await Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => DonorBloc(),
                      child: DonateResourcesPage(userDetails: userDetails),
                    ),
                  ),
                )
                .then((result) {
                  if (result is User) {
                    onRefresh();
                  }
                });
            if (res != null && res is User) {
              userDetails.resourceIds.clear();
              userDetails.resourceIds.addAll(res.resourceIds);
              onRefresh();
            }
          },
        ),
        // ListTile(
        //   leading: const Icon(Icons.history, color: drawerTextColor),
        //   title: const Text('My Contributions'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     Navigator.of(context).push(
        //       MaterialPageRoute(builder: (context) => MyContributionsPage()),
        //     );
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(Icons.swap_horiz, color: drawerTextColor),
        //   title: const Text('Become A Co'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     Navigator.of(
        //       context,
        //     ).push(MaterialPageRoute(builder: (context) => CoApplication()));
        //   },
        // ),
      ]);
    }

    items.add(
      ListTile(
        leading: const Icon(Icons.settings, color: drawerTextColor),
        title: const Text('Settings'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );

    return Column(children: items);
  }
}
