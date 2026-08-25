import 'package:ecom_delivery_flutter/app/modules/delivery/view/pending_delivery_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_delivery_flutter/common/Color.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/controller/delivery_controller.dart';

class MyDeliveryTabView extends GetView<DeliveryController> {
  MyDeliveryTabView({Key? key}) : super(key: key);

  final _tabs = const [
    _TabSpec(title: "New", icon: Icons.fiber_new_outlined),
    _TabSpec(title: "Picked", icon: Icons.inventory_2_outlined),
    _TabSpec(title: "On the way", icon: Icons.local_shipping_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          title: const Text("My Deliveries"),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                splashBorderRadius: BorderRadius.circular(999),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Colors.grey.shade100,
                ),
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                tabs: _tabs
                    .map(
                      (t) => Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(t.icon, size: 18),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            t.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ),
        body:  TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            PendingDeliveryView(status: "assigned"),
            PendingDeliveryView(status: "picked"),
            PendingDeliveryView(status: "on the way"),
          ],
        ),
      ),
    );
  }
}

class _TabSpec {
  final String title;
  final IconData icon;
  const _TabSpec({required this.title, required this.icon});
}




