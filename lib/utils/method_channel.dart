import 'package:flutter/services.dart';

class MediaChannel {
  static const _channel = MethodChannel('com.example.media');

  static Future<String?> captureImage() async {
    return await _channel.invokeMethod<String>('captureImage');
  }

  static Future<String?> recordVideo() async {
    return await _channel.invokeMethod<String>('recordVideo');
  }

  static Future<String?> pickFromGallery() async {
    return await _channel.invokeMethod<String>('pickFromGallery');
  }
}
