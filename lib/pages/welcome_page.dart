import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:parcel_delivery_app/pages/size_of_parcel_page.dart';
import 'package:parcel_delivery_app/utils/profile_provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi", style: TextStyle(fontSize: 24)),
                    Obx(
                      () => Text(
                        ProfileProvider.instance.username.value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffCBCBCB),
                          fontSize: 64,
                        ),
                      ),
                    ),

                    Text(
                      "What are you sending today?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          WelcomeContainer(
                            title: "Food Delivery",
                            image: "assets/images/pizza.png",
                          ),
                          WelcomeContainer(
                            title: "Parcel",
                            image: "assets/images/parcel.png",
                          ),
                          WelcomeContainer(
                            title: "Groceries",
                            image: "assets/images/groceries.png",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: Get.height / 6,
            width: Get.width,
            color: Color(0xff59BE75),
            child: Image.asset("assets/images/fence.png", fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({super.key, required this.image, required this.title});
  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Get.to(SizeOfParcelPage(type: title.toLowerCase())),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(height: 130, image, fit: BoxFit.contain),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
