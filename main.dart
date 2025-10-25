import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcel_delivery_app/pages/login_page.dart';
import 'package:parcel_delivery_app/utils/profile_provider.dart';

void main() {
  Get.put(ProfileProvider());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Parcel Delivery App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
