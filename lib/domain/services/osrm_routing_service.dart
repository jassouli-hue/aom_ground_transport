import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/haversine.dart';
import 'distance_service.dart';

/// Service de calcul de distances routières via OSRM (gratuit, sans clé API).
/// Fallback automatique sur Haversine si le réseau est indisponible.
class OsrmRoutingService {
  static const _baseUrl = 'https://router.project-osrm.org/route/v1/driving';
  static const _timeout = Duration(seconds: 8);
  static const double _roadFactor = 1.25; // facteur haversine → route

  /// Calcule distances et durées réelles pour une liste de waypoints.
  Future<DistanceResult> calculate(
    List<WaypointCoord> waypoints, {
    double averageSpeedKmh = 80.0,
  }) async {
    if (waypoints.length < 2) {
      return const DistanceResult(totalKm: 0, estimatedMinutes: 0, legs: []);
    }

    try {
      return await _osrmRoute(waypoints);
    } catch (_) {
      // Réseau indisponible → Haversine avec facteur de route
      return _haversineFallback(waypoints, averageSpeedKmh);
    }
  }

  Future<DistanceResult> _osrmRoute(List<WaypointCoord> waypoints) async {
    // Build coordinates string: "lng,lat;lng,lat;..."
    final coords = waypoints.map((w) => '${w.lng},${w.lat}').join(';');
    final uri = Uri.parse('$_baseUrl/$coords?overview=false&steps=false&annotations=false');

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode != 200) throw Exception('OSRM HTTP ${response.statusCode}');

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['code'] != 'Ok') throw Exception('OSRM code: ${data['code']}');

    final routes = data['routes'] as List;
    if (routes.isEmpty) throw Exception('OSRM: no route found');

    final route = routes.first as Map<String, dynamic>;
    final legs = (route['legs'] as List).cast<Map<String, dynamic>>();

    final legResults = <LegDistance>[];
    double totalKm = 0;
    int totalMin = 0;

    for (int i = 0; i < legs.length; i++) {
      final leg = legs[i];
      final distKm = (leg['distance'] as num).toDouble() / 1000.0;
      final durMin = ((leg['duration'] as num).toDouble() / 60).round();
      totalKm += distKm;
      totalMin += durMin;
      legResults.add(LegDistance(
        from: waypoints[i].name,
        to: waypoints[i + 1].name,
        distanceKm: double.parse(distKm.toStringAsFixed(1)),
        durationMin: durMin,
      ));
    }

    return DistanceResult(
      totalKm: double.parse(totalKm.toStringAsFixed(1)),
      estimatedMinutes: totalMin,
      legs: legResults,
    );
  }

  DistanceResult _haversineFallback(
      List<WaypointCoord> waypoints, double speedKmh) {
    final legs = <LegDistance>[];
    double total = 0;

    for (int i = 0; i < waypoints.length - 1; i++) {
      final from = waypoints[i];
      final to = waypoints[i + 1];
      final straight = haversineDistanceKm(from.lat, from.lng, to.lat, to.lng);
      final road = straight * _roadFactor; // estimation route
      final dur = (road / speedKmh * 60).round();
      legs.add(LegDistance(
        from: from.name,
        to: to.name,
        distanceKm: double.parse(road.toStringAsFixed(1)),
        durationMin: dur,
      ));
      total += road;
    }

    final totalMin = (total / speedKmh * 60).round();
    return DistanceResult(
      totalKm: double.parse(total.toStringAsFixed(1)),
      estimatedMinutes: totalMin,
      legs: legs,
    );
  }
}
