import 'package:flutter_test/flutter_test.dart';
import 'package:aom_ground_transport/domain/services/distance_service.dart';

void main() {
  final service = DistanceService();

  group('DistanceService.calculate', () {
    test('retourne 0 pour un seul waypoint', () {
      final result = service.calculate([
        const WaypointCoord(name: 'A', lat: 33.5, lng: -7.5),
      ]);
      expect(result.totalKm, 0);
      expect(result.estimatedMinutes, 0);
      expect(result.legs, isEmpty);
    });

    test('calcule correctement pour 2 waypoints', () {
      final result = service.calculate([
        const WaypointCoord(name: 'Casa', lat: 33.5731, lng: -7.5898),
        const WaypointCoord(name: 'Benslimane', lat: 33.6595, lng: -7.2201),
      ]);
      expect(result.totalKm, greaterThan(0));
      expect(result.legs.length, 1);
      expect(result.estimatedMinutes, greaterThan(0));
    });

    test('durée correcte à 80 km/h', () {
      // Distance connue ≈ 50km → ~37min
      final result = service.calculate([
        const WaypointCoord(name: 'A', lat: 33.5731, lng: -7.5898),
        const WaypointCoord(name: 'B', lat: 33.6595, lng: -7.2201),
      ], averageSpeedKmh: 80);
      // durée = distance / 80 * 60
      final expectedMin = (result.totalKm / 80 * 60).round();
      expect(result.estimatedMinutes, expectedMin);
    });

    test('formatDuration affiche correctement', () {
      expect(service.formatDuration(0), '0min');
      expect(service.formatDuration(30), '30min');
      expect(service.formatDuration(60), '1h');
      expect(service.formatDuration(90), '1h30');
      expect(service.formatDuration(125), '2h05');
    });
  });
}
