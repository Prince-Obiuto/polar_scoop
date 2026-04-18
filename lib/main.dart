import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Polar Scoop',
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: child!,
        );
      },
      themeMode: ThemeMode.system, // Automatically switches
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blueAccent,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardTheme: CardThemeData(
              color: Theme.of(context).colorScheme.surface, elevation: 0)),
    );
  }
}
