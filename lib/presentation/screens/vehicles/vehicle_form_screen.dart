import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/vehicle_model.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';

class VehicleFormScreen extends ConsumerStatefulWidget {
  final int? vehicleId;
  const VehicleFormScreen({super.key, this.vehicleId});

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  int _capacity = 4;
  bool _loading = false;
  VehicleModel? _existing;

  bool get _isEdit => widget.vehicleId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final v = await ref.read(vehicleRepositoryProvider).getById(widget.vehicleId!);
    if (v != null && mounted) {
      setState(() {
        _existing = v;
        _brandCtrl.text = v.brand;
        _plateCtrl.text = v.plateNumber;
        _capacity = v.capacity;
      });
    }
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final repo = ref.read(vehicleRepositoryProvider);
    try {
      if (_isEdit && _existing != null) {
        await repo.update(VehicleModel(
          id: _existing!.id,
          brand: _brandCtrl.text.trim(),
          plateNumber: _plateCtrl.text.trim(),
          capacity: _capacity,
          isActive: true,
          createdAt: _existing!.createdAt,
        ));
      } else {
        await repo.create(
          brand: _brandCtrl.text.trim(),
          plateNumber: _plateCtrl.text.trim(),
          capacity: _capacity,
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
      appBar: AomAppBar(title: _isEdit ? 'Modifier véhicule' : 'Nouveau véhicule'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _brandCtrl,
              decoration: const InputDecoration(
                labelText: 'Marque / Modèle *',
                prefixIcon: Icon(Icons.directions_car),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Marque requise' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _plateCtrl,
              decoration: const InputDecoration(
                labelText: 'Immatriculation *',
                prefixIcon: Icon(Icons.confirmation_number),
                hintText: 'AOM-001',
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Immatriculation requise' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _capacity,
              decoration: const InputDecoration(
                labelText: 'Capacité (places)',
                prefixIcon: Icon(Icons.people),
              ),
              items: [2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 20]
                  .map((n) => DropdownMenuItem(
                      value: n, child: Text('$n places')))
                  .toList(),
              onChanged: (v) => setState(() => _capacity = v ?? 4),
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
