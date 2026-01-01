import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:park_in_here/dio/dio_client.dart';
import 'package:park_in_here/screens/home/model/search_loc_model.dart';
import 'package:park_in_here/screens/home/model/search_parking_model.dart';
// import 'package:park_in_here/screens/home.dart';
import 'package:park_in_here/utils/api_handler.dart';
import 'package:park_in_here/utils/app_exceptions.dart';
import 'package:park_in_here/utils/toast.dart';

class HomeController extends GetxController {
  ApiBaseHelper helper = ApiBaseHelper();
  bool isLoading = false;
  bool mapisLoading = false;
  SearchLocModel respMOdel = SearchLocModel();
  NearbyModel respMOdel2 = NearbyModel(data: []);
  SearchParkingModel respMOdel3 = SearchParkingModel();
  List<LocDatas> locations = [];
  List<LocationData> locations2 = [];
  List<Parkings> parkings = [];
  List<String> addresses = [];
  List<NearbyLoc> nearby = [];

  final dio = DioClient().dio;

  getLocations(String text) async {
    log('gettig locations');
    isLoading = true;
    update();
    try {
      var response = await dio.get('findParking/get-cities?search=$text');
      log(response.toString());
      respMOdel = SearchLocModel.fromJson(response.data);
      locations = respMOdel.data ?? [];

      update();
      // if (response['message'] == "User logged in successfully") {
      //   await store.write('logged', true);
      //   showToast(
      //       message: "User logged in successfully",
      //       backgroundColor: Colors.green);
      //   Get.to(() => const HomeScreen());
      // } else {
      //   showToast(message: response['message'], backgroundColor: Colors.red);
      // }

      isLoading = false;
      update();
      // _checknewVersion();
    } on UniversalException {
      isLoading = false;
      update();
    }
  }

  Future<void> getNearby(String lat, String long) async {
    mapisLoading = true;
    update();
    log("Getting nearby parking spots");

    try {
      final response = await dio.get(
        'findParking/near-by-spots',
        queryParameters: {
          'latitude': lat,
          'longitude': long,
        },
      );

      log("⬅️ RESPONSE [${response.statusCode}] ${response.requestOptions.path}");
      log("BODY: ${response.data}");

      // Ensure we have a Map
      final data = response.data;

      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        // CASE 1: there is a `data` list → we have nearby spots
        if (data['data'] != null) {
          respMOdel2 = NearbyModel.fromJson(data);
          nearby = respMOdel2.data ?? [];
        } else {
          // CASE 2: 200 but no `data` key → exactly your Postman case
          nearby = [];
        }
      } else {
        // Non-200 or unexpected shape
        nearby = [];
        showToast(
          message: "No nearby parking slots found",
          backgroundColor: Colors.orange,
        );
      }
    } on DioException catch (e) {
      log("DioException: ${e.message}");
      log("STATUS: ${e.response?.statusCode}");
      log("DATA: ${e.response?.data}");

      nearby = [];

      String message = "No nearby parking slots found";
      final errData = e.response?.data;

      if (errData is Map<String, dynamic>) {
        message = errData['message']?.toString() ?? message;
      }
    } finally {
      mapisLoading = false;
      update();
    }
  }

  getParkings(String lat, String long) async {
    mapisLoading = true;
    update();
    try {
      var response = await dio
          .get('findParking/search-parking?latitude=$lat&longitude=$long');
      log(response.toString());
      respMOdel3 = SearchParkingModel.fromJson(response.data);
      parkings = respMOdel3.data ?? [];

      update();
      mapisLoading = false;
      update();
      // _checknewVersion();
    } on UniversalException {
      isLoading = false;
      update();
    }
  }
}
