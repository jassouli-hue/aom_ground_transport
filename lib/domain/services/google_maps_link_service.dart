import '../services/distance_service.dart';

class GoogleMapsLinkService {
  /// Génère un lien Google Maps directions pour la liste de waypoints.
  /// Android & iOS compatibles via intent URL.
  String buildDirectionsUrl(List<WaypointCoord> waypoints) {
    if (waypoints.isEmpty) return '';

    if (waypoints.length == 1) {
      final w = waypoints.first;
      return 'https://www.google.com/maps/search/?api=1&query=${w.lat},${w.lng}';
    }

    final origin = waypoints.first;
    final destination = waypoints.last;
    final waypts = waypoints.length > 2
        ? waypoints.sublist(1, waypoints.length - 1)
        : <WaypointCoord>[];

    final buffer = StringBuffer(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${origin.lat},${origin.lng}'
      '&destination=${destination.lat},${destination.lng}',
    );

    if (waypts.isNotEmpty) {
      final wayptsStr = waypts.map((w) => '${w.lat},${w.lng}').join('|');
      buffer.write('&waypoints=$wayptsStr');
    }

    buffer.write('&travelmode=driving');
    return buffer.toString();
  }

  /// Génère un lien Google Maps simple vers un point.
  String buildPointUrl(double lat, double lng, String label) {
    return 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$label';
  }
}
