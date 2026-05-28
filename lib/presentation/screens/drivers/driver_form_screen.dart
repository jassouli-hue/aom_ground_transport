import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/driver_model.dart';
import '../../providers/driver_provider.dart';
import '../../providers/database_provider.dart';
import '../shared/widgets/aom_app_bar.dart';

class DriverFormScreen extends ConsumerStatefulWidget {
  final int? driverId;
  const DriverFormScreen({super.key, this.driverId});

  @override
  ConsumerState<DriverFormScreen> createState() => _DriverFormScreenState();
}

class _DriverFormScreenState extends ConsumerState<DriverFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _loading = false;
  DriverModel? _existing;

  bool get _isEdit => widget.driverId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadExisting();
  }

  Future<void> _loadExisting() async {
    final d = await ref.read(driverRepositoryProvider).getById(widget.driverId!);
    if (d != null && mounted) {
      setState(() {
        _existing = d;
        _nameCtrl.text = d.name;
        _phoneCtrl.text = d.phone;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final repo = ref.read(driverRepositoryProvider);
    try {
      if (_isEdit && _existing != null) {
        await repo.update(DriverModel(
          id: _existing!.id,
          name: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          isActive: true,
          createdAt: _existing!.createdAt,
        ));
      } else {
        await repo.create(
          name: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
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
      appBar: AomAppBar(title: _isEdit ? 'Modifier chauffeur' : 'Nouveau chauffeur'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nom *',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Nom requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Téléphone *',
                prefixIcon: Icon(Icons.phone),
                hintText: '+212XXXXXXXXX',
              ),
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Téléphone requis' : null,
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
