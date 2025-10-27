// import Flutter
// import UIKit
//
// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import UIKit
import Flutter
import MobileCoreServices
import PhotosUI

@main
@objc class AppDelegate: FlutterAppDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

  var flutterResult: FlutterResult?
  var imagePicker: UIImagePickerController?

  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    let mediaChannel = FlutterMethodChannel(name: "com.example.media", binaryMessenger: controller.binaryMessenger)

    mediaChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      self.flutterResult = result

      switch call.method {
      case "pickFromGallery":
        self.pickFromGallery()
      case "captureImage":
        self.captureImage()
      case "recordVideo":
        self.recordVideo()
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Pick Image from Gallery
  func pickFromGallery() {
    imagePicker = UIImagePickerController()
    imagePicker?.delegate = self
    imagePicker?.sourceType = .photoLibrary
    imagePicker?.mediaTypes = [kUTTypeImage as String]
    window?.rootViewController?.present(imagePicker!, animated: true, completion: nil)
  }

  // MARK: - Capture Image using Camera
  func captureImage() {
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      flutterResult?(FlutterError(code: "NO_CAMERA", message: "Camera not available", details: nil))
      return
    }
    imagePicker = UIImagePickerController()
    imagePicker?.delegate = self
    imagePicker?.sourceType = .camera
    imagePicker?.mediaTypes = [kUTTypeImage as String]
    window?.rootViewController?.present(imagePicker!, animated: true, completion: nil)
  }

  // MARK: - Record Video using Camera
  func recordVideo() {
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      flutterResult?(FlutterError(code: "NO_CAMERA", message: "Camera not available", details: nil))
      return
    }
    imagePicker = UIImagePickerController()
    imagePicker?.delegate = self
    imagePicker?.sourceType = .camera
    imagePicker?.mediaTypes = [kUTTypeMovie as String]
    imagePicker?.videoQuality = .typeMedium
    window?.rootViewController?.present(imagePicker!, animated: true, completion: nil)
  }

  // MARK: - Image Picker Delegate
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

    var path: String?

    if let mediaURL = info[.mediaURL] as? URL {
      path = mediaURL.path
    } else if let image = info[.originalImage] as? UIImage {
      // Save image to temporary directory
      if let data = image.jpegData(compressionQuality: 0.9) {
        let tempDir = NSTemporaryDirectory()
        let filePath = "\(tempDir)/\(UUID().uuidString).jpg"
        let url = URL(fileURLWithPath: filePath)
        try? data.write(to: url)
        path = url.path
      }
    }

    picker.dismiss(animated: true) {
      if let result = self.flutterResult {
        result(path)
      }
      self.flutterResult = nil
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true) {
      self.flutterResult?(nil)
      self.flutterResult = nil
    }
  }
}

