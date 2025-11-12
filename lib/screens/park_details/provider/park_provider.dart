import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:park_in_here/screens/park_details/model/park_detail_model.dart';
import 'package:park_in_here/screens/park_details/repository/parking_repository.dart';



final parkingRepoProvider = Provider<ParkRepository>((ref) => ParkRepository());
final parkingProvider = FutureProvider<List<ParkDetail>>((ref) async {

  final repo = ref.read(parkingRepoProvider);
  return repo.fetchParkDetail();
});