import 'package:ecom_delivery_flutter/app/modules/delivery/controller/delivery_controller.dart';
import 'package:get/get.dart';
import 'package:ecom_delivery_flutter/app/modules/home/controllers/home_controller.dart';



class DeliveryBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<DeliveryController>(
          () => DeliveryController(),
    );



  }
}
