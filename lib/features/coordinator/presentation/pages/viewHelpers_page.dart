import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/common/presentation/widgets/builtMetricCard.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_event.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color primaryColor = Color(0xFF0A2744);
const List<String> statusFilters = [
  'All',
  'Coordinator',
  'Volunteer',
  'Donor',
];

class ViewHelpersPage extends StatefulWidget {
  @override
  State<ViewHelpersPage> createState() => _ViewHelpersPageState();
}

class _ViewHelpersPageState extends State<ViewHelpersPage> {
  String _selectedRole = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoordinatorBloc>().add(FetchUsersEvent());
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<User> _filterUsers(List<User> users) {
    final searchTerm = _searchController.text.toLowerCase();

    final roleFiltered = _selectedRole == 'All'
        ? users
        : users.where((u) => u.role == _selectedRole).toList();

    if (searchTerm.isEmpty) return roleFiltered;

    return roleFiltered
        .where((u) => u.name.toLowerCase().contains(searchTerm))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              "Helpers",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CoordinatorBloc, CoordinatorState>(
        builder: (context, state) {
          if (state is CoordinatorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserSuccess) {
            final filteredUsers = _filterUsers(state.users);

            final volunteerCount =
                state.users.where((u) => u.role == "Volunteer").length;
            final donorCount =
                state.users.where((u) => u.role == "Donor").length;
            final coordinatorCount =
                state.users.where((u) => u.role == "Coordinator").length;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MetricCard(
                              title: 'Volunteers',
                              value: volunteerCount,
                              icon: Icons.list_alt,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: MetricCard(
                              title: 'Donors',
                              value: donorCount,
                              icon: Icons.check_circle_outline,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search by name...',
                                prefixIcon: const Icon(Icons.search, color: primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: primaryColor, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: primaryColor, width: 2),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedRole,
                                icon: const Icon(Icons.filter_list, color: primaryColor),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedRole = newValue;
                                    });
                                  }
                                },
                                items: statusFilters
                                    .map((value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                    itemCount: filteredUsers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      Color borderColor;
                      switch (user.role) {
                        case 'Coordinator':
                          borderColor = Colors.blue;
                          break;
                        case 'Volunteer':
                          borderColor = Colors.green;
                          break;
                        case 'Donor':
                          borderColor = Colors.orange;
                          break;
                        default:
                          borderColor = Colors.grey;
                      }
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: borderColor, width: 5),
                          ),
                        ),
                        child: ListTile(
                          title: Text(user.name,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(user.role),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserProfilePage(user: user),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Expanded(
                //   child: ReorderableListView.builder(
                //     itemCount: filteredUsers.length,
                //     onReorder: (oldIndex, newIndex) {
                //       setState(() {
                //         if (newIndex > oldIndex) {
                //           newIndex -= 1;
                //         }
                //         final item = filteredUsers.removeAt(oldIndex);
                //         filteredUsers.insert(newIndex, item);
                //       });
                //     },
                //     itemBuilder: (context, index) {
                //       final user = filteredUsers[index];
                //       Color borderColor;
                //       switch (user.role) {
                //         case 'Coordinator':
                //           borderColor = Colors.blue;
                //           break;
                //         case 'Volunteer':
                //           borderColor = Colors.green;
                //           break;
                //         case 'Donor':
                //           borderColor = Colors.orange;
                //           break;
                //         default:
                //           borderColor = Colors.grey;
                //       }
                //
                //       return Container(
                //         key: ValueKey(user), // 🔑 Required for ReorderableListView
                //         decoration: BoxDecoration(
                //           border: Border(
                //             left: BorderSide(color: borderColor, width: 5),
                //           ),
                //         ),
                //         child: ListTile(
                //           title: Text(user.name,
                //               style: const TextStyle(fontWeight: FontWeight.w600)),
                //           subtitle: Text(user.role),
                //           trailing: const Icon(Icons.drag_handle, color: Colors.grey),
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (_) => UserProfilePage(user: user),
                //               ),
                //             );
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),

              ],
            );

          }

          return const Center(child: Text('No users found.'));
        },
      ),
    );
  }
}

// Simple profile page
class UserProfilePage extends StatelessWidget {
  final User user;

  const UserProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.name}'s Profile"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Name: ${user.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Role: ${user.role}", style: const TextStyle(fontSize: 18)),
            // Add more details from your User model here
          ],
        ),
      ),
    );
  }
}
