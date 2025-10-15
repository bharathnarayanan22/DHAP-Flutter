import 'dart:io';
import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_bloc.dart';
import 'package:dhap_flutter_project/features/coordinator/bloc/coordinator_event.dart';

class VerificationCard extends StatefulWidget {
  final int index;
  final Task task;
  final Map<String, VideoPlayerController> controllers;

  const VerificationCard({
    required this.index,
    required this.task,
    required this.controllers,
    super.key,
  });

  @override
  State<VerificationCard> createState() => _VerificationCardState();
}

class _VerificationCardState extends State<VerificationCard> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<CoordinatorBloc>().add(FetchVerificationTasksEvent());
    // });
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaPaths = widget.task.proofs.expand((p) => p.mediaPaths).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (mediaPaths.isNotEmpty)
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: mediaPaths.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, mediaIndex) {
                      final media = mediaPaths[mediaIndex];
                      final isVideo = media.endsWith('.mp4') || media.endsWith('.mov');

                      if (isVideo) {
                        final controller = widget.controllers[media];
                        if (controller == null || !controller.value.isInitialized) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: VideoPlayer(controller),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  iconSize: 50,
                                  color: Colors.white70,
                                  icon: Icon(
                                    controller.value.isPlaying
                                        ? Icons.pause_circle
                                        : Icons.play_circle,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      controller.value.isPlaying
                                          ? controller.pause()
                                          : controller.play();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.file(File(media), fit: BoxFit.cover),
                        );
                      }
                    },
                  ),
                  if (_currentPage > 0)
                    Positioned(
                      left: 8,
                      top: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
                        ),
                      ),
                    ),
                  if (_currentPage < mediaPaths.length - 1)
                    Positioned(
                      right: 8,
                      top: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.task.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(widget.task.description),
                const SizedBox(height: 6),
                Text("Volunteers: ${widget.task.volunteer}"),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    context.read<CoordinatorBloc>().add(MarkTaskCompletedEvent(widget.task.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${widget.task.title} verified!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2744),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Mark as Completed"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
