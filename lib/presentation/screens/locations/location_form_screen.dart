import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/known_location_model.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';
import '../shared/map_picker_screen.dart';

class LocationFormScreen extends ConsumerStatefulWidget {
  final int? locationId;
  const LocationFormScreen({super.key, this.locationId});

  @override
  ConsumerState<LocationFormScreen> createState() => _LocationFormScreenState();
}

class _LocationFormScreenState extends ConsumerState<LocationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();
  bool _isAirport = false;
  bool _loading = false;
  KnownLocationModel? _existing;

  bool get _isEdit => widget.locationId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final l = await ref.read(knownLocationRepositoryProvider).getById(widget.locationId!);
    if (l != null && mounted) {
      setState(() {
        _existing = l;
        _nameCtrl.text = l.name;
        _codeCtrl.text = l.shortCode;
        _cityCtrl.text = l.city;
        _latCtrl.text = l.latitude.toString();
        _lngCtrl.text = l.longitude.toString();
        _isAirport = l.isAirport;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _cityCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final double? currentLat = double.tryParse(_latCtrl.text);
    final double? currentLng = double.tryParse(_lngCtrl.text);

    final result = await Navigator.of(context).push<LatLngResult>(
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(
          initialLat: currentLat,
          initialLng: currentLng,
          title: 'Choisir sur la carte',
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _latCtrl.text = result.lat.toStringAsFixed(4);
        _lngCtrl.text = result.lng.toStringAsFixed(4);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final repo = ref.read(knownLocationRepositoryProvider);
    try {
      final lat = double.parse(_latCtrl.text.trim());
      final lng = double.parse(_lngCtrl.text.trim());
      if (_isEdit && _existing != null) {
        await repo.update(KnownLocationModel(
          id: _existing!.id,
          name: _nameCtrl.text.trim(),
          shortCode: _codeCtrl.text.trim().toUpperCase(),
          city: _cityCtrl.text.trim(),
          latitude: lat,
          longitude: lng,
          isAirport: _isAirport,
          isActive: true,
        ));
      } else {
        await repo.create(
          name: _nameCtrl.text.trim(),
          shortCode: _codeCtrl.text.trim().toUpperCase(),
          city: _cityCtrl.text.trim(),
          latitude: lat,
          longitude: lng,
          isAirport: _isAirport,
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
      appBar: AomAppBar(title: _isEdit ? 'Modifier destination' : 'Nouvelle destination'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Nom *', prefixIcon: Icon(Icons.place)),
              validator: (v) => v == null || v.trim().isEmpty ? 'Nom requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codeCtrl,
              decoration: const InputDecoration(
                  labelText: 'Code OACI / Abréviation *',
                  prefixIcon: Icon(Icons.code),
                  hintText: 'GMMN, BASE, SALE…'),
              textCapitalization: TextCapitalization.characters,
              validator: (v) => v == null || v.trim().isEmpty ? 'Code requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityCtrl,
              decoration: const InputDecoration(
                  labelText: 'Ville *', prefixIcon: Icon(Icons.location_city)),
              validator: (v) => v == null || v.trim().isEmpty ? 'Ville requise' : null,
            ),
            const SizedBox(height: 16),

            // Bouton carte
            OutlinedButton.icon(
              onPressed: _openMapPicker,
              icon: const Icon(Icons.map, color: AppColors.primary),
              label: Text(
                _latCtrl.text.isEmpty
                    ? 'Choisir sur la carte'
                    : 'Modifier sur la carte',
                style: const TextStyle(color: AppColors.primary),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),

            // Coordonnées — affichées en lecture seule si remplies via carte
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latCtrl,
                    decoration: InputDecoration(
                      labelText: 'Latitude *',
                      prefixIcon: const Icon(Icons.north),
                      fillColor: _latCtrl.text.isNotEmpty
                          ? AppColors.primary.withOpacity(0.04)
                          : null,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requis';
                      if (double.tryParse(v.trim()) == null) return 'Invalide';
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _lngCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Longitude *',
                      prefixIcon: Icon(Icons.east),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requis';
                      if (double.tryParse(v.trim()) == null) return 'Invalide';
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _isAirport,
              onChanged: (v) => setState(() => _isAirport = v),
              title: const Text('Aéroport'),
              subtitle: const Text('Cocher si c\'est un aéroport'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(_isEdit ? 'Enregistrer' : 'Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
