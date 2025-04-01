import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'constants/theme.dart';
import 'screens/home_screen.dart';
import 'services/initialization_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: ChargeApp()));
}

final initializationProvider = FutureProvider<void>((ref) async {
  await InitializationService.initializeDatabase(ref);
});

class ChargeApp extends ConsumerWidget {
  const ChargeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialization = ref.watch(initializationProvider);

    return MaterialApp(
      title: 'Charge - Workout Tracker',
      theme: AppTheme.lightTheme,
      home: initialization.when(
        data: (_) => const HomeScreen(),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) => const Scaffold(
          body: Center(
            child: Text('Error initializing app'),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
} 