import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:parcel_delivery_app/pages/welcome_page.dart';
import 'package:parcel_delivery_app/utils/profile_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var underlineInputBorder = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xff54B541)),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width / 5,
                  height: 100,
                  child: Image.asset("assets/images/logo_skid.png"),
                ),
                Text("Welcome to", style: TextStyle(fontSize: 32)),
                Text(
                  "Skid",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
                ),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Name"),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: underlineInputBorder,
                          enabledBorder: underlineInputBorder,
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Color(0xffF4F4F4),
                          hintText: "Enter First Name",
                          hintStyle: TextStyle(color: Color(0xffCBCBCB)),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text("Email Address"),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: underlineInputBorder,
                          enabledBorder: underlineInputBorder,
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Color(0xffF4F4F4),
                          hintText: "Provide a valid email address",
                          hintStyle: TextStyle(color: Color(0xffCBCBCB)),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
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
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ProfileProvider.instance.changeString(
                                nameController.value.text,
                              );
                              Get.to(() => WelcomePage());
                            }
                          },
                          child: Text("Continue"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
