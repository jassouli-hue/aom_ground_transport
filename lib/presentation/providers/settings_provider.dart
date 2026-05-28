import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

final averageSpeedProvider = FutureProvider<double>((ref) {
  return ref.watch(settingsServiceProvider).getAverageSpeedKmh();
});

final pinEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(settingsServiceProvider).isPinEnabled();
});

final baseLocationIdProvider = FutureProvider<int?>((ref) {
  return ref.watch(settingsServiceProvider).getBaseLocationId();
});

final companyNameProvider = FutureProvider<String>((ref) {
  return ref.watch(settingsServiceProvider).getCompanyName();
});
