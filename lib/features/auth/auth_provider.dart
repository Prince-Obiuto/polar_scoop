// features/auth/auth_provider.dart
//
// Manages login state for the driver session.
// Authentication is hardcoded for this PoC — no real backend.
// Valid credentials: ID = "driver", password = "password"

import 'package:flutter_riverpod/legacy.dart';

// ─────────────────────────────────────────────────────────────
// AUTH STATE
// ─────────────────────────────────────────────────────────────
//
// A simple immutable class representing the current auth state.
// isAuthenticated — whether the driver has logged in.
// errorMessage    — shown under the form fields on bad login.

class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.errorMessage,
  });

  final bool isAuthenticated;
  final String? errorMessage;

  // copyWith lets us update one field without touching the others.
  // Standard pattern for immutable state in Dart.
  AuthState copyWith({
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage, // null clears the error
    );
  }
}

// ─────────────────────────────────────────────────────────────
// AUTH NOTIFIER
// ─────────────────────────────────────────────────────────────
//
// StateNotifier<T> holds a piece of state (AuthState) and
// exposes methods that mutate it. Widgets watch the provider
// and rebuild whenever state changes.

class AuthNotifier extends StateNotifier<AuthState> {
  // Start with unauthenticated, no error.
  AuthNotifier() : super(const AuthState());

  // Hardcoded credentials for the PoC.
  static const _validId = 'driver';
  static const _validPassword = 'password';

  // Called when the driver taps the Login button.
  // Returns true if login succeeded (used by the UI to navigate).
  bool login(String driverId, String password) {
    if (driverId.trim() == _validId && password == _validPassword) {
      state = state.copyWith(isAuthenticated: true, errorMessage: null);
      return true;
    }

    // Wrong credentials — set error message, stay unauthenticated.
    state = state.copyWith(
      isAuthenticated: false,
      errorMessage: 'Invalid Driver ID or password.',
    );
    return false;
  }

  // Called when the driver logs out (future use).
  void logout() {
    state = const AuthState();
  }
}

// ─────────────────────────────────────────────────────────────
// AUTH PROVIDER
// ─────────────────────────────────────────────────────────────
//
// StateNotifierProvider exposes both the notifier (for calling
// methods) and the state (for reading values).
//
// Read the state:   ref.watch(authProvider)
// Call a method:    ref.read(authProvider.notifier).login(id, pw)

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
