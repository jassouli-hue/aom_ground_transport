import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/driver_model.dart';
import 'database_provider.dart';

final driversStreamProvider = StreamProvider<List<DriverModel>>((ref) {
  return ref.watch(driverRepositoryProvider).watchAll();
});

final driverByIdProvider =
    FutureProvider.family<DriverModel?, int>((ref, id) async {
  return ref.watch(driverRepositoryProvider).getById(id);
});
