import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Ensures Flutter's native binding is initialised before we do
  // any async work (like opening the database).
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ProviderScope is the Riverpod equivalent of a provider registry.
    // It MUST wrap the entire app — every provider lives inside this scope.
    const ProviderScope(
      child: PolarScoopApp(),
    ),
  );
}

class PolarScoopApp extends StatelessWidget {
  const PolarScoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polar Scoop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      // Temporary home — we will replace this with GoRouter once
      // the router is configured in a later step.
      home: const Scaffold(
        body: Center(
          child: Text('Polar Scoop — engine running'),
        ),
      ),
    );
  }
}
