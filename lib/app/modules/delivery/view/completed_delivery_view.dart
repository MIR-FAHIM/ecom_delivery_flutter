import 'package:ecom_delivery_flutter/app/modules/delivery/controller/delivery_controller.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/widgets/change_status.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/widgets/empty_state.dart' show EmptyState;
import 'package:ecom_delivery_flutter/app/modules/delivery/view/widgets/key_value.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/widgets/status_chip.dart';
import 'package:ecom_delivery_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletedDeliveryView extends GetView<DeliveryController> {
  CompletedDeliveryView({Key? key}) : super(key: key);

  final _size = Get.size;

  @override
  Widget build(BuildContext context) {
    // Trigger fetch after first frame (safe inside build for GetX pages)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Avoid spamming API when rebuild happens
      if (controller.completedAllDelivery.isEmpty && controller.isLoadingCom.isFalse) {
        controller.completedAllDeliveryController();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        title: const Text("Completed Orders"),
        centerTitle: true,
      ),
      body: SizedBox(
        height: _size.height,
        width: _size.width,
        child: Obx(()
        {
          if (controller.isLoadingCom.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = controller.completedAllDelivery;

          if (list.isEmpty) {
            return EmptyState(
              onRefresh: controller.completedAllDeliveryController,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              controller.completedAllDeliveryController();
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = list[index];
                final order = item.order;

                return _DeliveryOrderCard(
                  orderId: order!.id.toString(),
                  orderNumber: order!.orderNumber!,
                  orderStatus: order!.status!,
                  paymentStatus: order!.paymentStatus!,
                  customerName: order.customerName!,
                  customerPhone: order.customerPhone!,
                  address: order.shippingAddress!,
                  zone: order!.zone!,
                  total: order!.total!,
                  createdAt: order.createdAt!,
                  deliveryStatus: item.status!,
                  onTap: () {
                    controller.orderId.value = order.id;

                    controller.orderDetail();


                    // Navigate to details page (adjust route + args to your app)
                    // Get.toNamed(Routes.DELIVERY_ORDER_DETAILS, arguments: item);
                  },
                  onCall: () {
                    // If you have phone dialer util in ui.dart, call it here
                    // Ui.launchCaller(order.customerPhone);
                  },
                  onMap: () {
                    // If lat/lon exist you can launch map
                    // Ui.launchMap(lat: order.lat, lon: order.lon);
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

/// CARD UI

class _DeliveryOrderCard extends StatelessWidget {
  const _DeliveryOrderCard({
    required this.orderNumber,
    required this.orderId,
    required this.orderStatus,
    required this.paymentStatus,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.zone,
    required this.total,
    required this.createdAt,
    required this.deliveryStatus,
    this.onTap,
    this.onCall,
    this.onMap,
  });

  final String orderNumber;
  final String orderId;
  final String orderStatus;
  final String paymentStatus;
  final String customerName;
  final String customerPhone;
  final String address;
  final String zone;
  final double total;
  final DateTime createdAt;
  final String deliveryStatus;

  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DeliveryController controller = DeliveryController();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Order Number + Status chip
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "#$orderNumber",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(
                    label: _prettyStatus(deliveryStatus),
                    color: _statusColor(deliveryStatus),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Customer
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 18, color: Colors.black54),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      customerName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Phone
              Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 18, color: Colors.black54),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      customerPhone,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Address + Zone
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 18, color: Colors.black54),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      address,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black87,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.map_outlined, size: 18, color: Colors.black54),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      zone,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Expanded(
                    child: Text(
                        _fmtDate(createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade200, height: 1),
              const SizedBox(height: 12),

              // Bottom metrics: Total + Payment + Order status + Created
              Row(
                children: [
                  Expanded(
                    child: KeyValue(
                      label: "Total",
                      value: "\$${total.toString()}",
                      icon: Icons.payments_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KeyValue(
                      label: "Payment",
                      value: _prettyStatus(paymentStatus),
                      icon: Icons.verified_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: KeyValue(
                      label: "Order",
                      value: _prettyStatus(orderStatus),
                      icon: Icons.receipt_long_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: changeStatus(
                      label: controller.nextStatus(orderStatus),
                      currentOrderStatus: orderStatus,
                      orderId: orderId,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              if (onCall != null || onMap != null) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (onCall != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onCall,
                          icon: const Icon(Icons.call_outlined, size: 18),
                          label: const Text("Call"),
                        ),
                      ),
                    if (onCall != null && onMap != null) const SizedBox(width: 10),
                    if (onMap != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onMap,
                          icon: const Icon(Icons.directions_outlined, size: 18),
                          label: const Text("Map"),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}







/// HELPERS (no intl dependency)

String _fmtDate(DateTime dt) {
  String two(int v) => v < 10 ? "0$v" : "$v";
  final y = dt.year.toString();
  final m = two(dt.month);
  final d = two(dt.day);
  final hh = two(dt.hour);
  final mm = two(dt.minute);
  return "$y-$m-$d $hh:$mm";
}

String _prettyStatus(String s) {
  final v = s.trim().replaceAll("_", " ").replaceAll("-", " ");
  if (v.isEmpty) return "-";
  return v.split(" ").map((w) {
    if (w.isEmpty) return w;
    final lower = w.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }).join(" ");
}

Color _statusColor(String s) {
  final v = s.toLowerCase();
  if (v.contains("delivered")) return Colors.green;
  if (v.contains("cancel")) return Colors.red;
  if (v.contains("pending")) return Colors.orange;
  if (v.contains("processing")) return Colors.blue;
  if (v.contains("picked") || v.contains("pickup")) return Colors.purple;
  return Colors.teal;
}
