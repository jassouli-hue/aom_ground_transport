class KnownLocationModel {
  final int id;
  final String name;
  final String shortCode;
  final String city;
  final double latitude;
  final double longitude;
  final bool isAirport;
  final bool isActive;

  const KnownLocationModel({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.isAirport,
    required this.isActive,
  });

  String get displayName => isAirport ? '$shortCode — $name' : name;

  @override
  String toString() => 'KnownLocationModel($id, $shortCode, $city)';
}
