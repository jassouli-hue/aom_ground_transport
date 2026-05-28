class MissionStepModel {
  final int id;
  final int missionId;
  final int stepOrder;
  final String type;
  // DEPART_BASE | PICKUP | DESTINATION | RETOUR_BASE
  final String locationName;
  final String city;
  final double? latitude;
  final double? longitude;
  final double? distanceFromPrevKm;
  final int? durationFromPrevMin;

  const MissionStepModel({
    required this.id,
    required this.missionId,
    required this.stepOrder,
    required this.type,
    required this.locationName,
    required this.city,
    this.latitude,
    this.longitude,
    this.distanceFromPrevKm,
    this.durationFromPrevMin,
  });

  String get typeLabel {
    switch (type) {
      case 'DEPART_BASE':
        return 'Départ base';
      case 'PICKUP':
        return 'Prise en charge';
      case 'DESTINATION':
        return 'Destination';
      case 'RETOUR_BASE':
        return 'Retour base';
      default:
        return type;
    }
  }
}
