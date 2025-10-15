import 'dart:io';
import 'package:dhap_flutter_project/features/coordinator/presentation/widgets/VerificationCards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_event.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_state.dart';

class VerifyTasksPage extends StatefulWidget {
  const VerifyTasksPage({super.key});


  @override
  State<VerifyTasksPage> createState() => _VerifyTasksPageState();
}

class _VerifyTasksPageState extends State<VerifyTasksPage> {
  final Map<String, VideoPlayerController> _controllers = {};
  final Map<int, PageController> _pageControllers = {};
  final Map<int, int> _currentPages = {};
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    context.read<CoordinatorBloc>().add(FetchVerificationTasksEvent());
    _initializationFuture = Future.value();
  }

  Future<void> _initializeControllers(List tasks) async {
    for (final task in tasks) {
      for (final proof in task.proofs) {
        for (final path in proof.mediaPaths) {
          if ((path.endsWith('.mp4') || path.endsWith('.mov')) &&
              !_controllers.containsKey(path)) {
            final controller = VideoPlayerController.file(File(path));
            await controller.initialize();
            controller.setLooping(true);
            _controllers[path] = controller;
          }
        }
      }
    }

    for (int i = 0; i < tasks.length; i++) {
      _pageControllers[i] = PageController();
      _currentPages[i] = 0;
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final controller in _pageControllers.values) {
      controller.dispose();
    }
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
            Icon(Icons.verified, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text("Verify Tasks", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF0A2744),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CoordinatorBloc, CoordinatorState>(
        listener: (context, state) {

          if (state is CoordinatorSuccess) {
            setState(() {
              _initializationFuture = _initializeControllers(state.tasks);
            });
          }
        },
        builder: (context, state) {
          if (state is CoordinatorLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CoordinatorSuccess) {
            final tasks = state.tasks;

            if (tasks.isEmpty) {
              return const Center(child: Text('No Pending Verification'));
            }

            return FutureBuilder(
              future: _initializationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return VerificationCard(index: index, task: tasks[index], controllers: _controllers);
                  },
                );
              },
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}



