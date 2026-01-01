import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/dio/dio_client.dart';
import 'package:park_in_here/screens/passcode/view/passcode.dart';
import 'package:park_in_here/screens/verify_otp/model/resp_model.dart';
import 'package:park_in_here/utils/toast.dart';
import 'package:park_in_here/utils/app_exceptions.dart';

class VerifyOtpController extends GetxController {
  final dio = DioClient().dio;
  GetStorage store = GetStorage();

  bool isLoading = false;
  VerifyOtpResponse respModel = VerifyOtpResponse();

  verifyOtp(String name, String phone, String otp) async {
    isLoading = true;
    update();

    try {
      log("📨 Verifying OTP for $phone ...");

      final response = await dio.post(
        "auth/register/verify-otp",
        data: {
          "otp": otp,
          "contact": phone,
          "name": name,
        },
      );

      log("⬅️ RESPONSE: ${response.data}");

      respModel = VerifyOtpResponse.fromJson(response.data);
      update();

      if (respModel.message == "User registered successfully") {
        // Save token and name
        await store.write('token', respModel.token);
        await store.write('name', respModel.user?.name ?? "");

        log("💾 Saved token: ${store.read('token')}");

        showToast(
          message: "User registered successfully",
          backgroundColor: Colors.green,
        );

        Get.to(() => const PassCodeScreen());
      } else {
        showToast(
          message: respModel.message ?? "Something went wrong",
          backgroundColor: Colors.red,
        );
      }

      isLoading = false;
      update();
    } on DioException catch (e) {
      isLoading = false;
      update();

      log("❌ OTP Verification Error: ${e.message}");

      showToast(
        message: "${e.message}",
        backgroundColor: Colors.red,
      );

      throw UniversalException(e.message ?? "OTP verification failed");
    }
  }
}
