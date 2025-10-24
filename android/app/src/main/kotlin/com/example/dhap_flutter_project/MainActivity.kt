//package com.example.dhap_flutter_project
//
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity : FlutterActivity()

package com.example.dhap_flutter_project

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.media"
    private var pendingResult: MethodChannel.Result? = null

    private val REQUEST_IMAGE_CAPTURE = 1
    private val REQUEST_VIDEO_CAPTURE = 2
    private val REQUEST_PICK_IMAGE = 3

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            pendingResult = result
            when(call.method) {
                "captureImage" -> openCameraForImage()
                "recordVideo" -> openCameraForVideo()
                "pickFromGallery" -> pickMediaFromGallery()
                else -> result.notImplemented()
            }
        }
    }

    private fun openCameraForImage() {
        val takePictureIntent = Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE)
        startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE)
    }

    private fun openCameraForVideo() {
        val takeVideoIntent = Intent(android.provider.MediaStore.ACTION_VIDEO_CAPTURE)
        startActivityForResult(takeVideoIntent, REQUEST_VIDEO_CAPTURE)
    }

    private fun pickMediaFromGallery() {
        val pickIntent = Intent(Intent.ACTION_PICK)
        pickIntent.type = "*/*"
        pickIntent.putExtra(Intent.EXTRA_MIME_TYPES, true)
        startActivityForResult(pickIntent, REQUEST_PICK_IMAGE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (resultCode != Activity.RESULT_OK) {
            pendingResult?.success(null)
            return
        }

        when(requestCode) {
            REQUEST_IMAGE_CAPTURE -> {
                val bitmap = data?.extras?.get("data") as? Bitmap
                val file = File(cacheDir, "captured_image_${System.currentTimeMillis()}.jpg")
                bitmap?.compress(Bitmap.CompressFormat.JPEG, 100, file.outputStream())
                pendingResult?.success(file.absolutePath)
            }

            REQUEST_VIDEO_CAPTURE -> {
                val videoUri: Uri? = data?.data
                val videoFile = videoUri?.let { uri ->
                    val inputStream = contentResolver.openInputStream(uri)
                    val tempFile = File(cacheDir, "captured_video_${System.currentTimeMillis()}.mp4")
                    inputStream?.use { input ->
                        tempFile.outputStream().use { output ->
                            input.copyTo(output)
                        }
                    }
                    tempFile
                }
                pendingResult?.success(videoFile?.absolutePath)
            }

            REQUEST_PICK_IMAGE -> {
                val imageUri: Uri? = data?.data
                val imageFile = imageUri?.let { uri ->
                    val inputStream = contentResolver.openInputStream(uri)
                    val tempFile = File(cacheDir, "picked_image_${System.currentTimeMillis()}.jpg")
                    inputStream?.use { input ->
                        tempFile.outputStream().use { output ->
                            input.copyTo(output)
                        }
                    }
                    tempFile
                }
                pendingResult?.success(imageFile?.absolutePath)
            }
        }
    }
}
