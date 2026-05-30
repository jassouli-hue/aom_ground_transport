import '../services/distance_service.dart';

class GoogleMapsLinkService {
  /// Génère un lien Google Maps directions pour la liste de waypoints.
  /// Utilise le format /dir/lat,lng/lat,lng/... qui affiche TOUS les arrêts.
  String buildDirectionsUrl(List<WaypointCoord> waypoints) {
    if (waypoints.isEmpty) return '';

    if (waypoints.length == 1) {
      final w = waypoints.first;
      return 'https://www.google.com/maps/search/?api=1&query=${w.lat},${w.lng}';
    }

    // Format /dir/ : chaque stop séparé par / — Google Maps les affiche tous
    final stops = waypoints
        .where((w) => w.lat != 0 && w.lng != 0)
        .map((w) => '${_fmt(w.lat)},${_fmt(w.lng)}')
        .join('/');

    return 'https://www.google.com/maps/dir/$stops/';
  }

  String _fmt(double v) => v.toStringAsFixed(6);

  /// Génère un lien Google Maps simple vers un point.
  String buildPointUrl(double lat, double lng, String label) {
    return 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$label';
  }
}
