class PassengerModel {
  final int id;
  final String name;
  final String role;
  final String phone;
  final String baseCity;
  final bool isActive;
  final DateTime createdAt;

  const PassengerModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.baseCity,
    required this.isActive,
    required this.createdAt,
  });

  String get displayName => '$name ($role)';

  @override
  String toString() => 'PassengerModel($id, $name, $role)';
}
