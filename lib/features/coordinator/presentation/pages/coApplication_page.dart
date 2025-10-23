import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/common/presentation/pages/profile_page.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_event.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);
const Color successColor = Color(0xFF66BB6A);
const Color rejectColor = Colors.redAccent;
const List<String> statusFilters = ['All', 'Pending', 'Accepted', 'Rejected'];

class CoordinatorApplicationsPage extends StatefulWidget {
  const CoordinatorApplicationsPage({super.key});

  @override
  State<CoordinatorApplicationsPage> createState() =>
      _CoordinatorApplicationsPageState();
}

class _CoordinatorApplicationsPageState
    extends State<CoordinatorApplicationsPage> {
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoordinatorBloc>().add(FetchApplicationsWithUsers());
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  List<Map<String, dynamic>> _filterApplications(
    List applications,
    List<User> users,
  ) {
    final searchTerm = _searchController.text.toLowerCase();
    List<Map<String, dynamic>> filtered = [];

    for (var app in applications) {
      final user = users.firstWhere((u) => u.email == app.email);
      final matchesStatus =
          _selectedStatus == 'All' ||
          app.status.toLowerCase() == _selectedStatus.toLowerCase();
      final matchesSearch =
          searchTerm.isEmpty || (user.name.toLowerCase().contains(searchTerm));
      if (matchesStatus && matchesSearch) {
        filtered.add({'app': app, 'user': user});
      }
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_ind, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text("Applications", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<CoordinatorBloc, CoordinatorState>(
        builder: (context, state) {
          if (state is CoordinatorLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FetchApplicationWithUserSuccess) {
            final filteredApps = _filterApplications(
              state.applications,
              state.users,
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by name...',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatus,
                            icon: const Icon(
                              Icons.filter_list,
                              color: primaryColor,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              }
                            },
                            items: statusFilters
                                .map(
                                  (value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: filteredApps.isEmpty
                      ? const Center(child: Text('No applications found.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredApps.length,
                          itemBuilder: (context, index) {
                            final app = filteredApps[index]['app'];
                            final user = filteredApps[index]['user'];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: accentColor,
                                          child: Text(
                                            user.name.isNotEmpty
                                                ? user.name[0].toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            user.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ProfilePage(user: user),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: primaryColor,
                                            size: 20,
                                          ),
                                          label: const Text(
                                            'View Profile',
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                              // fontSize: 18,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          app.message,
                                          style: const TextStyle(
                                            color: primaryColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        app.status.toLowerCase() == 'pending'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                            CoordinatorBloc
                                                          >()
                                                          .add(
                                                            AcceptApplication(
                                                              app.id,
                                                            ),
                                                          );
                                                    },
                                                    icon: const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                    label: const Text("Accept"),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          successColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                            CoordinatorBloc
                                                          >()
                                                          .add(
                                                            RejectApplication(
                                                              app.id,
                                                            ),
                                                          );
                                                    },
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                    label: const Text("Reject"),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          rejectColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 6,
                                                          horizontal: 12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          app.status
                                                                  .toLowerCase() ==
                                                              'accepted'
                                                          ? successColor
                                                          : rejectColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          app.status.toLowerCase() ==
                                                                  'accepted'
                                                              ? Icons
                                                                    .check_circle
                                                              : Icons.cancel,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          app.status
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          if (state is CoordinatorFailure) {
            return Center(child: Text("Error: ${state.error}"));
          }

          return const Center(child: Text("No applications found."));
        },
      ),
    );
  }
}
