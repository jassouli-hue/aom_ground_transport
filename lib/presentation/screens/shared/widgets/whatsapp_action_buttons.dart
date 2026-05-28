import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/mission_model.dart';
import '../../../providers/database_provider.dart';

class WhatsAppDriverButtons extends ConsumerWidget {
  final MissionModel mission;
  final VoidCallback? onStatusChanged;

  const WhatsAppDriverButtons({
    super.key,
    required this.mission,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waService = ref.read(whatsAppMessageServiceProvider);
    final message = waService.buildDriverMessage(mission);

    return _WhatsAppButtonGroup(
      label: mission.driverName,
      phone: mission.driverPhone,
      icon: Icons.drive_eta,
      status: mission.driverWhatsappStatus,
      message: message,
      onOpen: () async {
        final ok = await waService.openWhatsApp(
          missionId: mission.id,
          recipientType: 'CHAUFFEUR',
          recipientId: mission.driverId,
          recipientName: mission.driverName,
          recipientPhone: mission.driverPhone,
          message: message,
        );
        if (!ok && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('WhatsApp introuvable sur cet appareil')),
          );
        }
        onStatusChanged?.call();
      },
    );
  }
}

class WhatsAppPassengerButtons extends ConsumerWidget {
  final MissionModel mission;
  final MissionPassengerEntry passenger;
  final VoidCallback? onStatusChanged;

  const WhatsAppPassengerButtons({
    super.key,
    required this.mission,
    required this.passenger,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waService = ref.read(whatsAppMessageServiceProvider);
    final message = waService.buildPassengerMessage(mission, passenger);

    return _WhatsAppButtonGroup(
      label: passenger.passengerName,
      phone: passenger.passengerPhone,
      icon: Icons.person,
      status: passenger.whatsappStatus,
      message: message,
      onOpen: () async {
        final ok = await waService.openWhatsApp(
          missionId: mission.id,
          recipientType: 'PASSAGER',
          recipientId: passenger.passengerId,
          recipientName: passenger.passengerName,
          recipientPhone: passenger.passengerPhone,
          message: message,
        );
        if (!ok && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('WhatsApp introuvable sur cet appareil')),
          );
        }
        onStatusChanged?.call();
      },
    );
  }
}

class _WhatsAppButtonGroup extends StatelessWidget {
  final String label;
  final String phone;
  final IconData icon;
  final String status;
  final String message;
  final VoidCallback onOpen;

  const _WhatsAppButtonGroup({
    required this.label,
    required this.phone,
    required this.icon,
    required this.status,
    required this.message,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '$label — $phone',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // WhatsApp button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onOpen,
                  icon: const Icon(Icons.chat, size: 16),
                  label: const Text('WhatsApp', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Copy button
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message copié'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 14),
                label: const Text('Copier', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
