// core/router/app_router.dart
//
// Central route configuration using GoRouter.
// All navigation paths are defined here — no screen widget
// knows about any other screen widget directly.
//
// Route map:
//   /login              → LoginScreen
//   /deliveries         → DeliveryListScreen
//   /deliveries/:id     → DeliveryDetailScreen

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_provider.dart';
import '../../features/auth/login_screen.dart';
import '../../features/deliveries/delivery_detail_screen.dart';
import '../../features/deliveries/delivery_list_screen.dart';

// ─────────────────────────────────────────────────────────────
// ROUTER PROVIDER
// ─────────────────────────────────────────────────────────────
//
// Exposing GoRouter as a Riverpod provider lets any widget
// access it via ref, and allows the router to watch other
// providers (like auth state) for redirect logic.

final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state so the router rebuilds its redirect logic
  // whenever the driver logs in or out.
  final authState = ref.watch(authProvider);

  return GoRouter(
    // Start at login. The redirect below handles the rest.
    initialLocation: '/login',
    debugLogDiagnostics: false,

    // ── REDIRECT LOGIC ───────────────────────────────────────
    //
    // Called before every navigation. Returns a new path to
    // redirect to, or null to allow the navigation as-is.
    //
    // Rules:
    //   • Not logged in → always redirect to /login
    //   • Logged in and heading to /login → redirect to /deliveries
    //   • Otherwise → allow navigation

    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isOnLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isOnLogin) return '/login';
      if (isLoggedIn && isOnLogin) return '/deliveries';
      return null;
    },

    routes: [
      // ── LOGIN ─────────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── DELIVERY LIST ─────────────────────────────────────
      GoRoute(
        path: '/deliveries',
        builder: (context, state) => const DeliveryListScreen(),

        // ── DELIVERY DETAIL (nested route) ──────────────────
        //
        // Nested under /deliveries so the back button naturally
        // returns to the list. The :id segment is a path parameter
        // captured from the URL, e.g. /deliveries/3 → id = "3".
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              // Extract and parse the delivery ID from the path.
              final id = int.parse(state.pathParameters['id']!);
              return DeliveryDetailScreen(deliveryId: id);
            },
          ),
        ],
      ),
    ],
  );
});
