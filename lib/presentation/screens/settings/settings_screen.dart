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

          // Sauvegarde
          const _SettingSection('Sauvegarde'),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Exporter les données'),
            subtitle: const Text('Partager un fichier JSON de sauvegarde'),
            onTap: () async {
              try {
                await ref.read(backupServiceProvider).shareBackup();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur export: $e')),
                  );
                }
              }
            },
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

  Future<void> _pickBase(
      BuildContext context, List<KnownLocationModel> locs) async {
    final selected = await showDialog<KnownLocationModel>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sélectionner la base'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: locs.map((l) => ListTile(
              title: Text(l.name),
              subtitle: Text(l.city),
              onTap: () => Navigator.pop(context, l),
            )).toList(),
          ),
        ),
      ),
    );
    if (selected != null) {
      await ref.read(settingsServiceProvider).setBaseLocationId(selected.id);
      setState(() => _baseLoc = selected);
      ref.invalidate(baseLocationIdProvider);
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
