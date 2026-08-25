// lib/app/modules/delivery/view/order_detail_view.dart

import 'package:ecom_delivery_flutter/app/models/delivery/order_detail.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/controller/delivery_controller.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/widgets/empty_state.dart';
import 'package:ecom_delivery_flutter/app/repositories/order_rep.dart';
import 'package:ecom_delivery_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailView extends GetView<DeliveryController> {
  OrderDetailView({Key? key}) : super(key: key);

  final _size = Get.size;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.orderDetails.value.data == null &&
          controller.isLoadingDetail.isFalse) {
        controller.orderDetail();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final model = controller.orderDetails.value;
        final data = model.data;

        if (data == null) {
          return EmptyState(onRefresh: controller.orderDetail);
        }

        final delivery = data.deliveryMan;
        final rider = delivery?.deliveryMan;

        return RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async => controller.orderDetail(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                expandedHeight: 210,
                backgroundColor: AppColors.primaryColor,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Get.back(),
                ),
                title: const Text(
                  'Order Details',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: _SmartHeader(
                    orderNumber: data.orderNumber ?? '-',
                    orderStatus: data.status ?? '-',
                    paymentStatus: data.paymentStatus ?? '-',
                    total: data.total ?? 0,
                    createdAt: data.createdAt,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  width: _size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                    child: Column(
                      children: [
                        _CustomerCard(
                          customerName: data.customerName ?? '-',
                          customerPhone: data.customerPhone ?? '-',
                          address: data.shippingAddress ?? '-',
                          zone: data.zone ?? '-',
                        ),
                        const SizedBox(height: 12),
                        if (rider != null) ...[
                          _RiderCard(
                            name: rider.name ?? '-',
                            phone: rider.phone ?? '-',
                            address: rider.address ?? '-',
                            status: delivery?.status ?? '-',
                            onCall: () {
                              // Add your caller function here if needed.
                              // Ui.launchCaller(rider.phone ?? '');
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                        _ItemsCard(items: data.items),
                        const SizedBox(height: 12),
                        _SummaryCard(
                          subtotal: data.subtotal ?? 0,
                          shippingFee: data.shippingFee ?? 0,
                          discount: data.discount ?? 0,
                          total: data.total ?? 0,
                          note: data.note,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// CONTROLLER PATCH
/// Use this version if your current orderDetail function sets loading too late.
extension DeliveryControllerOrderDetailFix on DeliveryController {
  Future<void> orderDetailFixed() async {
    isLoadingDetail.value = true;

    try {
      final response = await OrderRepository().orderDetail(orderId.value.toString());

      if (response['status'] == 'success') {
        orderDetails.value = OrderDetailsModel.fromJson(response);
      } else {
        orderDetails.value = const OrderDetailsModel();
      }
    } catch (_) {
      orderDetails.value = const OrderDetailsModel();
    } finally {
      isLoadingDetail.value = false;
    }
  }
}

class _SmartHeader extends StatelessWidget {
  const _SmartHeader({
    required this.orderNumber,
    required this.orderStatus,
    required this.paymentStatus,
    required this.total,
    required this.createdAt,
  });

  final String orderNumber;
  final String orderStatus;
  final String paymentStatus;
  final int total;
  final DateTime? createdAt;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(orderStatus);
    final paymentColor = _statusColor(paymentStatus);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            const Color(0xFF2563EB),
            const Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -45,
            right: -30,
            child: _GlowCircle(
              size: 140,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -45,
            child: _GlowCircle(
              size: 120,
              color: Colors.greenAccent.withOpacity(0.12),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 86, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.20),
                          ),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '#$orderNumber',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: _HeaderInfoTile(
                          label: 'Total',
                          value: _money(total),
                          icon: Icons.payments_rounded,
                          color: const Color(0xFF22C55E),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _HeaderInfoTile(
                          label: 'Created',
                          value: createdAt == null ? '-' : _fmtDateShort(createdAt!),
                          icon: Icons.calendar_month_rounded,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StatusChip(
                        label: _prettyStatus(orderStatus),
                        color: statusColor,
                        filled: true,
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(
                        label: _prettyStatus(paymentStatus),
                        color: paymentColor,
                        filled: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _HeaderInfoTile extends StatelessWidget {
  const _HeaderInfoTile({
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
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
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

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.zone,
  });

  final String customerName;
  final String customerPhone;
  final String address;
  final String zone;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Customer',
      icon: Icons.person_pin_circle_rounded,
      iconColor: const Color(0xFF2563EB),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Name',
            text: customerName,
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            text: customerPhone,
            color: const Color(0xFF16A34A),
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            text: address,
            color: const Color(0xFFEF4444),
            maxLines: 10,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.map_outlined,
            label: 'Zone',
            text: zone,
            color: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }
}

class _RiderCard extends StatelessWidget {
  const _RiderCard({
    required this.name,
    required this.phone,
    required this.address,
    required this.status,
    this.onCall,
  });

  final String name;
  final String phone;
  final String address;
  final String status;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Delivery Man',
      icon: Icons.delivery_dining_rounded,
      iconColor: const Color(0xFF7C3AED),
      trailing: _StatusChip(
        label: _prettyStatus(status),
        color: _statusColor(status),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'Name',
            text: name,
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  text: phone,
                  color: const Color(0xFF16A34A),
                ),
              ),
              if (onCall != null) ...[
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: onCall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.call_rounded, size: 18),
                  label: const Text(
                    'Call',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            text: address,
            color: const Color(0xFFEF4444),
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.items});

  final List<OrderItem> items;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Order Items',
      icon: Icons.shopping_bag_rounded,
      iconColor: const Color(0xFFF97316),
      trailing: _CountBadge(count: items.length),
      child: Column(
        children: [
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'No items found.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ),
          for (int i = 0; i < items.length; i++) ...[
            _ItemTile(index: i + 1, item: items[i]),
            if (i != items.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: Colors.grey.shade200),
              ),
          ],
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.index,
    required this.item,
  });

  final int index;
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final name = item.productName ?? '-';
    final qty = item.qty ?? 0;
    final unit = item.unitPrice ?? 0;
    final total = item.lineTotal ?? (qty * unit);
    final status = item.status ?? '-';
    final statusColor = _statusColor(status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF97316).withOpacity(0.20),
                const Color(0xFFF59E0B).withOpacity(0.12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.25)),
          ),
          child: Center(
            child: Text(
              '$index',
              style: const TextStyle(
                color: Color(0xFFC2410C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 7),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  _MiniPill(
                    label: 'Qty: $qty',
                    color: const Color(0xFF2563EB),
                  ),
                  _MiniPill(
                    label: 'Unit: ${_money(unit)}',
                    color: const Color(0xFF0891B2),
                  ),
                  _MiniPill(
                    label: 'Total: ${_money(total)}',
                    color: const Color(0xFF16A34A),
                  ),
                  _MiniPill(
                    label: _prettyStatus(status),
                    color: statusColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    this.note,
  });

  final int subtotal;
  final int shippingFee;
  final int discount;
  final int total;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Payment Summary',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: const Color(0xFF16A34A),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: subtotal,
            icon: Icons.receipt_outlined,
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 9),
          _SummaryRow(
            label: 'Shipping',
            value: shippingFee,
            icon: Icons.local_shipping_outlined,
            color: const Color(0xFFF97316),
          ),
          const SizedBox(height: 9),
          _SummaryRow(
            label: 'Discount',
            value: discount,
            icon: Icons.discount_outlined,
            color: const Color(0xFFEF4444),
            isDiscount: true,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF16A34A),
                  Color(0xFF059669),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF16A34A).withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.payments_rounded, color: Colors.white),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Total Payable',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  _money(total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          if (note != null && note!.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            _InfoRow(
              icon: Icons.notes_outlined,
              label: 'Note',
              text: note!,
              color: const Color(0xFF64748B),
              maxLines: 5,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isDiscount = false,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final bool isDiscount;

  @override
  Widget build(BuildContext context) {
    final prefix = isDiscount && value > 0 ? '-' : '';

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          '$prefix${_money(value)}',
          style: TextStyle(
            color: isDiscount && value > 0 ? const Color(0xFFEF4444) : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.child,
    this.title,
    this.icon,
    this.iconColor,
    this.trailing,
  });

  final Widget child;
  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primaryColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.11),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon ?? Icons.info_outline_rounded, color: color, size: 19),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 13),
          ],
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.text,
    required this.color,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String text;
  final Color color;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.055),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withOpacity(0.10)),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF111827),
                    height: 1.28,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
    this.filled = false,
  });

  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? Colors.white.withOpacity(0.92) : color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: filled ? Colors.white.withOpacity(0.70) : color.withOpacity(0.30),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF97316).withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count items',
        style: const TextStyle(
          color: Color(0xFFC2410C),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}

String _fmtDateShort(DateTime dt) {
  String two(int v) => v < 10 ? '0$v' : '$v';
  return '${two(dt.day)}-${two(dt.month)}-${dt.year}';
}

String _money(num value) {
  final normalized = value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
  return '৳$normalized';
}

String _prettyStatus(String s) {
  final value = s.trim().replaceAll('_', ' ').replaceAll('-', ' ');

  if (value.isEmpty) return '-';

  return value.split(' ').map((word) {
    if (word.isEmpty) return word;

    final lower = word.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }).join(' ');
}

Color _statusColor(String s) {
  final value = s.toLowerCase();

  if (value.contains('delivered') || value.contains('completed') || value.contains('paid')) {
    return const Color(0xFF16A34A);
  }

  if (value.contains('cancel') || value.contains('failed') || value.contains('unpaid')) {
    return const Color(0xFFEF4444);
  }

  if (value.contains('pending') || value.contains('waiting')) {
    return const Color(0xFFF59E0B);
  }

  if (value.contains('processing') || value.contains('confirmed')) {
    return const Color(0xFF2563EB);
  }

  if (value.contains('assigned') || value.contains('picked')) {
    return const Color(0xFF7C3AED);
  }

  return const Color(0xFF0891B2);
}
