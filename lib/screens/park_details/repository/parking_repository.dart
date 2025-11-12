import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:park_in_here/screens/park_details/model/park_detail_model.dart';
import 'package:park_in_here/utils/constants.dart';

class ParkRepository {
  final String baseUrl = base_url;
  ParkDetailModel detailModel = ParkDetailModel();
  List<ParkDetail> parkDetails = [];
  GetStorage store = GetStorage();
  Future<List<ParkDetail>> fetchParkDetail() async {
    final  uuid = await store.read('parkId') ?? '';
    final url = Uri.parse('$baseUrl/api/findParking/get-parking-slot/$uuid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      detailModel = ParkDetailModel.fromJson(jsonData);
      parkDetails = detailModel.data ?? [];
      return parkDetails
      ;
    } else {
      throw Exception('Failed to fetch parking details');
    }
  }
}
