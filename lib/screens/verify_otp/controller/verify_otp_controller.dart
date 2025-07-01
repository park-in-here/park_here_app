import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_in_here/screens/home.dart';
import 'package:park_in_here/screens/verify_otp/model/resp_model.dart';
import 'package:park_in_here/utils/api_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/utils/app_exceptions.dart';
import 'package:park_in_here/utils/constants.dart';
import 'package:park_in_here/utils/toast.dart';

class VerifyOtpController extends GetxController {
  ApiBaseHelper helper = ApiBaseHelper();
  GetStorage store = GetStorage();
  bool isLoading = false;
  VerifyOtpResponse respMOdel = VerifyOtpResponse();

  verifyOtp(String name, String phone, String otp) async {
    isLoading = true;
    update();
    try {
      var response = await helper.post("$base_url/api/auth/login-register",
          {"otp": otp, "contact": phone, "name": name});
      log(response.toString());
      respMOdel = VerifyOtpResponse.fromJson(response);
      log(response.toString());
      if (respMOdel.message == "User logged in successfully") {
        showToast(
            message: "Logged in successfully", backgroundColor: Colors.green);
        Get.to(() => const HomeScreen());
      } else {
        showToast(message: respMOdel.message!, backgroundColor: Colors.red);
      }

      isLoading = false;
      update();
      // _checknewVersion();
    } on UniversalException {
      isLoading = false;
      update();
    }
  }
}
