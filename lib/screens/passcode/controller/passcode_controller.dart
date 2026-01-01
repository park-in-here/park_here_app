import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/dio/dio_client.dart';
import 'package:park_in_here/screens/success.dart';
import 'package:park_in_here/screens/verify_otp/model/resp_model.dart';
import 'package:park_in_here/utils/toast.dart';
import 'package:park_in_here/utils/app_exceptions.dart';

class PasscodeController extends GetxController {
  final dio = DioClient().dio;
  GetStorage store = GetStorage();

  bool isLoading = false;
  VerifyOtpResponse respModel = VerifyOtpResponse();

  setPasscode(String passcode1, String passcode2) async {
    isLoading = true;
    update();

    try {
      final token = store.read('token');
      log('🔐 Stored token: $token');

      final response = await dio.put(
        "auth/register/reset-passcode",
        data: {
          "passcode": passcode1,
          "confirmPasscode": passcode2,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      log("⬅️ RESPONSE: ${response.data}");

      // Parse response into model
    final message = response.data['message'] as String?;

      if (message == "Passcode reset successfully") {
        showToast(
          message: "Passcode reset successfully",
          backgroundColor: Colors.green,
        );

        Get.to(() => const SuccessScreen());
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

      log("❌ Passcode Reset Error: ${e.message}");

      showToast(
        message: "Failed to reset passcode",
        backgroundColor: Colors.red,
      );

      throw UniversalException(e.message ?? "Error resetting passcode");
    }
  }
}
