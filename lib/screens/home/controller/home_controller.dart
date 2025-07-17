import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:park_in_here/screens/home/model/search_loc_model.dart';
// import 'package:park_in_here/screens/home.dart';
import 'package:park_in_here/utils/api_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/utils/app_exceptions.dart';
import 'package:park_in_here/utils/constants.dart';

class HomeController extends GetxController {
  ApiBaseHelper helper = ApiBaseHelper();
  GetStorage store = GetStorage();
  bool isLoading = false;
  SearchLocModel respMOdel = SearchLocModel();
  List<LocData> locations = [];
  List<String> addresses = [];

  getLocations(String text) async {
    log('llllll');
    final token = await store.read('token');
    isLoading = true;
    update();
    try {
      var response = await helper.get(
        "$base_url/api/findParking/search-parking?search=$text",
        token,
      );
      log(response.toString());
      respMOdel = SearchLocModel.fromJson(response);
      locations = respMOdel.data ?? [];
      for (var loc in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            loc.location!.latitude!, loc.location!.longitude!);
        Placemark place = placemarks.first;
        String address = '${place.street}, ${place.locality}';
        addresses.add(address);
      }
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

  @override
  void onInit() async {
    var token = await store.read('token');
    log('----$token');
    super.onInit();
  }
}
