// features/deliveries/deliveries_provider.dart
//
// Riverpod providers for the deliveries feature.
// Written using manual provider declarations — no code generation
// required. This avoids riverpod_generator's inability to resolve
// Drift-generated types (Delivery, OrderItem) from part files.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';

// ─────────────────────────────────────────────────────────────
// SECTION 1: DATABASE PROVIDER
// ─────────────────────────────────────────────────────────────
//
// Provider<T> — synchronous, returns a single value.
// The database instance is created once and kept alive for the
// entire app lifetime. onDispose closes the SQLite connection
// cleanly when the app shuts down.

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ─────────────────────────────────────────────────────────────
// SECTION 2: DELIVERY LIST PROVIDER
// ─────────────────────────────────────────────────────────────
//
// StreamProvider<T> — wraps a Stream and exposes it as an
// AsyncValue<T> with three states: loading, data, error.
// Whenever Drift emits a new list (after a status update),
// every widget watching this provider rebuilds automatically.

final deliveriesListProvider = StreamProvider<List<Delivery>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchAllDeliveries();
});

// ─────────────────────────────────────────────────────────────
// SECTION 3: SINGLE DELIVERY PROVIDER
// ─────────────────────────────────────────────────────────────
//
// StreamProvider.family — parameterised by delivery ID.
// deliveryByIdProvider(3) and deliveryByIdProvider(5) are
// completely independent provider instances with separate caches.
// Used by the detail screen to watch one delivery's status.

final deliveryByIdProvider =
    StreamProvider.family<Delivery, int>((ref, deliveryId) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchDeliveryById(deliveryId);
});

// ─────────────────────────────────────────────────────────────
// SECTION 4: ORDER ITEMS PROVIDER
// ─────────────────────────────────────────────────────────────
//
// FutureProvider.family — fetches items for one delivery.
// Items are read-only after seeding so a Future is sufficient;
// no stream needed here.

final orderItemsProvider =
    FutureProvider.family<List<OrderItem>, int>((ref, deliveryId) {
  final db = ref.watch(appDatabaseProvider);
  return db.getItemsForDelivery(deliveryId);
});

// ─────────────────────────────────────────────────────────────
// SECTION 5: DELIVERY ACTIONS SERVICE
// ─────────────────────────────────────────────────────────────
//
// A plain Dart class that wraps the two write operations.
// Exposed through a regular Provider — no notifier needed
// because this class holds no state. Reactive updates come
// from the stream providers above, which Drift updates
// automatically after every write.
//
// Usage in widgets (always use ref.read for actions):
//   ref.read(deliveryActionsProvider).markDelivered(id)
//   ref.read(deliveryActionsProvider).markFailed(id, reason: '...')

class DeliveryActionsService {
  const DeliveryActionsService(this._db);

  final AppDatabase _db;

  Future<void> markDelivered(int deliveryId) {
    return _db.updateDeliveryStatus(deliveryId, DeliveryStatus.delivered);
  }

  Future<void> markFailed(int deliveryId, {String? reason}) {
    return _db.updateDeliveryStatus(
      deliveryId,
      DeliveryStatus.failed,
      failureReason: reason,
    );
  }
}

final deliveryActionsProvider = Provider<DeliveryActionsService>((ref) {
  return DeliveryActionsService(ref.watch(appDatabaseProvider));
});
