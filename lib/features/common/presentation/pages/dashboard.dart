import 'package:dhap_flutter_project/data/db/sessiondb_helper.dart';
import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/auth/presentation/pages/auth_page.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonBloc.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonEvent.dart';
import 'package:dhap_flutter_project/features/common/bloc/commonState.dart';
import 'package:dhap_flutter_project/features/common/presentation/pages/profile_page.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/drawerList.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/coordinatorDashboard.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/donorDashboard.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/switchButton.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/volunteerDashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  //final Map<String, dynamic> userDetails;
  final User userDetails;

  const DashboardPage({super.key, required this.userDetails});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => commonBloc(),
      child: BlocConsumer<commonBloc, commonState>(
        listener: (context, state) {
          if (state is SwitchRoleSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            setState(() {
              currentUser = currentUser.copyWith(role: state.newRole);
            });
          } else if (state is FetchDataSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => DashboardPage(userDetails: currentUser),
              ),
            );
          } else if (state is commonFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final role = currentUser.role;

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text("$role Dashboard"),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF0A2744),
                actions: [
                  IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
                ],
              ),
              drawer: Drawer(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => commonBloc(),
                              child: ProfilePage(user: currentUser),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 30,
                          bottom: 30,
                          left: 16,
                          right: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0A2744),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                              child: Text(
                                "${(currentUser.name as String?)?.isNotEmpty == true ? (currentUser.name as String).substring(0, 1).toUpperCase() : 'U'}",
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
                                    "${currentUser.name}",
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
                          RoleBasedDrawerItems(
                            role: role,
                            userDetails: currentUser,
                            onRefresh: () =>
                                context.read<commonBloc>()
                                  ..add(FetchDataEvent()),
                          ),
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
                      onTap: () async {
                        final sessionHelper = Sessiondb_helper();
                        await sessionHelper.clearSession();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => AuthPage()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),

              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Always show the Switch Role button for Volunteer/Donor
                  if (role == 'Volunteer' || role == 'Donor')
                    BlocProvider.value(
                      value: context.read<commonBloc>(),
                      child: SwitchButton(
                        userDetails: currentUser,
                        onSwitch: () async {
                          final newRole = currentUser.role == "Volunteer"
                              ? "Donor"
                              : "Volunteer";

                          context.read<commonBloc>().add(
                            SwitchRoleSubmitted(
                              email: currentUser.email,
                              newRole: newRole,
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Show "Become Co" FAB only if the user is not a Coordinator
                  if (!currentUser.isCoordinator)
                    Container(
                      width: 125,
                      height: 40,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF0A2744), Color(0xFF4A90E2)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: FloatingActionButton.extended(
                        heroTag: 'applyCoordinatorFab',
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          final TextEditingController msgController = TextEditingController();

                          showDialog(
                            context: context,
                            builder: (dialogCtx) => BlocProvider.value(
                              value: context.read<commonBloc>(),
                              child: AlertDialog(
                                title: const Text('Apply for Coordinator Role'),
                                content: currentUser.isSubmitted == true
                                    ? const Text(
                                  'Your application has already been submitted and is under review.',
                                  style: TextStyle(fontSize: 16),
                                )
                                    : TextField(
                                  controller: msgController,
                                  decoration: const InputDecoration(
                                    labelText: 'Message',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogCtx).pop(),
                                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                                    child: const Text('Close'),
                                  ),
                                  if (currentUser.isSubmitted != true)
                                    ElevatedButton(
                                      onPressed: () {
                                        final message = msgController.text.trim();
                                        if (message.isNotEmpty) {
                                          context.read<commonBloc>().add(
                                            BecomeCoSubmitted(
                                              email: currentUser.email,
                                              message: message,
                                            ),
                                          );
                                          Navigator.of(dialogCtx).pop();
                                          setState(() {
                                            currentUser = currentUser.copyWith(isSubmitted: true);
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0A2744),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Submit'),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.how_to_reg, color: Colors.white),
                        label: const Text(
                          'Become Co',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),


              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: switch (role) {
                    'Coordinator' => coordinatorDashboard(
                      userDetails: currentUser,
                    ),
                    'Volunteer' => volunteerDashboard(userDetails: currentUser),
                    'Donor' => donorDashboard(userDetails: currentUser),
                    _ => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome, ${currentUser.name}!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('Email: ${currentUser.email}'),
                          Text('Role: $role'),
                        ],
                      ),
                    ),
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
