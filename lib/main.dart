import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'presentation/providers/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  runApp(
    ProviderScope(
      child: const _SeedWrapper(),
    ),
  );
}

/// Lance le seed au démarrage, puis affiche l'app.
class _SeedWrapper extends ConsumerStatefulWidget {
  const _SeedWrapper();

  @override
  ConsumerState<_SeedWrapper> createState() => _SeedWrapperState();
}

class _SeedWrapperState extends ConsumerState<_SeedWrapper> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await ref.read(seedServiceProvider).seedIfNeeded();
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initialisation AOM Ground Transport…'),
              ],
            ),
          ),
        ),
      );
    }
    return const AomApp();
  }
}
