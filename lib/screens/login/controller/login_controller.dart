import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/dio/dio_client.dart';
import 'package:park_in_here/screens/home/view/home.dart';
import 'package:park_in_here/screens/verify_otp/model/resp_model.dart';
import 'package:park_in_here/utils/toast.dart';
import 'package:park_in_here/utils/app_exceptions.dart';

class LoginController extends GetxController {
  final dio = DioClient().dio;
  GetStorage store = GetStorage();

  bool isLoading = false;
  VerifyOtpResponse respModel = VerifyOtpResponse();

  login(String mobile, String code) async {
    isLoading = true;
    update();
    try {
      log("📲 Logging in...");
      final response = await dio.post(
        "auth/login",
        data: {
          "contact": mobile,
          "passcode": code,
        },
      );

      log("⬅️ RESPONSE: ${response.data}");

      // Convert response JSON to model
      respModel = VerifyOtpResponse.fromJson(response.data);

      // Save token and username
      await store.write('token', respModel.token);
      await store.write('refreshToken', respModel.refreshToken);
      await store.write('name', respModel.user?.name ?? "");

      if (response.data['message'] == "User logged in successfully") {
        await store.write('logged', true);

        showToast(
          message: "User logged in successfully",
          backgroundColor: Colors.green,
        );

        Get.offAll(() => const HomeScreen());
      } else {
        showToast(
          message: response.data['message'],
          backgroundColor: Colors.red,
        );
      }

      isLoading = false;
      update();
      
    } on DioException catch (e) {
      isLoading = false;
      update();

      log("❌ Login Error: ${e.message}");

      showToast(
        message: "Something went wrong. Try again.",
        backgroundColor: Colors.red,
      );

      throw UniversalException(e.message ?? "Login failed");
    }
  }

  @override
  void onInit() async {
    var token = store.read('token');
    log('Stored Token: $token');
    super.onInit();
  }
}
