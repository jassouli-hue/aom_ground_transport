import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = _resolve(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  (String, Color) _resolve(String s) {
    switch (s) {
      case 'PLANIFIEE':
        return ('Planifiée', AppColors.planifiee);
      case 'EN_COURS':
        return ('En cours', AppColors.enCours);
      case 'TERMINEE':
        return ('Terminée', AppColors.terminee);
      case 'ANNULEE':
        return ('Annulée', AppColors.annulee);
      case 'GENERE':
        return ('Généré', AppColors.textSecondary);
      case 'OUVERT_WHATSAPP':
        return ('Ouvert WA', AppColors.warning);
      case 'MARQUE_ENVOYE':
        return ('Envoyé ✓', AppColors.success);
      case 'NON_ENVOYE':
        return ('Non envoyé', AppColors.textSecondary);
      default:
        return (s, AppColors.textSecondary);
    }
  }
}
