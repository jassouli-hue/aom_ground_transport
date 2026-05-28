class VehicleModel {
  final int id;
  final String brand;
  final String plateNumber;
  final int capacity;
  final bool isActive;
  final DateTime createdAt;

  const VehicleModel({
    required this.id,
    required this.brand,
    required this.plateNumber,
    required this.capacity,
    required this.isActive,
    required this.createdAt,
  });

  String get displayName => '$brand — $plateNumber';

  @override
  String toString() => 'VehicleModel($id, $brand, $plateNumber)';
}
