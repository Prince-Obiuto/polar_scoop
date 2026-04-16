import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'deliveries_provider.dart'; // Make sure this path is correct

class DeliveryDetailScreen extends ConsumerWidget {
  final int deliveryId;
  const DeliveryDetailScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Feature 3 & 4: Watching the two specific family providers
    final deliveryAsync = ref.watch(deliveryByIdProvider(deliveryId));
    final itemsAsync = ref.watch(orderItemsProvider(deliveryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: deliveryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (delivery) {
          return Column(
            children: [
              // Store Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.blueGrey[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(delivery.storeName,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(delivery.address,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              // Items List
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('ORDER ITEMS',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: itemsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text('Error loading items: $err'),
                  data: (items) => ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: const Icon(Icons.icecream),
                        title: Text(item.productName),
                        trailing: Text('x${item.quantity}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _handleUpdate(context, ref, isSuccess: false),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'FAILED',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleUpdate(context, ref, isSuccess: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'DELIVERED',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleUpdate(BuildContext context, WidgetRef ref,
      {required bool isSuccess}) async {
    // Using ref.read for the action service as defined in your SECTION 5
    final service = ref.read(deliveryActionsProvider);

    if (isSuccess) {
      await service.markDelivered(deliveryId);
    } else {
      await service.markFailed(deliveryId, reason: "Store Closed");
    }

    if (context.mounted) {
      context.pop(); // Returns to the list screen
    }
  }
}
