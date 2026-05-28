class DriverModel {
  final int id;
  final String name;
  final String phone;
  final bool isActive;
  final DateTime createdAt;

  const DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.createdAt,
  });

  String get displayName => name;
  String get formattedPhone => phone;

  @override
  String toString() => 'DriverModel($id, $name)';
}
