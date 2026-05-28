import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/known_location_model.dart';
import 'database_provider.dart';

final locationsStreamProvider = StreamProvider<List<KnownLocationModel>>((ref) {
  return ref.watch(knownLocationRepositoryProvider).watchAll();
});

final airportsProvider = FutureProvider<List<KnownLocationModel>>((ref) {
  return ref.watch(knownLocationRepositoryProvider).getAirports();
});
