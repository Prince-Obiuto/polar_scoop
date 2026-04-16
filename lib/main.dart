import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: PolarScoopApp(),
    ),
  );
}

// ConsumerWidget instead of StatelessWidget — gives us access
// to `ref` so we can read the router provider.
class PolarScoopApp extends ConsumerWidget {
  const PolarScoopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router — it internally watches auth state and
    // handles redirects automatically when login status changes.
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Polar Scoop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
