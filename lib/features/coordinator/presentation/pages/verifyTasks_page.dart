import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VerifyTasksPage extends StatefulWidget {
  const VerifyTasksPage({super.key});

  @override
  State<VerifyTasksPage> createState() => _VerifyTasksPageState();
}

class _VerifyTasksPageState extends State<VerifyTasksPage> {
  // Mock data
  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Distribute Food Packets',
      'description': 'Distribute food packets to needy families in the city.',
      'volunteers': 5,
      'images': [
        'https://picsum.photos/400/200?image=1',
        'https://picsum.photos/400/200?image=2',
      ],
      'videos': [
        'https://drive.google.com/file/d/1KvJsRw5IP5FdxMPLhaTWLQ66qnKfXH-H/view?usp=sharing',
      ],
    },
    {
      'title': 'Clean Up Park',
      'description': 'Volunteer to clean up the local park this weekend.',
      'volunteers': 3,
      'images': ['https://picsum.photos/400/200?image=10'],
      'videos': [],
    },
  ];

  final Map<int, Map<int, VideoPlayerController>> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeVideos();
  }

  Future<void> _initializeVideos() async {
    for (int i = 0; i < tasks.length; i++) {
      final videos = (tasks[i]['videos'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      _videoControllers[i] = {};
      for (int j = 0; j < videos.length; j++) {
        final controller = VideoPlayerController.networkUrl(
          Uri.parse('https://drive.google.com/file/d/1KvJsRw5IP5FdxMPLhaTWLQ66qnKfXH-H/view?usp=sharing')
        );
        debugPrint('${videos[j]}');
        await controller.initialize();
        controller.setLooping(true);
        _videoControllers[i]![j] = controller;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (var taskControllers in _videoControllers.values) {
      for (var controller in taskControllers.values) {
        controller.dispose();
      }
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
            Icon(Icons.assignment_turned_in, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text("Verify Tasks", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF0A2744),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          final mediaItems = [
            ...(task['images'] as List<dynamic>).map((e) => e.toString()),
            ...(task['videos'] as List<dynamic>).map((e) => e.toString()),
          ];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: mediaItems.length,
                    itemBuilder: (context, mediaIndex) {
                      final media = mediaItems[mediaIndex];
                      final isVideo = (task['videos'] as List<dynamic>)
                          .map((e) => e.toString())
                          .contains(media);

                      if (isVideo) {
                        final videoIdx = task['videos'].indexOf(media);
                        final controller = _videoControllers[index]?[videoIdx];

                        if (controller == null ||
                            !controller.value.isInitialized) {
                          return Center(child: CircularProgressIndicator());
                        }

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.value.isPlaying
                                  ? controller.pause()
                                  : controller.play();
                            });
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: VideoPlayer(controller),
                          ),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(media, fit: BoxFit.cover),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                  
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task['description'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Volunteers: ${task['volunteers']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0A2744),
                              foregroundColor: Colors.white,
                            ),
                  
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${task['title']} marked as completed!",
                                  ),
                                ),
                              );
                            },
                            child: const Text("Mark as Completed"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
