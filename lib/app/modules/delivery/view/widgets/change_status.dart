import 'package:ecom_delivery_flutter/app/modules/delivery/controller/delivery_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class changeStatus extends GetWidget<DeliveryController> {
  const changeStatus({
    super.key,
    required this.label,
    required this.color,
    required this.orderId,
    required this.currentOrderStatus,
  });

  final String label;
  final String orderId;
  final String currentOrderStatus;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final parsedOrderId = int.tryParse(orderId) ?? 0;

    if (parsedOrderId == 0 ||
        label.trim().isEmpty ||
        controller.isFinalOrderStatus(currentOrderStatus)) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final isLoading = controller.changingOrderId.value == parsedOrderId;

      return InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: isLoading
            ? null
            : () {
          controller.changeDeliveryStatus(
            orderId: parsedOrderId,
            status: label,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withOpacity(0.35), width: 1),
          ),
          child: isLoading
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Column(
            children: [
              const Text(
                'Change Status to',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
