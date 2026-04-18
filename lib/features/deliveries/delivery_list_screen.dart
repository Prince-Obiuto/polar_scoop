import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../auth/auth_provider.dart';
import 'deliveries_provider.dart';

class DeliveryListScreen extends ConsumerWidget {
  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the reactive Drift stream from your manual provider
    final deliveriesAsync = ref.watch(deliveriesListProvider);

    // Formatting for the modern header subtitle
    final today = DateFormat('EEEE, d MMMM').format(DateTime.now());

    // Check for Dark Mode to adjust text/background colors
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // We use an empty AppBar to handle the status bar color and the logout button
      appBar: AppBar(
        title: const Text(
          'Polar Scoop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          )
        ],
      ),
      body: Column(
        children: [
          // ── HEADER SECTION ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.blueAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Route',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  today,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // ── DELIVERY LIST SECTION ──
          Expanded(
            child: deliveriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (deliveries) {
                if (deliveries.isEmpty) {
                  return const Center(child: Text('No assigned deliveries.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: deliveries.length,
                  itemBuilder: (context, index) {
                    return _DeliveryCard(
                      delivery: deliveries[index],
                      isDark: isDark,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final bool isDark;

  const _DeliveryCard({
    required this.delivery,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic styling based on delivery status
    final statusColor = _getStatusColor(delivery.status);
    final statusIcon = _getStatusIcon(delivery.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        // Uses Dark Mode colors if system is set to dark
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onTap: () => context.push('/deliveries/${delivery.id}'),

        // Leading Icon with soft circular background
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.15),
          radius: 28,
          child: Icon(statusIcon, color: statusColor, size: 28),
        ),

        title: Text(
          delivery.storeName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              delivery.address,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: isDark ? Colors.grey : Colors.black54),
            ),
            const SizedBox(height: 10),
            // Status Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                delivery.status.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }

  // ── HELPER METHODS ──

  Color _getStatusColor(DeliveryStatus s) {
    switch (s) {
      case DeliveryStatus.delivered:
        return Colors.green;
      case DeliveryStatus.failed:
        return Colors.redAccent;
      case DeliveryStatus.pending:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(DeliveryStatus s) {
    switch (s) {
      case DeliveryStatus.delivered:
        return Icons.check_circle_rounded;
      case DeliveryStatus.failed:
        return Icons.cancel_rounded;
      case DeliveryStatus.pending:
        return Icons.local_shipping_rounded;
    }
  }
}
