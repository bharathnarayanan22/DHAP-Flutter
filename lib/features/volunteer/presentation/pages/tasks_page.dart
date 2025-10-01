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
  const tasksPage({super.key});
  @override
  State<tasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<tasksPage> {
  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_turned_in, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              "Available Tasks",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<volunteerBloc, volunteerState>(
        builder: (context, state) {
          if (state is volunteerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is volunteerSuccess) {
            final tasks = state.tasks;
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
      )
    );
  }
}
