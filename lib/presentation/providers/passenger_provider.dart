import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/passenger_model.dart';
import 'database_provider.dart';

final passengersStreamProvider = StreamProvider<List<PassengerModel>>((ref) {
  return ref.watch(passengerRepositoryProvider).watchAll();
});
