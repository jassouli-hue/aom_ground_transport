import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/passenger_model.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';

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
          isActive: true,
          createdAt: _existing!.createdAt,
        ));
      } else {
        await repo.create(
          name: _nameCtrl.text.trim(),
          role: _roleCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          baseCity: _cityCtrl.text.trim(),
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
      appBar: AomAppBar(title: _isEdit ? 'Modifier passager' : 'Nouveau passager'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Nom *', prefixIcon: Icon(Icons.person)),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Nom requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roleCtrl,
              decoration: const InputDecoration(
                  labelText: 'Rôle / Fonction *',
                  prefixIcon: Icon(Icons.badge),
                  hintText: 'CDB, Copilote, Hôtesse…'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Rôle requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(
                  labelText: 'Téléphone *',
                  prefixIcon: Icon(Icons.phone),
                  hintText: '+212XXXXXXXXX'),
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Téléphone requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityCtrl,
              decoration: const InputDecoration(
                  labelText: 'Ville de résidence *',
                  prefixIcon: Icon(Icons.location_city)),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ville requise' : null,
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
