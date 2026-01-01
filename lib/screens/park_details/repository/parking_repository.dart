import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:park_in_here/dio/dio_client.dart';
import 'package:park_in_here/screens/park_details/model/park_detail_model.dart';

class ParkRepository {
  ParkDetailModel detailModel = ParkDetailModel();
  List<ParkDetail> parkDetails = [];
  final dio = DioClient().dio;
  GetStorage store = GetStorage();
  Future<List<ParkDetail>> fetchParkDetail() async {
    final uuid = await store.read('parkId') ?? '';

    final response = await dio.get('findParking/get-parking-slot/$uuid');
    log(response.toString());
    // if (response.statusCode == 200) {
    final jsonData = response;
    detailModel = ParkDetailModel.fromJson(jsonData.data!);
    parkDetails = detailModel.data ?? [];
    return parkDetails;
  }
}
