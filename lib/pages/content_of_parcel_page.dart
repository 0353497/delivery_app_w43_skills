import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcel_delivery_app/pages/picture_example_page.dart';
import 'package:parcel_delivery_app/pages/welcome_page.dart';

class ContentOfParcelPage extends StatefulWidget {
  const ContentOfParcelPage({super.key, required this.type});
  final String type;
  @override
  State<ContentOfParcelPage> createState() => _ContentOfParcelPageState();
}

class _ContentOfParcelPageState extends State<ContentOfParcelPage> {
  var underlineInputBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Color(0xff54B541)),
  );
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(
                      "What is in the packages",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      spacing: 16,
                      children: [
                        Text("What is in the package"),
                        TextFormField(
                          decoration: InputDecoration(
                            border: underlineInputBorder,
                            enabledBorder: underlineInputBorder,
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            filled: true,
                            fillColor: Color(0xffF4F4F4),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 16,
                      children: [
                        Text("What is in the package"),
                        TextFormField(
                          maxLines: 12,
                          decoration: InputDecoration(
                            border: underlineInputBorder,
                            enabledBorder: underlineInputBorder,
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            hintText: "Is it Breakable?",
                            hintStyle: TextStyle(color: Color(0xffCBCBCB)),
                            filled: true,
                            fillColor: Color(0xffF4F4F4),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                        Color(0xff079A4B),
                      ),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () async {
                      Get.to(() => PictureExamplePage());
                    },
                    child: Text("Next"),
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
