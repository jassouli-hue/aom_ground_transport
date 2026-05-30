import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/passenger_model.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';
import '../shared/map_picker_screen.dart';

class PassengerFormScreen extends ConsumerStatefulWidget {
  final int? passengerId;
  const PassengerFormScreen({super.key, this.passengerId});

  @override
  ConsumerState<PassengerFormScreen> createState() => _PassengerFormScreenState();
}

class _PassengerFormScreenState extends ConsumerState<PassengerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _roleCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  double? _baseLat;
  double? _baseLng;
  bool _loading = false;
  PassengerModel? _existing;

  bool get _isEdit => widget.passengerId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final p = await ref.read(passengerRepositoryProvider).getById(widget.passengerId!);
    if (p != null && mounted) {
      setState(() {
        _existing = p;
        _nameCtrl.text = p.name;
        _roleCtrl.text = p.role;
        _phoneCtrl.text = p.phone;
        _cityCtrl.text = p.baseCity;
        _baseLat = p.baseLat;
        _baseLng = p.baseLng;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.of(context).push<LatLngResult>(
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(
          initialLat: _baseLat,
          initialLng: _baseLng,
          title: 'Position de ${_nameCtrl.text.isEmpty ? "ce membre" : _nameCtrl.text}',
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _baseLat = result.lat;
        _baseLng = result.lng;
        // Auto-remplir la ville si Nominatim a retourné une ville
        if (result.city != null && result.city!.isNotEmpty) {
          _cityCtrl.text = result.city!;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final repo = ref.read(passengerRepositoryProvider);
    try {
      if (_isEdit && _existing != null) {
        await repo.update(PassengerModel(
          id: _existing!.id,
          name: _nameCtrl.text.trim(),
          role: _roleCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          baseCity: _cityCtrl.text.trim(),
          baseLat: _baseLat,
          baseLng: _baseLng,
          isActive: true,
          createdAt: _existing!.createdAt,
        ));
      } else {
        await repo.create(
          name: _nameCtrl.text.trim(),
          role: _roleCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          baseCity: _cityCtrl.text.trim(),
          baseLat: _baseLat,
          baseLng: _baseLng,
        );
      }
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AomAppBar(title: _isEdit ? 'Modifier membre' : 'Nouveau membre'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Nom *', prefixIcon: Icon(Icons.person)),
              textCapitalization: TextCapitalization.words,
              validator: (v) => v == null || v.trim().isEmpty ? 'Nom requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roleCtrl,
              decoration: const InputDecoration(
                  labelText: 'Rôle / Fonction *',
                  prefixIcon: Icon(Icons.badge),
                  hintText: 'CDB, Copilote, Hôtesse, Docteur…'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Rôle requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(
                  labelText: 'Téléphone *',
                  prefixIcon: Icon(Icons.phone),
                  hintText: '+212XXXXXXXXX'),
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.trim().isEmpty ? 'Téléphone requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityCtrl,
              decoration: const InputDecoration(
                  labelText: 'Ville de résidence *',
                  prefixIcon: Icon(Icons.location_city)),
              validator: (v) => v == null || v.trim().isEmpty ? 'Ville requise' : null,
            ),
            const SizedBox(height: 16),

            // Position GPS sur carte
            OutlinedButton.icon(
              onPressed: _openMapPicker,
              icon: Icon(
                _baseLat != null ? Icons.edit_location : Icons.add_location_alt,
                color: AppColors.primary,
              ),
              label: Text(
                _baseLat != null ? 'Modifier position sur la carte' : 'Définir position sur la carte',
                style: const TextStyle(color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            // Affichage coordonnées WGS84
            if (_baseLat != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_pin, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Position WGS84',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500)),
                        Text(
                          '${_baseLat!.toStringAsFixed(4)}, ${_baseLng!.toStringAsFixed(4)}',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: AppColors.textSecondary),
                      onPressed: () => setState(() { _baseLat = null; _baseLng = null; }),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      height: 18, width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(_isEdit ? 'Enregistrer' : 'Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
