import 'package:ecom_delivery_flutter/app/modules/delivery/controller/delivery_controller.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/widgets/change_status.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/widgets/empty_state.dart';
import 'package:ecom_delivery_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignedAllDeliveryView extends GetView<DeliveryController> {
  const AssignedAllDeliveryView({Key? key}) : super(key: key);

  static const Color _primary = Color(0xFF2563EB);
  static const Color _secondary = Color(0xFF10B981);
  static const Color _warning = Color(0xFFF59E0B);
  static const Color _danger = Color(0xFFEF4444);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _surface = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.deliveryOrder.isEmpty &&
          controller.isLoadingAssigned.isFalse) {
        controller.assignedDelivery();
      }
    });

    return Scaffold(
      backgroundColor: _surface,
      body: Obx(() {
        if (controller.isLoadingAssigned.value) {
          return const _AssignedLoadingView();
        }

        final list = controller.deliveryOrder;

        if (list.isEmpty) {
          return SafeArea(
            child: EmptyState(
              onRefresh: controller.assignedDelivery,
            ),
          );
        }

        final totalOrders = list.length;
        final pendingOrders = list.where((e) {
          return e.status.toString().toLowerCase().contains('pending');
        }).length;
        final activeOrders = list.where((e) {
          final status = e.status.toString().toLowerCase();
          return status.contains('processing') ||
              status.contains('assigned') ||
              status.contains('picked') ||
              status.contains('pickup');
        }).length;

        return RefreshIndicator(
          color: _primary,
          onRefresh: () async => controller.assignedDelivery(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                expandedHeight: 190,
                backgroundColor: _primary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: Get.back,
                ),
                title: Text(
                  'Assigned Orders'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: _AssignedHeader(
                    totalOrders: totalOrders,
                    pendingOrders: pendingOrders,
                    activeOrders: activeOrders,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
                sliver: SliverList.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final order = item.order;

                    return _DeliveryOrderCard(
                      orderId: order!.id!.toString(),
                      orderNumber: order!.orderNumber!,
                      orderStatus: order.status!,
                      paymentStatus: order.paymentStatus!,
                      customerName: order.customerName!,
                      customerPhone: order.customerPhone!,
                      address: order.shippingAddress!,
                      zone: order.zone!,
                      total: order.total!,
                      createdAt: order.createdAt!,
                      deliveryStatus: item.status!,
                      nextStatusLabel: controller.nextStatus(order.status!),
                      onTap: () {
                        controller.orderId.value = order.id!;
                        controller.orderDetail();
                      },
                      onCall: () {
                        // Add your call launcher here if available.
                        // Ui.launchCaller(order.customerPhone);
                      },
                      onMap: () {
                        // Add your map launcher here if lat/lon are available.
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _AssignedHeader extends StatelessWidget {
  const _AssignedHeader({
    required this.totalOrders,
    required this.pendingOrders,
    required this.activeOrders,
  });

  final int totalOrders;
  final int pendingOrders;
  final int activeOrders;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1D4ED8),
            Color(0xFF2563EB),
            Color(0xFF0F766E),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -35,
            child: _SoftCircle(
              size: 150,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Positioned(
            bottom: -55,
            left: -30,
            child: _SoftCircle(
              size: 170,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.20),
                            ),
                          ),
                          child: const Icon(
                            Icons.delivery_dining_rounded,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today\'s Delivery Queue'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Manage assigned orders quickly'.tr,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.82),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _HeaderMetric(
                            label: 'Total'.tr,
                            value: totalOrders.toString(),
                            icon: Icons.receipt_long_rounded,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _HeaderMetric(
                            label: 'Active'.tr,
                            value: activeOrders.toString(),
                            icon: Icons.local_shipping_rounded,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _HeaderMetric(
                            label: 'Pending'.tr,
                            value: pendingOrders.toString(),
                            icon: Icons.schedule_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
    required this.nextStatusLabel,
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
  final String nextStatusLabel;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onMap;

  @override
  Widget build(BuildContext context) {
    final deliveryColor = _statusColor(deliveryStatus);
    final paymentColor = _paymentColor(paymentStatus);
    final orderColor = _statusColor(orderStatus);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        deliveryColor.withOpacity(0.95),
                        deliveryColor.withOpacity(0.72),
                      ],
                    ),
                  ),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#$orderNumber',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _fmtDate(createdAt),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.86),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 5),
                        _WhiteStatusChip(label: _prettyStatus(deliveryStatus)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CustomerAvatar(name: customerName),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF111827),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _InlineInfo(
                                  icon: Icons.phone_rounded,
                                  text: customerPhone,
                                  color: const Color(0xFF2563EB),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _TotalBadge(total: total),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _AddressBox(address: address, zone: zone),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          Expanded(
                            child: _CompactStatusBox(
                              label: 'Payment'.tr,
                              value: _prettyStatus(paymentStatus),
                              icon: Icons.verified_rounded,
                              color: paymentColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _CompactStatusBox(
                              label: 'Order'.tr,
                              value: _prettyStatus(orderStatus),
                              icon: Icons.receipt_long_rounded,
                              color: orderColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          Expanded(
                            child: changeStatus(
                              label: nextStatusLabel,
                              orderId: orderId,
                              currentOrderStatus: orderStatus,
                              color: AssignedAllDeliveryView._secondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          _CircleActionButton(
                            icon: Icons.call_rounded,
                            color: AssignedAllDeliveryView._primary,
                            onTap: onCall,
                          ),
                          const SizedBox(width: 8),
                          _CircleActionButton(
                            icon: Icons.near_me_rounded,
                            color: AssignedAllDeliveryView._purple,
                            onTap: onMap,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomerAvatar extends StatelessWidget {
  const _CustomerAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDBEAFE), Color(0xFFE0F2FE)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: Color(0xFF1D4ED8),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TotalBadge extends StatelessWidget {
  const _TotalBadge({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Total'.tr,
            style: const TextStyle(
              color: Color(0xFF047857),
              fontSize: 10.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _money(total),
            style: const TextStyle(
              color: Color(0xFF065F46),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressBox extends StatelessWidget {
  const _AddressBox({required this.address, required this.zone});

  final String address;
  final String zone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          _InlineInfo(
            icon: Icons.location_on_rounded,
            text: address,
            color: AssignedAllDeliveryView._danger,
          ),
          const SizedBox(height: 7),
          _InlineInfo(
            icon: Icons.map_rounded,
            text: zone,
            color: AssignedAllDeliveryView._warning,
          ),
        ],
      ),
    );
  }
}

class _CompactStatusBox extends StatelessWidget {
  const _CompactStatusBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteStatusChip extends StatelessWidget {
  const _WhiteStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.24)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey.shade100 : color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: onTap == null ? Colors.grey.shade200 : color.withOpacity(0.22),
          ),
        ),
        child: Icon(
          icon,
          color: onTap == null ? Colors.grey.shade400 : color,
          size: 20,
        ),
      ),
    );
  }
}

class _AssignedLoadingView extends StatelessWidget {
  const _AssignedLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 34,
        height: 34,
        child: CircularProgressIndicator(strokeWidth: 2.6),
      ),
    );
  }
}

String _fmtDate(DateTime dt) {
  String two(int v) => v < 10 ? '0$v' : '$v';
  return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
}

String _money(double value) {
  return '৳$value';
}

String _prettyStatus(String s) {
  final v = s.trim().replaceAll('_', ' ').replaceAll('-', ' ');
  if (v.isEmpty) return '-';

  return v.split(' ').map((word) {
    if (word.isEmpty) return word;
    final lower = word.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }).join(' ');
}

Color _statusColor(String s) {
  final v = s.toLowerCase();

  if (v.contains('delivered') || v.contains('completed')) {
    return const Color(0xFF10B981);
  }
  if (v.contains('cancel') || v.contains('failed')) {
    return const Color(0xFFEF4444);
  }
  if (v.contains('pending')) {
    return const Color(0xFFF59E0B);
  }
  if (v.contains('processing')) {
    return const Color(0xFF2563EB);
  }
  if (v.contains('assigned')) {
    return const Color(0xFF7C3AED);
  }
  if (v.contains('picked') || v.contains('pickup')) {
    return const Color(0xFF0891B2);
  }

  return const Color(0xFF0F766E);
}

Color _paymentColor(String s) {
  final v = s.toLowerCase();

  if (v.contains('paid') || v.contains('success')) {
    return const Color(0xFF10B981);
  }
  if (v.contains('unpaid') || v.contains('due') || v.contains('pending')) {
    return const Color(0xFFF59E0B);
  }
  if (v.contains('fail') || v.contains('cancel')) {
    return const Color(0xFFEF4444);
  }

  return const Color(0xFF2563EB);
}
