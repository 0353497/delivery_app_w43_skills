import Flutter
import UIKit

@main
@objc
class AppDelegate: FlutterAppDelegate, UIImagePickerControllerDelegate,
  UINavigationControllerDelegate
{

  private var cameraResult: FlutterResult?
  private let channelName = "com.example.delivery/camera"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)

    guard let controller = window?.rootViewController as? FlutterViewController else {

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    let channel = FlutterMethodChannel(
      name: channelName, binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler {
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else { return }
      switch call.method {
      case "openCamera":
        self.openCamera(from: controller, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func openCamera(from presenter: UIViewController, result: @escaping FlutterResult) {

    guard cameraResult == nil else {
      result(FlutterError(code: "busy", message: "Camera is already in use", details: nil))
      return
    }
    cameraResult = result

    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {

      finishWithBytes([])
      return
    }

    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.allowsEditing = false
    picker.delegate = self

    DispatchQueue.main.async {
      presenter.present(picker, animated: true, completion: nil)
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true) { [weak self] in

      self?.finishWithBytes([])
    }
  }

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    let image = (info[.originalImage] as? UIImage)
    picker.dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      if let image = image,
        let jpegData = image.jpegData(compressionQuality: 0.9)
      {

        let bytes = [UInt8](jpegData)
        self.finishWithBytes(bytes)
      } else {

        self.finishWithBytes([])
      }
    }
  }

  private func finishWithBytes(_ bytes: [UInt8]) {
    guard let result = cameraResult else { return }
    cameraResult = nil
    result(bytes)
  }
}
