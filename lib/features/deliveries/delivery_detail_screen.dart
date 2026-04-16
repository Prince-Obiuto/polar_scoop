import 'package:flutter/material.dart';
class DeliveryDetailScreen extends StatelessWidget {
  const DeliveryDetailScreen({super.key, required this.deliveryId});
  final int deliveryId;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Detail: $deliveryId')));
}
