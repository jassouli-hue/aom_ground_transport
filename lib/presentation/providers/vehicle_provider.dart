import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/vehicle_model.dart';
import 'database_provider.dart';

final vehiclesStreamProvider = StreamProvider<List<VehicleModel>>((ref) {
  return ref.watch(vehicleRepositoryProvider).watchAll();
});
