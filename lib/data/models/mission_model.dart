import 'mission_step_model.dart';

class MissionPassengerEntry {
  final int? passengerId;       // null = invité externe
  final String passengerName;
  final String passengerRole;
  final String passengerPhone;
  final bool isGuest;
  final String? guestName;
  final String? guestPhone;
  final String pickupCity;
  final int pickupOrder;
  final double? pickupLat;
  final double? pickupLng;
  final String whatsappStatus;
  final int missionPassengerId;

  const MissionPassengerEntry({
    this.passengerId,
    required this.passengerName,
    required this.passengerRole,
    required this.passengerPhone,
    this.isGuest = false,
    this.guestName,
    this.guestPhone,
    required this.pickupCity,
    required this.pickupOrder,
    this.pickupLat,
    this.pickupLng,
    required this.whatsappStatus,
    required this.missionPassengerId,
  });

  /// Vrai nom affiché (invité ou équipage)
  String get displayName => isGuest ? (guestName ?? 'Invité') : passengerName;

  /// Téléphone WhatsApp effectif
  String get whatsappPhone => isGuest ? (guestPhone ?? '') : passengerPhone;

  /// Peut recevoir un WhatsApp
  bool get hasPhone => whatsappPhone.isNotEmpty;
}

class MissionModel {
  final int id;
  final String reference;
  final String type; // DEPART | ARRIVEE
  final int driverId;
  final String driverName;
  final String driverPhone;
  final int vehicleId;
  final String vehicleBrand;
  final String vehiclePlate;
  final int destinationId;
  final String destinationName;
  final String destinationCity;
  final DateTime scheduledAt;
  final String status;
  final double? totalDistanceKm;
  final int? estimatedDurationMin;
  final String? googleMapsUrl;
  final bool returnToBase;
  final String? notes;
  final DateTime createdAt;
  final List<MissionPassengerEntry> passengers;
  final List<MissionStepModel> steps;
  final String driverWhatsappStatus;

  const MissionModel({
    required this.id,
    required this.reference,
    required this.type,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.vehicleId,
    required this.vehicleBrand,
    required this.vehiclePlate,
    required this.destinationId,
    required this.destinationName,
    required this.destinationCity,
    required this.scheduledAt,
    required this.status,
    this.totalDistanceKm,
    this.estimatedDurationMin,
    this.googleMapsUrl,
    required this.returnToBase,
    this.notes,
    required this.createdAt,
    required this.passengers,
    required this.steps,
    required this.driverWhatsappStatus,
  });

  String get statusLabel {
    switch (status) {
      case 'PLANIFIEE':
        return 'Planifiée';
      case 'EN_COURS':
        return 'En cours';
      case 'TERMINEE':
        return 'Terminée';
      case 'ANNULEE':
        return 'Annulée';
      default:
        return status;
    }
  }

  String get typeLabel => type == 'DEPART' ? 'Départ' : 'Arrivée';
}
