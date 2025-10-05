import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color primaryColor = Color(0xFF0A2744);
const Color accentColor = Color(0xFF42A5F5);

class SubmitProofSheet extends StatefulWidget {
  final Function(String msg, List<XFile> files) onSubmit;

  const SubmitProofSheet({
    super.key,
    required this.onSubmit,
  });

  @override
  State<SubmitProofSheet> createState() => _SubmitProofSheetState();
}

class _SubmitProofSheetState extends State<SubmitProofSheet> {
  final TextEditingController messageController = TextEditingController();
  List<XFile> selectedFiles = [];
  final ImagePicker picker = ImagePicker();

  void _pickFiles(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Pick Images from Gallery", style: TextStyle(color: primaryColor)),
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
              leading: const Icon(Icons.camera_alt),
              title: const Text("Capture Image with Camera", style: TextStyle(color: primaryColor)),
              onTap: () async {
                final file = await picker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  setState(() {
                    selectedFiles.add(file);
                  });
                }
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text("Pick Video from Gallery", style: TextStyle(color: primaryColor)),
              onTap: () async {
                final file = await picker.pickVideo(source: ImageSource.gallery);
                if (file != null) {
                  setState(() {
                    selectedFiles.add(file);
                  });
                }
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text("Record Video with Camera", style: TextStyle(color: primaryColor)),
              onTap: () async {
                final file = await picker.pickVideo(source: ImageSource.camera);
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
  }

  @override
  Widget build(BuildContext context) {
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
                fontSize: 20,
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

            ElevatedButton(
              onPressed: () => _pickFiles(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001F3F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4, // Adds shadow
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text(
                "Add Images/Videos",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),


            if (selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedFiles.map((file) {
                  if (file.path.endsWith(".mp4")) {
                    return const Icon(Icons.videocam, size: 48, color: Colors.blue);
                  } else {
                    return Image.file(
                      File(file.path),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  }
                }).toList(),
              ),
            ],

            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (messageController.text.isNotEmpty || selectedFiles.isNotEmpty) {
                  widget.onSubmit(messageController.text, selectedFiles);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Add a message or files")),
                  );
                }
              },
              child: const Text("Submit", style: TextStyle(color: primaryColor)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
