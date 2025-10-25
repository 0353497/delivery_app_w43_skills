import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CameraManager {
  static Future<Uint8List?> openCamera() async {
    try {
      final channel = MethodChannel("com.example.delivery/camera");
      final result = await channel.invokeMethod("openCamera");
      if (result != null && result is List<dynamic>) {
        // Convert the list to Uint8List
        return Uint8List.fromList(result.cast<int>());
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
