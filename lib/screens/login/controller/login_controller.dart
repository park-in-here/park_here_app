import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:park_in_here/screens/home.dart';
import 'package:park_in_here/screens/home/view/home.dart';
import 'package:park_in_here/screens/verify_otp/model/resp_model.dart';
import 'package:park_in_here/utils/api_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/utils/app_exceptions.dart';
import 'package:park_in_here/utils/constants.dart';
import 'package:park_in_here/utils/toast.dart';

class LoginController extends GetxController {
  ApiBaseHelper helper = ApiBaseHelper();
  GetStorage store = GetStorage();
  bool isLoading = false;
  VerifyOtpResponse respMOdel = VerifyOtpResponse();

  login(String mobile, String code) async {
     final token = await store.read('token');
    isLoading = true;
    update();
    try {
      log(token);
      var response = await helper.postV2("$base_url/api/auth/login", token,
          {"contact": mobile, "passcode": code});
      log(response.toString());
       respMOdel = VerifyOtpResponse.fromJson(response);
 await store.write('token', respMOdel.token);
  await store.write('name', respMOdel.user!.name);
      if (response['message'] == "User logged in successfully") {
        await store.write('logged', true);
        showToast(
            message: "User logged in successfully",
            backgroundColor: Colors.green);
        Get.to(() => const HomeScreen());
      } else {
        showToast(message: response['message'], backgroundColor: Colors.red);
      }

      isLoading = false;
      update();
      // _checknewVersion();
    } on UniversalException {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() async {
    var token = await store.read('token');
    log('----$token');
    super.onInit();
  }
}
