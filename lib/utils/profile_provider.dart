import 'package:get/get.dart';

class ProfileProvider extends GetxController {
  static ProfileProvider get instance => Get.find<ProfileProvider>();

  RxString username = "".obs;

  changeString(String newString) {
    username.value = newString;
  }
}
