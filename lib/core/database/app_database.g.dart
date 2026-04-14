// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DeliveriesTable extends Deliveries
    with TableInfo<$DeliveriesTable, Delivery> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeliveriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _storeNameMeta =
      const VerificationMeta('storeName');
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
      'store_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<DeliveryStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<DeliveryStatus>($DeliveriesTable.$converterstatus);
  static const VerificationMeta _failureReasonMeta =
      const VerificationMeta('failureReason');
  @override
  late final GeneratedColumn<String> failureReason = GeneratedColumn<String>(
      'failure_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, storeName, address, status, failureReason];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deliveries';
  @override
  VerificationContext validateIntegrity(Insertable<Delivery> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('store_name')) {
      context.handle(_storeNameMeta,
          storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta));
    } else if (isInserting) {
      context.missing(_storeNameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('failure_reason')) {
      context.handle(
          _failureReasonMeta,
          failureReason.isAcceptableOrUnknown(
              data['failure_reason']!, _failureReasonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Delivery map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Delivery(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      storeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}store_name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      status: $DeliveriesTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      failureReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}failure_reason']),
    );
  }

  @override
  $DeliveriesTable createAlias(String alias) {
    return $DeliveriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DeliveryStatus, String, String> $converterstatus =
      const EnumNameConverter<DeliveryStatus>(DeliveryStatus.values);
}

class Delivery extends DataClass implements Insertable<Delivery> {
  final int id;
  final String storeName;
  final String address;
  final DeliveryStatus status;
  final String? failureReason;
  const Delivery(
      {required this.id,
      required this.storeName,
      required this.address,
      required this.status,
      this.failureReason});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['store_name'] = Variable<String>(storeName);
    map['address'] = Variable<String>(address);
    {
      map['status'] =
          Variable<String>($DeliveriesTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || failureReason != null) {
      map['failure_reason'] = Variable<String>(failureReason);
    }
    return map;
  }

  DeliveriesCompanion toCompanion(bool nullToAbsent) {
    return DeliveriesCompanion(
      id: Value(id),
      storeName: Value(storeName),
      address: Value(address),
      status: Value(status),
      failureReason: failureReason == null && nullToAbsent
          ? const Value.absent()
          : Value(failureReason),
    );
  }

  factory Delivery.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Delivery(
      id: serializer.fromJson<int>(json['id']),
      storeName: serializer.fromJson<String>(json['storeName']),
      address: serializer.fromJson<String>(json['address']),
      status: $DeliveriesTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      failureReason: serializer.fromJson<String?>(json['failureReason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'storeName': serializer.toJson<String>(storeName),
      'address': serializer.toJson<String>(address),
      'status': serializer
          .toJson<String>($DeliveriesTable.$converterstatus.toJson(status)),
      'failureReason': serializer.toJson<String?>(failureReason),
    };
  }

  Delivery copyWith(
          {int? id,
          String? storeName,
          String? address,
          DeliveryStatus? status,
          Value<String?> failureReason = const Value.absent()}) =>
      Delivery(
        id: id ?? this.id,
        storeName: storeName ?? this.storeName,
        address: address ?? this.address,
        status: status ?? this.status,
        failureReason:
            failureReason.present ? failureReason.value : this.failureReason,
      );
  Delivery copyWithCompanion(DeliveriesCompanion data) {
    return Delivery(
      id: data.id.present ? data.id.value : this.id,
      storeName: data.storeName.present ? data.storeName.value : this.storeName,
      address: data.address.present ? data.address.value : this.address,
      status: data.status.present ? data.status.value : this.status,
      failureReason: data.failureReason.present
          ? data.failureReason.value
          : this.failureReason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Delivery(')
          ..write('id: $id, ')
          ..write('storeName: $storeName, ')
          ..write('address: $address, ')
          ..write('status: $status, ')
          ..write('failureReason: $failureReason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, storeName, address, status, failureReason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Delivery &&
          other.id == this.id &&
          other.storeName == this.storeName &&
          other.address == this.address &&
          other.status == this.status &&
          other.failureReason == this.failureReason);
}

class DeliveriesCompanion extends UpdateCompanion<Delivery> {
  final Value<int> id;
  final Value<String> storeName;
  final Value<String> address;
  final Value<DeliveryStatus> status;
  final Value<String?> failureReason;
  const DeliveriesCompanion({
    this.id = const Value.absent(),
    this.storeName = const Value.absent(),
    this.address = const Value.absent(),
    this.status = const Value.absent(),
    this.failureReason = const Value.absent(),
  });
  DeliveriesCompanion.insert({
    this.id = const Value.absent(),
    required String storeName,
    required String address,
    required DeliveryStatus status,
    this.failureReason = const Value.absent(),
  })  : storeName = Value(storeName),
        address = Value(address),
        status = Value(status);
  static Insertable<Delivery> custom({
    Expression<int>? id,
    Expression<String>? storeName,
    Expression<String>? address,
    Expression<String>? status,
    Expression<String>? failureReason,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeName != null) 'store_name': storeName,
      if (address != null) 'address': address,
      if (status != null) 'status': status,
      if (failureReason != null) 'failure_reason': failureReason,
    });
  }

  DeliveriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? storeName,
      Value<String>? address,
      Value<DeliveryStatus>? status,
      Value<String?>? failureReason}) {
    return DeliveriesCompanion(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      address: address ?? this.address,
      status: status ?? this.status,
      failureReason: failureReason ?? this.failureReason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $DeliveriesTable.$converterstatus.toSql(status.value));
    }
    if (failureReason.present) {
      map['failure_reason'] = Variable<String>(failureReason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeliveriesCompanion(')
          ..write('id: $id, ')
          ..write('storeName: $storeName, ')
          ..write('address: $address, ')
          ..write('status: $status, ')
          ..write('failureReason: $failureReason')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _deliveryIdMeta =
      const VerificationMeta('deliveryId');
  @override
  late final GeneratedColumn<int> deliveryId = GeneratedColumn<int>(
      'delivery_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES deliveries (id)'));
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, deliveryId, productName, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('delivery_id')) {
      context.handle(
          _deliveryIdMeta,
          deliveryId.isAcceptableOrUnknown(
              data['delivery_id']!, _deliveryIdMeta));
    } else if (isInserting) {
      context.missing(_deliveryIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      deliveryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}delivery_id'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int deliveryId;
  final String productName;
  final int quantity;
  const OrderItem(
      {required this.id,
      required this.deliveryId,
      required this.productName,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['delivery_id'] = Variable<int>(deliveryId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      deliveryId: Value(deliveryId),
      productName: Value(productName),
      quantity: Value(quantity),
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      deliveryId: serializer.fromJson<int>(json['deliveryId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deliveryId': serializer.toJson<int>(deliveryId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  OrderItem copyWith(
          {int? id, int? deliveryId, String? productName, int? quantity}) =>
      OrderItem(
        id: id ?? this.id,
        deliveryId: deliveryId ?? this.deliveryId,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
      );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      deliveryId:
          data.deliveryId.present ? data.deliveryId.value : this.deliveryId,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('deliveryId: $deliveryId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deliveryId, productName, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.deliveryId == this.deliveryId &&
          other.productName == this.productName &&
          other.quantity == this.quantity);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> deliveryId;
  final Value<String> productName;
  final Value<int> quantity;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.deliveryId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int deliveryId,
    required String productName,
    required int quantity,
  })  : deliveryId = Value(deliveryId),
        productName = Value(productName),
        quantity = Value(quantity);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? deliveryId,
    Expression<String>? productName,
    Expression<int>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deliveryId != null) 'delivery_id': deliveryId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
    });
  }

  OrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? deliveryId,
      Value<String>? productName,
      Value<int>? quantity}) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      deliveryId: deliveryId ?? this.deliveryId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deliveryId.present) {
      map['delivery_id'] = Variable<int>(deliveryId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('deliveryId: $deliveryId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DeliveriesTable deliveries = $DeliveriesTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [deliveries, orderItems];
}

typedef $$DeliveriesTableCreateCompanionBuilder = DeliveriesCompanion Function({
  Value<int> id,
  required String storeName,
  required String address,
  required DeliveryStatus status,
  Value<String?> failureReason,
});
typedef $$DeliveriesTableUpdateCompanionBuilder = DeliveriesCompanion Function({
  Value<int> id,
  Value<String> storeName,
  Value<String> address,
  Value<DeliveryStatus> status,
  Value<String?> failureReason,
});

final class $$DeliveriesTableReferences
    extends BaseReferences<_$AppDatabase, $DeliveriesTable, Delivery> {
  $$DeliveriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName:
              $_aliasNameGenerator(db.deliveries.id, db.orderItems.deliveryId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.deliveryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DeliveriesTableFilterComposer
    extends Composer<_$AppDatabase, $DeliveriesTable> {
  $$DeliveriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storeName => $composableBuilder(
      column: $table.storeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DeliveryStatus, DeliveryStatus, String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get failureReason => $composableBuilder(
      column: $table.failureReason, builder: (column) => ColumnFilters(column));

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.deliveryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DeliveriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeliveriesTable> {
  $$DeliveriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storeName => $composableBuilder(
      column: $table.storeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get failureReason => $composableBuilder(
      column: $table.failureReason,
      builder: (column) => ColumnOrderings(column));
}

class $$DeliveriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeliveriesTable> {
  $$DeliveriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeName =>
      $composableBuilder(column: $table.storeName, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DeliveryStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get failureReason => $composableBuilder(
      column: $table.failureReason, builder: (column) => column);

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.deliveryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DeliveriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DeliveriesTable,
    Delivery,
    $$DeliveriesTableFilterComposer,
    $$DeliveriesTableOrderingComposer,
    $$DeliveriesTableAnnotationComposer,
    $$DeliveriesTableCreateCompanionBuilder,
    $$DeliveriesTableUpdateCompanionBuilder,
    (Delivery, $$DeliveriesTableReferences),
    Delivery,
    PrefetchHooks Function({bool orderItemsRefs})> {
  $$DeliveriesTableTableManager(_$AppDatabase db, $DeliveriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeliveriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeliveriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeliveriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> storeName = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<DeliveryStatus> status = const Value.absent(),
            Value<String?> failureReason = const Value.absent(),
          }) =>
              DeliveriesCompanion(
            id: id,
            storeName: storeName,
            address: address,
            status: status,
            failureReason: failureReason,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String storeName,
            required String address,
            required DeliveryStatus status,
            Value<String?> failureReason = const Value.absent(),
          }) =>
              DeliveriesCompanion.insert(
            id: id,
            storeName: storeName,
            address: address,
            status: status,
            failureReason: failureReason,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DeliveriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Delivery, $DeliveriesTable,
                            OrderItem>(
                        currentTable: table,
                        referencedTable: $$DeliveriesTableReferences
                            ._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DeliveriesTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.deliveryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DeliveriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DeliveriesTable,
    Delivery,
    $$DeliveriesTableFilterComposer,
    $$DeliveriesTableOrderingComposer,
    $$DeliveriesTableAnnotationComposer,
    $$DeliveriesTableCreateCompanionBuilder,
    $$DeliveriesTableUpdateCompanionBuilder,
    (Delivery, $$DeliveriesTableReferences),
    Delivery,
    PrefetchHooks Function({bool orderItemsRefs})>;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int deliveryId,
  required String productName,
  required int quantity,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> deliveryId,
  Value<String> productName,
  Value<int> quantity,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DeliveriesTable _deliveryIdTable(_$AppDatabase db) =>
      db.deliveries.createAlias(
          $_aliasNameGenerator(db.orderItems.deliveryId, db.deliveries.id));

  $$DeliveriesTableProcessedTableManager get deliveryId {
    final $_column = $_itemColumn<int>('delivery_id')!;

    final manager = $$DeliveriesTableTableManager($_db, $_db.deliveries)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deliveryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  $$DeliveriesTableFilterComposer get deliveryId {
    final $$DeliveriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deliveryId,
        referencedTable: $db.deliveries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeliveriesTableFilterComposer(
              $db: $db,
              $table: $db.deliveries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  $$DeliveriesTableOrderingComposer get deliveryId {
    final $$DeliveriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deliveryId,
        referencedTable: $db.deliveries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeliveriesTableOrderingComposer(
              $db: $db,
              $table: $db.deliveries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$DeliveriesTableAnnotationComposer get deliveryId {
    final $$DeliveriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deliveryId,
        referencedTable: $db.deliveries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DeliveriesTableAnnotationComposer(
              $db: $db,
              $table: $db.deliveries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool deliveryId})> {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> deliveryId = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<int> quantity = const Value.absent(),
          }) =>
              OrderItemsCompanion(
            id: id,
            deliveryId: deliveryId,
            productName: productName,
            quantity: quantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int deliveryId,
            required String productName,
            required int quantity,
          }) =>
              OrderItemsCompanion.insert(
            id: id,
            deliveryId: deliveryId,
            productName: productName,
            quantity: quantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({deliveryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (deliveryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.deliveryId,
                    referencedTable:
                        $$OrderItemsTableReferences._deliveryIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._deliveryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool deliveryId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DeliveriesTableTableManager get deliveries =>
      $$DeliveriesTableTableManager(_db, _db.deliveries);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
}
