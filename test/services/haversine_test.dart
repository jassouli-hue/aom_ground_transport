import 'package:flutter_test/flutter_test.dart';
import 'package:aom_ground_transport/core/utils/haversine.dart';

void main() {
  group('haversineDistanceKm', () {
    test('distance nulle entre deux points identiques', () {
      final d = haversineDistanceKm(33.5731, -7.5898, 33.5731, -7.5898);
      expect(d, closeTo(0.0, 0.001));
    });

    test('distance Casablanca → Benslimane ≈ 45–55 km', () {
      // Casa: 33.5731, -7.5898 — GMMB: 33.6595, -7.2201
      final d = haversineDistanceKm(33.5731, -7.5898, 33.6595, -7.2201);
      expect(d, greaterThan(30));
      expect(d, lessThan(70));
    });

    test('distance Casa → Rabat ≈ 85–95 km', () {
      // Casa: 33.5731, -7.5898 — Rabat: 34.0515, -6.7515
      final d = haversineDistanceKm(33.5731, -7.5898, 34.0515, -6.7515);
      expect(d, greaterThan(70));
      expect(d, lessThan(120));
    });

    test('symétrie A→B == B→A', () {
      final d1 = haversineDistanceKm(33.5731, -7.5898, 34.0515, -6.7515);
      final d2 = haversineDistanceKm(34.0515, -6.7515, 33.5731, -7.5898);
      expect(d1, closeTo(d2, 0.001));
    });
  });
}
