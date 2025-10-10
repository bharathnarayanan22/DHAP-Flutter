import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_event.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_state.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/pages/createTask_page.dart';
import 'package:dhap_flutter_project/features/coordinator/presentation/widgets/TaskCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Location {
  final double latitude;
  final double longitude;
  Location(this.latitude, this.longitude);
}

  const Color primaryColor = Color(0xFF0A2744);
  const Color accentColor = Color(0xFF42A5F5);

const List<String> statusFilters = [
  'All',
  'In Progress',
  'Completed',
  'Unassigned',
  'Verified',
];

class ViewTasksPage extends StatefulWidget {
  const ViewTasksPage({super.key});

  @override
  State<ViewTasksPage> createState() => _ViewTasksPageState();
}

class _ViewTasksPageState extends State<ViewTasksPage> {
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoordinatorBloc>().add(FetchTasksEvent());
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

  void _onEdit(Task task) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateTasksPage(existingTask: task),
      ),
    );

    if (res == true && mounted) {
      context.read<CoordinatorBloc>().add(FetchTasksEvent());
    }
  }


  void _onDelete(BuildContext blocContext,Task task) {
    print('Deleting Task: ${task.id}');
    showDialog(
      context: blocContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete task: ${task.title}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
             blocContext.read<CoordinatorBloc>().add(DeleteTaskEvent(taskId: task.id));
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: dangerColor, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<Task> _filterTasks(List<Task> tasks) {
    String searchTerm = _searchController.text.toLowerCase();

    List<Task> statusFiltered = tasks.where((task) {
      if (_selectedStatus == 'All') {
        return true;
      }
      return task.Status == _selectedStatus;
    }).toList();

    if (searchTerm.isEmpty) {
      return statusFiltered;
    }

    return statusFiltered.where((task) {
      return task.title.toLowerCase().contains(searchTerm) ||
          task.description.toLowerCase().contains(searchTerm);
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_turned_in, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              "Task List",
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
          } else if (state is CoordinatorSuccess) {
            final allTasks = state.tasks;
            print('All Tasks: $allTasks');
            final filteredTasks = _filterTasks(allTasks as List<Task>);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by title or description...',
                            prefixIcon: const Icon(Icons.search, color: primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatus,
                            icon: const Icon(Icons.filter_list, color: primaryColor),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedStatus = newValue;
                                });
                              }
                            },
                            items: statusFilters.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: filteredTasks.isEmpty
                      ? Center(child: Text('No tasks found for the current filter/search criteria.', style: TextStyle(color: primaryColor)))
                      : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return TaskCard(
                        task: task,
                        onEdit: () => _onEdit(task),
                        onDelete: () => _onDelete(context, task),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is CoordinatorFailure) {
            return Center(child: Text('Error: ${state.error}', style: TextStyle(color: dangerColor, fontWeight: FontWeight.bold)));
          }
          return const Center(child: Text('Press refresh or pull down to load tasks.'));
        },
      ),
    );
  }
}
