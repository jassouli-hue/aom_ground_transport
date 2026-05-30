import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/known_location_model.dart';
import '../../providers/settings_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/known_location_provider.dart';
import '../shared/widgets/aom_app_bar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  double _speed = 80.0;
  bool _pinEnabled = false;
  KnownLocationModel? _baseLoc;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final svc = ref.read(settingsServiceProvider);
    final speed = await svc.getAverageSpeedKmh();
    final pin = await svc.isPinEnabled();
    final baseId = await svc.getBaseLocationId();
    KnownLocationModel? base;
    if (baseId != null) {
      base = await ref.read(knownLocationRepositoryProvider).getById(baseId);
    }
    if (mounted) {
      setState(() {
        _speed = speed;
        _pinEnabled = pin;
        _baseLoc = base;
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final locAsync = ref.watch(locationsStreamProvider);

    return Scaffold(
      appBar: const AomAppBar(title: 'Paramètres'),
      body: ListView(
        children: [
          // Transport
          const _SettingSection('Transport'),
          ListTile(
            leading: const Icon(Icons.speed),
            title: const Text('Vitesse moyenne'),
            subtitle: Text('${_speed.toStringAsFixed(0)} km/h'),
            trailing: SizedBox(
              width: 180,
              child: Slider(
                value: _speed,
                min: 40,
                max: 140,
                divisions: 20,
                label: '${_speed.toStringAsFixed(0)} km/h',
                onChanged: (v) => setState(() => _speed = v),
                onChangeEnd: (v) =>
                    ref.read(settingsServiceProvider).setAverageSpeedKmh(v),
              ),
            ),
          ),
          locAsync.when(
            data: (locs) => ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Base de départ'),
              subtitle: Text(_baseLoc?.name ?? 'Non configuré'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickBase(context, locs),
            ),
            loading: () => const ListTile(title: Text('Chargement...')),
            error: (_, __) => const ListTile(title: Text('Erreur')),
          ),
          const Divider(),

          // Sécurité
          const _SettingSection('Sécurité'),
          SwitchListTile(
            secondary: const Icon(Icons.lock),
            title: const Text('PIN de verrouillage'),
            subtitle: const Text('Protéger l\'app par un code PIN'),
            value: _pinEnabled,
            onChanged: (v) {
              setState(() => _pinEnabled = v);
              ref.read(settingsServiceProvider).setPinEnabled(v);
              if (v) _showSetPinDialog(context);
            },
          ),
          const Divider(),

          // Sauvegarde & Restauration
          const _SettingSection('Sauvegarde & Restauration'),
          ListTile(
            leading: const Icon(Icons.file_upload_outlined, color: AppColors.primary),
            title: const Text('Exporter en JSON'),
            subtitle: const Text('Sauvegarde complète — partager via WhatsApp, Drive…'),
            trailing: const Icon(Icons.share, size: 18, color: AppColors.textSecondary),
            onTap: () => _doExport(context, 'json'),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined, color: AppColors.accent),
            title: const Text('Exporter en CSV'),
            subtitle: const Text('Toutes les tables (Excel/Sheets) — 5 fichiers'),
            trailing: const Icon(Icons.share, size: 18, color: AppColors.textSecondary),
            onTap: () => _doExport(context, 'csv'),
          ),
          ListTile(
            leading: const Icon(Icons.file_download_outlined, color: AppColors.success),
            title: const Text('Importer depuis JSON'),
            subtitle: const Text('Restauration complète — remplace toutes les données'),
            trailing: const Icon(Icons.folder_open, size: 18, color: AppColors.textSecondary),
            onTap: () => _doImport(context),
          ),
          const Divider(),

          // À propos
          const _SettingSection('À propos'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('AOM Ground Transport Mobile'),
            subtitle: Text('Version 1.0.0 • AIR OCEAN MAROC\nDonnées stockées localement'),
            isThreeLine: true,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _doExport(BuildContext context, String format) async {
    final svc = ref.read(backupServiceProvider);
    try {
      if (format == 'json') {
        await svc.shareJson();
      } else {
        await svc.shareCsv();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur export : $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _doImport(BuildContext context) async {
    final svc = ref.read(backupServiceProvider);

    final path = await svc.pickJsonFile();
    if (path == null || !context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Restaurer la base de données ?'),
        content: const Text(
          'Toutes les données actuelles (chauffeurs, véhicules, passagers, missions) '
          'seront remplacées par celles du fichier JSON.\n\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restaurer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Restauration en cours…'),
        ]),
      ),
    );

    try {
      await svc.importFromFile(path);
      if (context.mounted) {
        Navigator.of(context).pop(); // ferme le loader
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Base de données restaurée avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur import : $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _pickBase(
      BuildContext context, List<KnownLocationModel> locs) async {
    if (locs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune destination configurée. Ajoutez d\'abord une destination.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Bottom sheet → aucun problème de contexte de navigation
    final selected = await showModalBottomSheet<KnownLocationModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.home, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text('Sélectionner la base de départ',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ],
              ),
            ),
            const Divider(height: 1),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 350),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: locs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final l = locs[i];
                  final isCurrent = _baseLoc?.id == l.id;
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: isCurrent
                          ? AppColors.primary.withOpacity(0.12)
                          : Colors.grey.shade100,
                      child: Icon(
                        isCurrent ? Icons.home : Icons.place_outlined,
                        color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                        size: 18,
                      ),
                    ),
                    title: Text(l.name,
                        style: TextStyle(
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14)),
                    subtitle: Text(l.city,
                        style: const TextStyle(fontSize: 12)),
                    trailing: isCurrent
                        ? const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 20)
                        : null,
                    onTap: () => Navigator.of(sheetCtx).pop(l),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (selected != null && mounted) {
      try {
        await ref.read(settingsServiceProvider).setBaseLocationId(selected.id);
        if (mounted) {
          setState(() => _baseLoc = selected);
          ref.invalidate(baseLocationIdProvider);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('✓ Base définie : ${selected.name}'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erreur sauvegarde : $e'),
            backgroundColor: AppColors.error,
          ));
        }
      }
    }
  }

  void _showSetPinDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Définir le PIN'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          maxLength: 6,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Code PIN (4-6 chiffres)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.length >= 4) {
                ref.read(settingsServiceProvider).setPinCode(ctrl.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}

class _SettingSection extends StatelessWidget {
  final String label;
  const _SettingSection(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.8)),
    );
  }
}
