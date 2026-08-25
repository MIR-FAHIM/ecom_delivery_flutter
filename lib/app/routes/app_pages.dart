
import 'package:ecom_delivery_flutter/app/modules/auth/login/bindings/login_binding.dart';
import 'package:ecom_delivery_flutter/app/modules/auth/login/views/login_view.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/binding/delivery_binding.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/assigned_delivery_view.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/completed_delivery_view.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/deliveredOrder.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/my_delivery_tab.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/order_detail_view.dart';
import 'package:ecom_delivery_flutter/app/modules/delivery/view/pending_delivery_view.dart';


import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;
  // static const INITIAL = Routes.Test;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),


    GetPage(
      name: _Paths.ROOT,
      page: () => RootView(),
      binding: RootBinding(),
    ),

    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => SplashscreenView(),
      binding: SplashscreenBinding(),
    ),

GetPage(
      name: _Paths.ALL_DELIVERY_ORDER,
      page: () => AssignedAllDeliveryView(),
      binding: DeliveryBinding(),
    ),
GetPage(
      name: _Paths.Completed_DELIVERY_ORDER,
      page: () => CompletedDeliveryView(),
      binding: DeliveryBinding(),
    ),
GetPage(
      name: _Paths.Pending_DELIVERY_ORDER,
      page: () => PendingDeliveryView(status: 'assigned',),
      binding: DeliveryBinding(),
    ),
GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => OrderDetailView(),
      binding: DeliveryBinding(),
    ),
GetPage(
      name: _Paths.DELIVERED_ORDER,
      page: () => Deliveredorder(),
      binding: DeliveryBinding(),
    ),
GetPage(
      name: _Paths.MY_DELIVERY,
      page: () => MyDeliveryTabView(),
      binding: DeliveryBinding(),
    ),








  ];
}
