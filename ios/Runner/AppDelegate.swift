import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


// import UIKit
// import Flutter
//
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//
//     let controller = window?.rootViewController as! FlutterViewController
//     let channel = FlutterMethodChannel(name: "com.example.media", binaryMessenger: controller.binaryMessenger)
//
//     channel.setMethodCallHandler { call, result in
//       switch call.method {
//       case "captureImage":
//         result("/var/mobile/Media/DCIM/100APPLE/IMG_0001.JPG")
//       case "recordVideo":
//         result("/var/mobile/Media/DCIM/100APPLE/VID_0001.MP4")
//       case "pickFromGallery":
//         result("/var/mobile/Media/DCIM/100APPLE/IMG_0002.JPG")
//       case "recordAudio":
//         result("/var/mobile/Containers/Data/audio_001.m4a")
//       default:
//         result(FlutterMethodNotImplemented)
//       }
//     }
//
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
