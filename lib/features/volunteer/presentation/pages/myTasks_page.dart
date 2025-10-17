import 'package:dhap_flutter_project/data/model/task_model.dart';
import 'package:dhap_flutter_project/data/model/user_model.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_bloc.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_event.dart';
import 'package:dhap_flutter_project/features/volunteer/bloc/volunteer_state.dart';
import 'package:dhap_flutter_project/features/volunteer/presentation/widgets/MyTaskCard.dart';
import 'package:dhap_flutter_project/features/volunteer/presentation/widgets/StatusFilterSegment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../widgets/videoProofPlayer.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);

class MyTasksPage extends StatefulWidget {
  //final Map<String, dynamic> userDetails;
  final User userDetails;
  const MyTasksPage({super.key, required this.userDetails});

  @override
  State<MyTasksPage> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  String _selectedStatus = "All";

  void showSubmitProofSheet(
    BuildContext context,
    Function(String msg, List<XFile> files) onSubmit, {
    String? initialMessage,
    List<XFile>? initialFiles,
  }) {
    final TextEditingController messageController = TextEditingController(
      text: initialMessage,
    );

    List<XFile> selectedFiles = initialFiles != null
        ? List<XFile>.from(initialFiles)
        : [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Submit Proof",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: messageController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Message",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: primaryColor,
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: primaryColor, width: 1),
                        ),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            return Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.image,
                                    color: primaryColor,
                                  ),
                                  title: const Text(
                                    "Pick Images from Gallery",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                  onTap: () async {
                                    final files = await picker.pickMultiImage();
                                    if (files.isNotEmpty) {
                                      setState(() {
                                        selectedFiles.addAll(files);
                                      });
                                    }
                                    Navigator.pop(ctx);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.camera_alt,
                                    color: primaryColor,
                                  ),
                                  title: const Text(
                                    "Capture Image with Camera",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                  onTap: () async {
                                    final file = await picker.pickImage(
                                      source: ImageSource.camera,
                                    );
                                    if (file != null) {
                                      setState(() {
                                        selectedFiles.add(file);
                                      });
                                    }
                                    Navigator.pop(ctx);
                                  },
                                ),

                                ListTile(
                                  leading: const Icon(
                                    Icons.videocam,
                                    color: primaryColor,
                                  ),
                                  title: const Text(
                                    "Pick Video from Gallery",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                  onTap: () async {
                                    final file = await picker.pickVideo(
                                      source: ImageSource.gallery,
                                    );
                                    if (file != null) {
                                      setState(() {
                                        selectedFiles.add(file);
                                      });
                                    }
                                    Navigator.pop(ctx);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.videocam_outlined,
                                    color: primaryColor,
                                  ),
                                  title: const Text(
                                    "Record Video with Camera",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                  onTap: () async {
                                    final file = await picker.pickVideo(
                                      source: ImageSource.camera,
                                    );
                                    if (file != null) {
                                      setState(() {
                                        selectedFiles.add(file);
                                      });
                                    }
                                    Navigator.pop(ctx);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add_a_photo, color: Colors.white),
                      label: Text(
                        selectedFiles.isEmpty
                            ? "Add Images/Videos"
                            : "Add More (${selectedFiles.length} currently)",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    if (selectedFiles.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedFiles.asMap().entries.map((entry) {
                          final index = entry.key;
                          final file = entry.value;
                          final Widget contentWidget;
                          if (file.path.endsWith(".mp4")) {
                            contentWidget = const Icon(
                              Icons.videocam,
                              size: 80,
                              color: primaryColor,
                            );
                          } else {
                            contentWidget = ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(file.path),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            );
                          }

                          return Stack(
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Center(child: contentWidget),
                              ),
                              Positioned(
                                top: -10,
                                right: -10,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  style: IconButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedFiles.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        //maximumSize: const Size(double.infinity, 100),
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          //vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (messageController.text.isNotEmpty ||
                            selectedFiles.isNotEmpty) {
                          onSubmit(messageController.text, selectedFiles);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please add a message or files to submit proof.",
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text(
                        "Submit Proof",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void showProofViewer(BuildContext context, List<Proof> proofs) {
    if (proofs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No proofs available.")),
      );
      return;
    }

    final allMedia = proofs.expand((p) => p.mediaPaths).toList();
   // final allMessages = proofs.expand((p) => List.filled(p.mediaPaths.length, p.message)).toList();

    showDialog(
      context: context,
      builder: (context) {
        PageController controller = PageController();
       // ValueNotifier<int> indexNotifier = ValueNotifier<int>(0);

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.black38,
          insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
          child: SizedBox(
            width: double.infinity,
            height: 500,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: controller,
                  itemCount: allMedia.length,
                  //onPageChanged: (index) => indexNotifier.value = index,
                  itemBuilder: (context, index) {
                    final path = allMedia[index];
                   // final msg = allMessages[index];

                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: path.endsWith('.mp4')
                                ? VideoProofPlayer(path: path)
                                : Image.file(File(path), fit: BoxFit.contain),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                Positioned(
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
                    onPressed: () {
                      if (controller.page! > 0) {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),

                Positioned(
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 28),
                    onPressed: () {
                      if (controller.page! < allMedia.length - 1) {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Positioned(
                //   bottom: 10,
                //   child: ValueListenableBuilder<int>(
                //     valueListenable: indexNotifier,
                //     builder: (_, i, __) => Text(
                //       "${i + 1}/${allMedia.length}",
                //       style: const TextStyle(color: Colors.white, fontSize: 16),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );

  }



  @override
  void initState() {
    super.initState();
    context.read<volunteerBloc>().add(
      FetchMyTasksEvent(taskIds: widget.userDetails.taskIds),
    );
    print("User Details: ${widget.userDetails.inTask}");
    print("My Tasks: ${widget.userDetails.taskIds}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text("My Tasks", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: StatusFilterSegment(
                    selectedStatus: _selectedStatus,
                    onStatusChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                ),

                Expanded(
                  child: BlocConsumer<volunteerBloc, volunteerState>(
                    listener: (context, state) {
                      if (state is SubmissionSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Proof submitted successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        context.read<volunteerBloc>().add(
                          FetchMyTasksEvent(
                            taskIds: widget.userDetails.taskIds,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is volunteerLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is volunteerSuccess) {
                        final filteredTasks = state.tasks.where((task) {
                          if (_selectedStatus == "All") return true;
                          return task.Status == _selectedStatus;
                        }).toList();

                        print("Filtered Tasks: $filteredTasks");
                        if (filteredTasks.isEmpty) {
                          return const Center(child: Text("No tasks found."));
                        }

                        return ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return MyTaskCard(
                              task: task,
                              onSubmitProof: () async {
                                showSubmitProofSheet(context, (msg, files) {
                                  context.read<volunteerBloc>().add(
                                    SubmitProofEvent(
                                      taskId: task.id,
                                      message: msg,
                                      files: files.map((f) => f.path).toList(),
                                    ),
                                  );
                                });
                              },

                              onUpdateProof: () {
                                debugPrint("Update");
                              },
                              onViewSubmission: () {
                                showProofViewer(context, task.proofs);
                              },
                            );
                          },
                        );
                      } else if (state is volunteerFailure) {
                        return Center(child: Text(state.error));
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
