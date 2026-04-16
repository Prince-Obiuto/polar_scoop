import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import 'deliveries_provider.dart';

class DeliveryListScreen extends ConsumerWidget {
  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the reactive Drift stream via Riverpod
    final deliveriesAsync = ref.watch(deliveriesListProvider);
    final today = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today\'s Route',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(today,
                style: const TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: deliveriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading deliveries: $err')),
        data: (deliveries) {
          if (deliveries.isEmpty) {
            return const Center(
                child: Text('No deliveries assigned for today!',
                    style: TextStyle(fontSize: 18)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              final delivery = deliveries[index];
              return _DeliveryCard(delivery: delivery);
            },
          );
        },
      ),
    );
  }
}

// Delivery List using glassmorphism-lite
class _DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  const _DeliveryCard({required this.delivery});

  @override
  Widget build(BuildContext context) {
    final bool isDone = delivery.status != DeliveryStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () => context.push('/deliveries/${delivery.id}'),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(delivery.status).withOpacity(0.1),
          radius: 28,
          child: Icon(_getStatusIcon(delivery.status),
              color: _getStatusColor(delivery.status), size: 30),
        ),
        title: Text(delivery.storeName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(delivery.address,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(delivery.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(delivery.status.name.toUpperCase(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(delivery.status))),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Colors.grey),
      ),
    );
  }

  Color _getStatusColor(DeliveryStatus s) {
    if (s == DeliveryStatus.delivered) return Colors.green;
    if (s == DeliveryStatus.failed) return Colors.red;
    return Colors.orange;
  }

  IconData _getStatusIcon(DeliveryStatus s) {
    if (s == DeliveryStatus.delivered) return Icons.check_circle_rounded;
    if (s == DeliveryStatus.failed) return Icons.error_rounded;
    return Icons.local_shipping_rounded;
  }
}
