import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_bloc.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_event.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_state.dart';
import 'package:dhap_flutter_project/features/volunteer/presentation/widgets/AvailTaskCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);

class tasksPage extends StatefulWidget {
  final User user;

  const tasksPage({super.key, required this.user});

  @override
  State<tasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<tasksPage> {
  bool _taskAccepted = false;

  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<volunteerBloc>().add(FetchPendingTasksEvent());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('Back button pressed: ${_taskAccepted}');
        Navigator.of(context).pop(currentUser);
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.task_alt, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  "Available Tasks",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                print('Back button pressed: ${_taskAccepted}');
                Navigator.of(context).pop(currentUser);
              },
            ),
          ),
          body: BlocListener<volunteerBloc, volunteerState>(
            listener: (context, state) {

              if (state is AcceptSuccess) {
                setState(() {
                  currentUser = state.user;
                });
                context.read<volunteerBloc>().add(FetchPendingTasksEvent());
              }
            },
            child: BlocBuilder<volunteerBloc, volunteerState>(
                builder: (context, state) {
                  if (state is volunteerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (state is volunteerSuccess) {
                    final tasks = state.tasks;
                    if (tasks.isEmpty) {
                      return const Center(child: Text("No tasks available"));
                    }
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Center(
                          child: ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return AvailTaskCard(
                                  task: task,
                                  user: widget.user,
                                  onTaskAccepted: () {
                                    print("Task accepted");
                                    setState(() {
                                      _taskAccepted = true;
                                    });
                                  },
                                );
                              }
                          ),
                        ),
                      ),
                    );
                  }
                  else {
                    return const Center(child: Text("Something went wrong"));
                  }
                }
            ),
          )
      ),
    );
  }
}
