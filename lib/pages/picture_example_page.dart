import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcel_delivery_app/pages/delivery_page.dart';
import 'package:parcel_delivery_app/pages/welcome_page.dart';
import 'package:parcel_delivery_app/utils/camera_manager.dart';
import 'dart:typed_data';

class PictureExamplePage extends StatefulWidget {
  const PictureExamplePage({super.key});

  @override
  State<PictureExamplePage> createState() => _PictureExamplePageState();
}

class _PictureExamplePageState extends State<PictureExamplePage> {
  List<Uint8List> capturedImages = [];
  bool isLoading = false;
  static const int maxPhotos = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: Get.width / 4,
        leading: GestureDetector(
          onTap: Get.back,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/back.png", width: 16, height: 24),
              SizedBox(width: 10),
              Text(
                "Back",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => WelcomePage()),
            child: Text(
              "Cancel Order",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Take a picture of the item",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text.rich(
                TextSpan(
                  text: "Please note:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text:
                          "Take picture of your parcel close to a recognisable object such as a chair, pen, etc.",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              if (capturedImages.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/images/example.png",
                            fit: BoxFit.cover,
                          ),
                          Align(
                            alignment: Alignment(-0.9, -0.9),
                            child: Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Example 1",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/images/computer.png",
                            fit: BoxFit.cover,
                          ),
                          Align(
                            alignment: Alignment(-0.9, -0.9),
                            child: Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Example 2",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              if (capturedImages.isNotEmpty)
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: capturedImages.length,
                          itemBuilder: (context, index) {
                            final imageBytes = capturedImages[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 300,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.memory(
                                        imageBytes,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(.9, -.1),
                                    child: IconButton.outlined(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.black,
                                        ),
                                        foregroundColor: WidgetStatePropertyAll(
                                          Color(0xff079A4B),
                                        ),
                                      ),
                                      color: Colors.green,
                                      onPressed: () {
                                        setState(() {
                                          capturedImages.removeAt(index);
                                        });
                                      },
                                      icon: Text(
                                        "X",
                                        style: TextStyle(
                                          color: Color(0xff079A4B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (capturedImages.length < maxPhotos)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                            width: double.maxFinite,
                            height: 55,
                            child: TextButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  final imageBytes =
                                      await CameraManager.openCamera();
                                  if (imageBytes != null &&
                                      imageBytes.isNotEmpty) {
                                    setState(() {
                                      capturedImages.add(imageBytes);
                                    });
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "Failed to capture image. Please try again.",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    "An error occurred while accessing the camera.",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Colors.black),
                                  ),
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  Colors.black,
                                ),
                              ),
                              child: Text("Take another picture"),
                            ),
                          ),
                        ),
                      if (capturedImages.length < maxPhotos) Spacer(),
                    ],
                  ),
                ),

              if (capturedImages.isEmpty)
                Text(
                  "If you do not follow this instruction, your order request will not be valid",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff079A4B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              SafeArea(
                child: SizedBox(
                  width: double.maxFinite,
                  height: 60,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        isLoading ? Colors.grey : Color(0xff079A4B),
                      ),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (capturedImages.isNotEmpty) {
                              Get.to(() => DeliveryPage());
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              final imageBytes =
                                  await CameraManager.openCamera();
                              if (imageBytes != null && imageBytes.isNotEmpty) {
                                setState(() {
                                  capturedImages.add(imageBytes);
                                });
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Failed to capture image. Please try again.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            } catch (e) {
                              Get.snackbar(
                                "Error",
                                "An error occurred while accessing the camera.",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                    child: isLoading
                        ? Row(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              Text("Opening Camera..."),
                            ],
                          )
                        : Row(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (capturedImages.isEmpty)
                                Icon(Icons.photo_camera_outlined, size: 24),
                              Text(
                                capturedImages.isNotEmpty
                                    ? "Submit"
                                    : "Take a picture",
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
