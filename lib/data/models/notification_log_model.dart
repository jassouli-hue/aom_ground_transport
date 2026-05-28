class NotificationLogModel {
  final int id;
  final int missionId;
  final String recipientType; // CHAUFFEUR | PASSAGER
  final int recipientId;
  final String recipientName;
  final String recipientPhone;
  final String messageContent;
  final String whatsappUrl;
  final String status; // GENERE | OUVERT_WHATSAPP | MARQUE_ENVOYE
  final DateTime generatedAt;
  final DateTime? openedAt;
  final DateTime? markedSentAt;

  const NotificationLogModel({
    required this.id,
    required this.missionId,
    required this.recipientType,
    required this.recipientId,
    required this.recipientName,
    required this.recipientPhone,
    required this.messageContent,
    required this.whatsappUrl,
    required this.status,
    required this.generatedAt,
    this.openedAt,
    this.markedSentAt,
  });

  String get statusLabel {
    switch (status) {
      case 'GENERE':
        return 'Généré';
      case 'OUVERT_WHATSAPP':
        return 'Ouvert WhatsApp';
      case 'MARQUE_ENVOYE':
        return 'Marqué envoyé';
      default:
        return status;
    }
  }
}
