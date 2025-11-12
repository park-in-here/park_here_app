import 'dart:developer';
import 'package:get/get.dart';
import 'package:park_in_here/screens/home/model/search_loc_model.dart';
import 'package:park_in_here/screens/home/model/search_parking_model.dart';
// import 'package:park_in_here/screens/home.dart';
import 'package:park_in_here/utils/api_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/utils/app_exceptions.dart';
import 'package:park_in_here/utils/constants.dart';

class HomeController extends GetxController {
  ApiBaseHelper helper = ApiBaseHelper();
  GetStorage store = GetStorage();
  bool isLoading = false;
  bool mapisLoading = false;
  SearchLocModel respMOdel = SearchLocModel();
  NearbyModel respMOdel2 = NearbyModel();
  SearchParkingModel respMOdel3 = SearchParkingModel();
  List<LocDatas> locations = [];
  List<LocationData> locations2 = [];
  List<Parkings> parkings = [];
  List<String> addresses = [];
  List<NearbyLoc> nearby = [];
  getLocations(String text) async {
    log('llllll');
    final token =
         await store.read('token');
    isLoading = true;
    update();
    try {
      var response = await helper.get(
        "$base_url/api/findParking/get-cities?search=$text",
        token,
      );
      log(response.toString());
      respMOdel = SearchLocModel.fromJson(response);
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

  getNearby(String lat, String long) async {
    log('rrrrr');
    final token =
        await store.read('token');
    mapisLoading = true;
    update();
    try {
      var response = await helper.get(
        "$base_url/api/findParking/near-by-spots?latitude=$lat&longitude=$long",
        token,
      );
      log(response.toString());
      respMOdel2 = NearbyModel.fromJson(response);
      nearby = respMOdel2.data ?? [];

      update();
      mapisLoading = false;
      update();
      // _checknewVersion();
    } on UniversalException {
      isLoading = false;
      update();
    }
  }


  getParkings(String lat, String long) async {
    log('rrrrr');
    final token =
     await store.read('token');
    mapisLoading = true;
    update();
    try {
      var response = await helper.get(
        "$base_url/api/findParking/search-parking?latitude=$lat&longitude=$long",
        token,
      );
      log(response.toString());
      respMOdel3 = SearchParkingModel.fromJson(response);
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

  @override
  void onInit() async {
    var token = await store.read('token');

    log('----$token');
    super.onInit();
  }
}




