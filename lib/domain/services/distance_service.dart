import '../../core/utils/haversine.dart';

class WaypointCoord {
  final String name;
  final double lat;
  final double lng;

  const WaypointCoord({required this.name, required this.lat, required this.lng});
}

class DistanceResult {
  final double totalKm;
  final int estimatedMinutes;
  final List<LegDistance> legs;

  const DistanceResult({
    required this.totalKm,
    required this.estimatedMinutes,
    required this.legs,
  });
}

class LegDistance {
  final String from;
  final String to;
  final double distanceKm;
  final int durationMin;

  const LegDistance({
    required this.from,
    required this.to,
    required this.distanceKm,
    required this.durationMin,
  });
}

class DistanceService {
  /// Calcule la distance et durée pour une liste ordonnée de waypoints.
  DistanceResult calculate(
    List<WaypointCoord> waypoints, {
    double averageSpeedKmh = 80.0,
  }) {
    if (waypoints.length < 2) {
      return const DistanceResult(totalKm: 0, estimatedMinutes: 0, legs: []);
    }

    final legs = <LegDistance>[];
    double total = 0;

    for (int i = 0; i < waypoints.length - 1; i++) {
      final from = waypoints[i];
      final to = waypoints[i + 1];
      final dist = haversineDistanceKm(from.lat, from.lng, to.lat, to.lng);
      final dur = (dist / averageSpeedKmh * 60).round();
      legs.add(LegDistance(
        from: from.name,
        to: to.name,
        distanceKm: dist,
        durationMin: dur,
      ));
      total += dist;
    }

    final totalMin = (total / averageSpeedKmh * 60).round();
    return DistanceResult(
      totalKm: double.parse(total.toStringAsFixed(1)),
      estimatedMinutes: totalMin,
      legs: legs,
    );
  }

  String formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}min';
    if (m == 0) return '${h}h';
    return '${h}h${m.toString().padLeft(2, '0')}';
  }
}
