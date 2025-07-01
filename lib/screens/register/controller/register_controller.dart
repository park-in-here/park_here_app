import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_in_here/screens/verify_otp/view/verify_otp.dart';
import 'package:park_in_here/utils/api_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/utils/app_exceptions.dart';
import 'package:park_in_here/utils/constants.dart';
import 'package:park_in_here/utils/toast.dart';

class RegisterController extends GetxController {
  ApiBaseHelper helper = ApiBaseHelper();
  GetStorage store = GetStorage();
  bool isLoading = false;

  generateOtp(String name, String phone, bool reset) async {
    isLoading = true;
    update();
    try {
      log('ggggg');
      var response = await helper.post(
          "$base_url/api/auth/generate-otp", {"contact": phone, "name": name});
      log(response.toString());
      if (response['message'] == "OTP generated successfully") {
        showToast(
            message: "OTP sent to mobile number",
            backgroundColor: Colors.green);
        Get.to(() => VerifyOtpScreen(
              isReset: reset,
              name: name,
              phone: phone,
            ));
      } else {
        showToast(message: response['message'], backgroundColor: Colors.red);
      }
      isLoading = false;
      update();
    } on UniversalException {
      isLoading = false;
      update();
    }
  }
}
