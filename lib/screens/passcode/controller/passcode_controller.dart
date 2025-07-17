import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:park_in_here/screens/home.dart';
import 'package:park_in_here/screens/success.dart';
import 'package:park_in_here/screens/verify_otp/model/resp_model.dart';
import 'package:park_in_here/utils/api_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/utils/app_exceptions.dart';
import 'package:park_in_here/utils/constants.dart';
import 'package:park_in_here/utils/toast.dart';

class PasscodeController extends GetxController {
  ApiBaseHelper helper = ApiBaseHelper();
  GetStorage store = GetStorage();
  bool isLoading = false;
  VerifyOtpResponse respMOdel = VerifyOtpResponse();

  setPasscode(String passcode1, String passcode2) async {
    isLoading = true;
    update();
    try {
      log('lllll---${store.read('token')}');
      var response = await helper.put(
          "$base_url/api/auth/register/reset-passcode",
          store.read('token'),
          {"passcode": passcode1, "confirmPasscode": passcode2});
      log(response.toString());
      Get.to(() => const SuccessScreen());
      if (response['message'] == "Passcode reset successfully") {
        showToast(
            message: "Passcode reset successfully",
            backgroundColor: Colors.green);
        Get.to(() => const SuccessScreen());
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
