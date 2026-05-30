class PassengerModel {
  final int id;
  final String name;
  final String role;
  final String phone;
  final String baseCity;
  final double? baseLat;
  final double? baseLng;
  final bool isActive;
  final DateTime createdAt;

  const PassengerModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.baseCity,
    this.baseLat,
    this.baseLng,
    required this.isActive,
    required this.createdAt,
  });

  String get displayName => '$name ($role)';

  @override
  String toString() => 'PassengerModel($id, $name, $role)';
}
