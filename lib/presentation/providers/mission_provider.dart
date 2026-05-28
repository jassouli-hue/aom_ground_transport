import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/mission_model.dart';
import 'database_provider.dart';

final missionsStreamProvider = StreamProvider<List<MissionModel>>((ref) {
  return ref.watch(missionRepositoryProvider).watchAll();
});

final missionByIdProvider =
    FutureProvider.family<MissionModel?, int>((ref, id) async {
  return ref.watch(missionRepositoryProvider).getById(id);
});

final missionCountsProvider = FutureProvider<Map<String, int>>((ref) {
  return ref.watch(missionRepositoryProvider).getCounts();
});
