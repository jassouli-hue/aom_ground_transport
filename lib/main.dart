import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'domain/services/notification_service.dart';
import 'presentation/providers/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: _SeedWrapper(),
    ),
  );
}

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
    // Utiliser addPostFrameCallback pour appeler ref après le premier build
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    try {
      await ref.read(seedServiceProvider).seedIfNeeded();
    } catch (e) {
      debugPrint('[AOM] seedIfNeeded error: $e');
    }
    try {
      await NotificationService().initialize();
      if (mounted) {
        await NotificationService().requestPermission(context);
      }
    } catch (e) {
      debugPrint('[AOM] notification init error: $e');
    }
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003366))),
        home: const Scaffold(
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
