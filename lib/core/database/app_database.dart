// core/database/app_database.dart
//
// This file defines the entire local database for Polar Scoop.
// Drift reads these class definitions and generates the implementation
// in app_database.g.dart when you run build_runner.
//
// IMPORTANT: After saving this file, run:
//   dart run build_runner build --delete-conflicting-outputs

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// The generated file — does not exist yet until you run build_runner.
part 'app_database.g.dart';

// ─────────────────────────────────────────────────────────────
// SECTION 1: THE STATUS ENUM
// ─────────────────────────────────────────────────────────────
//
// We work with this type-safe enum throughout the app.
// Drift stores it as a plain string in SQLite ("pending",
// "delivered", "failed") via the TypeConverter below.

enum DeliveryStatus { pending, delivered, failed }

// ─────────────────────────────────────────────────────────────
// SECTION 2: THE TYPE CONVERTER
// ─────────────────────────────────────────────────────────────
//
// A TypeConverter tells Drift how to map between a Dart type
// (DeliveryStatus) and a SQLite-compatible type (String).
//
// toSql()   — called when WRITING to the database.
// fromSql() — called when READING from the database.

class DeliveryStatusConverter extends TypeConverter<DeliveryStatus, String> {
  const DeliveryStatusConverter();

  @override
  DeliveryStatus fromSql(String fromDb) {
    // Map the stored string back to the Dart enum value.
    return DeliveryStatus.values.firstWhere(
      (e) => e.name == fromDb,
      // Safety net: if an unknown string is somehow in the DB,
      // default to pending rather than throwing a runtime error.
      orElse: () => DeliveryStatus.pending,
    );
  }

  @override
  String toSql(DeliveryStatus value) {
    // Store the enum's name: "pending", "delivered", or "failed".
    return value.name;
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION 3: TABLE DEFINITIONS
// ─────────────────────────────────────────────────────────────
//
// Each class extending Table becomes a table in SQLite.
// Drift uses the class name (converted to snake_case) as the
// table name: Deliveries → deliveries, OrderItems → order_items.
//
// Column types:
//   IntColumn    → INTEGER in SQLite
//   TextColumn   → TEXT in SQLite
//   BoolColumn   → INTEGER (0/1) in SQLite

class Deliveries extends Table {
  // Primary key — auto-increments on every insert.
  IntColumn get id => integer().autoIncrement()();

  // The name of the store receiving this delivery.
  TextColumn get storeName => text()();

  // Street address of the store.
  TextColumn get address => text()();

  // Delivery status stored as TEXT in SQLite and exposed as
  // a type-safe DeliveryStatus enum in Dart.
  TextColumn get status => textEnum<DeliveryStatus>()();

  // Only populated when status is DeliveryStatus.failed.
  // nullable() means this column accepts NULL in SQLite.
  TextColumn get failureReason => text().nullable()();
}

class OrderItems extends Table {
  // Primary key.
  IntColumn get id => integer().autoIncrement()();

  // Foreign key — references deliveries.id.
  // Drift does not enforce FK constraints by default at the Dart
  // level, but we use this consistently to maintain integrity.
  IntColumn get deliveryId => integer().references(Deliveries, #id)();

  // Human-readable product name, e.g. "Vanilla Bean Tub".
  TextColumn get productName => text()();

  // Number of tubs for this product in the order.
  IntColumn get quantity => integer()();
}

// ─────────────────────────────────────────────────────────────
// SECTION 4: THE DATABASE CLASS
// ─────────────────────────────────────────────────────────────
//
// @DriftDatabase tells build_runner to generate the full
// database implementation in app_database.g.dart.
// The tables list must include every table you defined above.
//
// This class extends the generated _$AppDatabase mixin,
// which provides all the boilerplate query infrastructure.

@DriftDatabase(tables: [Deliveries, OrderItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Schema version. Increment this when you add/change tables
  // and provide a MigrationStrategy. For a PoC, version 1 is fine.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          // Create all tables defined above.
          await m.createAll();
          // Seed mock data on first launch.
          await _seedMockData();
        },
      );

  // ── QUERIES ──────────────────────────────────────────────

  // Returns a STREAM of all deliveries, ordered by ID.
  // Streams are the key to reactivity: whenever any delivery
  // row changes, this stream emits the updated list automatically.
  // Riverpod providers will watch this stream.
  Stream<List<Delivery>> watchAllDeliveries() {
    return (select(deliveries)..orderBy([(d) => OrderingTerm.asc(d.id)]))
        .watch();
  }

  // Returns a stream of a single delivery by its ID.
  // Used by the detail screen to stay in sync with the database.
  Stream<Delivery> watchDeliveryById(int id) {
    return (select(deliveries)..where((d) => d.id.equals(id))).watchSingle();
  }

  // Returns all order items belonging to a specific delivery.
  // This is a one-shot Future (not a stream) because items
  // never change after the delivery is created.
  Future<List<OrderItem>> getItemsForDelivery(int deliveryId) {
    return (select(orderItems)..where((i) => i.deliveryId.equals(deliveryId)))
        .get();
  }

  // Updates the status (and optionally failure reason) of a delivery.
  // Called by the ViewModel when the driver taps a status button.
  Future<void> updateDeliveryStatus(
    int id,
    DeliveryStatus status, {
    String? failureReason,
  }) {
    return (update(deliveries)..where((d) => d.id.equals(id))).write(
      DeliveriesCompanion(
        status: Value(status),
        failureReason: Value(failureReason),
      ),
    );
  }

  // ── SEEDER ───────────────────────────────────────────────

  // Inserts mock deliveries and their order items.
  // Only called from onCreate, which only fires on a fresh install.
  Future<void> _seedMockData() async {
    // Each entry is a (store, address) pair.
    final stores = [
      ('Sandy\'s Cafe', '12 Beachfront Ave'),
      ('The Griddle House', '88 Maple Street'),
      ('Corner Grocer', '5 Elm Road'),
      ('Blue Moon Bistro', '201 Harbour Drive'),
      ('Sunrise Deli', '47 Park Lane'),
      ('The Sweet Spot', '9 Victoria Road'),
    ];

    // Items for each store, in the same order as the stores list.
    // Each item is a (productName, quantity) pair.
    final items = [
      // Sandy's Cafe
      [
        ('Vanilla Bean Tub', 5),
        ('Chocolate Fudge Tub', 3),
        ('Strawberry Swirl Tub', 2),
      ],
      // The Griddle House
      [
        ('Cookies & Cream Tub', 4),
        ('Salted Caramel Tub', 4),
      ],
      // Corner Grocer
      [
        ('Vanilla Bean Tub', 10),
        ('Chocolate Fudge Tub', 6),
        ('Mango Sorbet Tub', 4),
        ('Pistachio Tub', 2),
      ],
      // Blue Moon Bistro
      [
        ('Lavender Honey Tub', 3),
        ('Dark Chocolate Tub', 3),
        ('Raspberry Ripple Tub', 2),
      ],
      // Sunrise Deli
      [
        ('Vanilla Bean Tub', 8),
        ('Strawberry Swirl Tub', 5),
      ],
      // The Sweet Spot
      [
        ('Cookies & Cream Tub', 6),
        ('Salted Caramel Tub', 6),
        ('Mint Choc Chip Tub', 4),
        ('Rocky Road Tub', 3),
      ],
    ];

    for (int i = 0; i < stores.length; i++) {
      final (storeName, address) = stores[i];

      // Insert the delivery row and get the auto-generated ID back.
      final deliveryId = await into(deliveries).insert(
        DeliveriesCompanion.insert(
          storeName: storeName,
          address: address,
          // All deliveries start as pending.
          status: DeliveryStatus.pending,
        ),
      );

      // Insert each order item linked to this delivery.
      for (final (productName, quantity) in items[i]) {
        await into(orderItems).insert(
          OrderItemsCompanion.insert(
            deliveryId: deliveryId,
            productName: productName,
            quantity: quantity,
          ),
        );
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION 5: CONNECTION HELPER
// ─────────────────────────────────────────────────────────────
//
// driftDatabase() is provided by drift_flutter. It handles
// the platform-specific path where the .sqlite file is stored
// (Android: app's internal storage, invisible to other apps).

QueryExecutor _openConnection() {
  return driftDatabase(name: 'polar_scoop_db');
}
