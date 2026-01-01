import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/dio/dio_client.dart';
import 'package:park_in_here/screens/verify_otp/view/verify_otp.dart';
import 'package:park_in_here/utils/app_exceptions.dart';
import 'package:park_in_here/utils/toast.dart';

class RegisterController extends GetxController {
  final dio = DioClient().dio;
  GetStorage store = GetStorage();

  bool isLoading = false;

  generateOtp(String name, String phone, bool reset) async {
    isLoading = true;
    update();

    try {
      log("📨 Generating OTP for $phone");

      final response = await dio.post(
        "auth/register/generate-otp",
        data: {
          "contact": phone,
          "name": name,
        },
      );

      log("⬅️ RESPONSE: ${response.data}");

      if (response.data["message"] == "OTP generated successfully") {
        showToast(
          message: "OTP sent to mobile number",
          backgroundColor: Colors.green,
        );

        Get.to(() => VerifyOtpScreen(
              isReset: reset,
              name: name,
              phone: phone,
            ));
      } else {
        showToast(
          message: response.data["message"] ?? "Something went wrong",
          backgroundColor: Colors.red,
        );
      }

      isLoading = false;
      update();
    } on DioException catch (e) {
      isLoading = false;
      update();

      log("❌ OTP Error: ${e.message}");

      showToast(
        message: "Failed to generate OTP",
        backgroundColor: Colors.red,
      );

      throw UniversalException(e.message ?? "OTP generation failed");
    }
  }
}
