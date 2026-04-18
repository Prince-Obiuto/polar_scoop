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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
          color: Theme.of(context).colorScheme.primaryContainer,
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
                onPressed: () => _showFailureReasonSheet(context, ref),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: const BorderSide(color: Colors.redAccent, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'FAILED',
                  style: TextStyle(
                    color: Colors.white,
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
                  backgroundColor: Colors.green.shade600,
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
      {required bool isSuccess, String? reason}) async {
    // Using ref.read for the action service as defined in your SECTION 5
    final service = ref.read(deliveryActionsProvider);

    if (isSuccess) {
      await service.markDelivered(deliveryId);
    } else {
      await service.markFailed(deliveryId,
          reason: reason ?? "No reason provided");
    }

    if (context.mounted) {
      context.pop(); // Returns to the list screen
    }
  }

  void _showFailureReasonSheet(BuildContext context, WidgetRef ref) {
    // A comprehensive list of common logistics failure reasons
    final reasons = [
      'Store Closed / Not Open',
      'Damaged Goods',
      'Refused Delivery',
      'Wrong Address',
      'Recipient Unavailable',
      'Other'
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to size itself properly
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Modern drag handle indicator
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  'Select Failure Reason',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Generate the list of selectable reasons
                ...reasons.map((reason) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning_amber_rounded,
                            color: Colors.redAccent, size: 20),
                      ),
                      title: Text(reason,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      trailing: const Icon(Icons.chevron_right_rounded,
                          color: Colors.grey),
                      onTap: () {
                        // 1. Close the bottom sheet
                        Navigator.pop(context);
                        // 2. Execute the database update with the selected reason
                        _handleUpdate(context, ref,
                            isSuccess: false, reason: reason);
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
