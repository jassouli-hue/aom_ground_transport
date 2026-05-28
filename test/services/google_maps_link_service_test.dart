import 'package:flutter_test/flutter_test.dart';
import 'package:aom_ground_transport/domain/services/google_maps_link_service.dart';
import 'package:aom_ground_transport/domain/services/distance_service.dart';

void main() {
  final service = GoogleMapsLinkService();

  group('GoogleMapsLinkService', () {
    test('retourne chaîne vide pour waypoints vides', () {
      expect(service.buildDirectionsUrl([]), '');
    });

    test('retourne URL search pour 1 waypoint', () {
      final url = service.buildDirectionsUrl([
        const WaypointCoord(name: 'Casa', lat: 33.5731, lng: -7.5898),
      ]);
      expect(url, contains('maps/search'));
      expect(url, contains('33.5731'));
    });

    test('génère URL directions pour 2+ waypoints', () {
      final url = service.buildDirectionsUrl([
        const WaypointCoord(name: 'Casa', lat: 33.5731, lng: -7.5898),
        const WaypointCoord(name: 'GMMB', lat: 33.6595, lng: -7.2201),
      ]);
      expect(url, contains('maps/dir'));
      expect(url, contains('origin='));
      expect(url, contains('destination='));
      expect(url, contains('travelmode=driving'));
    });

    test('inclut waypoints intermédiaires', () {
      final url = service.buildDirectionsUrl([
        const WaypointCoord(name: 'Base', lat: 33.5731, lng: -7.5898),
        const WaypointCoord(name: 'Salé', lat: 34.0531, lng: -6.7985),
        const WaypointCoord(name: 'GMMB', lat: 33.6595, lng: -7.2201),
      ]);
      expect(url, contains('waypoints='));
    });
  });
}
