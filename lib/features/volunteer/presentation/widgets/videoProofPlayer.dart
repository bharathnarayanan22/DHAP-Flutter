import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';


class VideoProofPlayer extends StatefulWidget {
  final String path;
  const VideoProofPlayer({required this.path});

  @override
  State<VideoProofPlayer> createState() => _VideoProofPlayerState();
}

class _VideoProofPlayerState extends State<VideoProofPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : const CircularProgressIndicator(color: Colors.white),
    );
  }
}
