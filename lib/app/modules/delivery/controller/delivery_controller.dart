import 'package:ecom_delivery_flutter/app/models/delivery/completed_delivery_model.dart';
import 'package:ecom_delivery_flutter/app/models/delivery/delivery_model.dart';
import 'package:ecom_delivery_flutter/app/models/delivery/delivery_report.dart';
import 'package:ecom_delivery_flutter/app/models/delivery/order_detail.dart';
import 'package:ecom_delivery_flutter/app/models/profile_model.dart';

import 'package:ecom_delivery_flutter/app/repositories/auth_repositories.dart';
import 'package:ecom_delivery_flutter/app/repositories/delivery_rep.dart';
import 'package:ecom_delivery_flutter/app/repositories/order_rep.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ecom_delivery_flutter/app/modules/settings/controllers/language_controller.dart';

import 'package:ecom_delivery_flutter/app/routes/app_pages.dart';
import 'package:ecom_delivery_flutter/app/services/auth_service.dart';
import 'package:ecom_delivery_flutter/common/ui.dart';
import 'package:ecom_delivery_flutter/main.dart';
import 'package:ecom_delivery_flutter/service/shared_pref.dart';

class DeliveryController extends GetxController {
  //TODO: Implement HomeController

  final balance = '0.0'.obs;
  final phoneController = TextEditingController().obs;
  final outletNameController = TextEditingController().obs;
  final ownerController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final status = false.obs;

  final isLoadingAssigned = false.obs;
  final isLoadingCom = false.obs;
  final isLoadingDetail = false.obs;
  final packageLoad = false.obs;
  final orderStatusFlow = <String>[
    'Pending',
    'Confirmed',
    'Processing',
    'Packed',
    'Shipped',
    'Out for Delivery',
    'Delivered',
    'Completed',
  ];
  final changingOrderId = 0.obs;
  final userID = 0.obs;
  final orderId = 0.obs;

  final box = GetStorage().obs;

  final deliveryOrder = <DatumDeOrder>[].obs;
  final completedAllDelivery = <CompletedDeliveryData>[].obs;
  final deliveredDelivery = <DatumDeOrder>[].obs;
  final orderDetails = OrderDetailsModel().obs;
  final deliveryReport = DeliveryReportModel().obs;

  @override
  Future<void> onInit() async {
    userID.value = Get.find<AuthService>().currentUser.value.data!.user.id;

    assignedDelivery();
    completedAllDeliveryController();
    deliveredDeliveryController();
    super.onInit();
    print('HomeController.onInit');
  }

  Future refreshHome() async {}

  @override
  void onReady() {
    // TODO: implement onReady

    super.onReady();
  }
  String nextStatus(String current) {
    final normalized = _normalizeStatus(current);

    if (normalized == 'assigned deliveryman' || normalized == 'assigned') {
      return 'Out for Delivery';
    }

    final index = orderStatusFlow.indexWhere(
          (e) => _normalizeStatus(e) == normalized,
    );

    if (index == -1 || index >= orderStatusFlow.length - 1) {
      return '';
    }

    return orderStatusFlow[index + 1];
  }

  bool isFinalOrderStatus(String current) {
    final normalized = _normalizeStatus(current);

    return normalized == 'delivered' ||
        normalized == 'completed' ||
        normalized == 'cancelled' ||
        normalized == 'returned' ||
        normalized == 'refunded' ||
        normalized == 'failed';
  }

  String _normalizeStatus(String value) {
    return value.trim().toLowerCase().replaceAll('_', ' ');
  }


  Future<void> assignedDelivery() async {
    isLoadingAssigned.value = true;

    try {
      final e = await DeliveryRepository().assignedDelivery(userID.value.toString());

      if (e['status'] == 'success') {
        final model = DeliveryModel.fromJson(e);
        deliveryOrder.assignAll(model.data?.deliveries ?? []);
      } else {
        deliveryOrder.clear();
      }
    } catch (err) {
      deliveryOrder.clear();
    } finally {
      isLoadingAssigned.value = false;
    }
  }

  completedAllDeliveryController() {
    DeliveryRepository().completedAllDelivery(userID.value.toString()).then((e) {
      print("completed data is $e");
      isLoadingCom.value = true;
      try {
        if (e['status'] == 'success') {

          print("i am here 454");
          CompletedDeliveryResponseModel model = CompletedDeliveryResponseModel.fromJson(e);
          completedAllDelivery.value = model.data!.deliveries!;
          print("i am here 454 565 ${completedAllDelivery.value.length}");

        }
      } catch (err) {
        print("error is 342423 $err");
        completedAllDelivery.value.clear();
      } finally {
        isLoadingCom.value = false;
      }
    });
  }
  assignedDeliveryController() {
    DeliveryRepository().assignedDelivery(userID.value.toString()).then((e) {
      print("DeliveryModel data is $e");
      isLoadingAssigned.value = true;
      try {
        if (e['status'] == 'success') {
          DeliveryModel model = DeliveryModel.fromJson(e);
          deliveryOrder.value = model.data!.deliveries;
        }
      } catch (err) {
        deliveryOrder.value.clear();
      } finally {
        isLoadingAssigned.value = false;
      }
    });
  }
  deliveredDeliveryController() {
    DeliveryRepository().deliveredDelivery(userID.value.toString()).then((e) {
      print("DeliveryModel data is $e");
      isLoadingAssigned.value = true;
      try {
        if (e['status'] == 'success') {
          DeliveryModel model = DeliveryModel.fromJson(e);
          deliveredDelivery.value = model.data!.deliveries;
        }
      } catch (err) {
        deliveredDelivery.value.clear();
      } finally {
        isLoadingAssigned.value = false;
      }
    });
  }

  Future<void> orderDetail() async {
    isLoadingDetail.value = true;
    try {
      final e = await OrderRepository().orderDetail(orderId.value.toString());
      if (e['status'] == 'success') {
        final model = OrderDetailsModel.fromJson(e);
        orderDetails.value = model;

        Get.toNamed(Routes.ORDER_DETAIL);
      } else {
        orderDetails.value = const OrderDetailsModel();
      }
    } catch (_) {
      orderDetails.value = const OrderDetailsModel();
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> changeDeliveryStatus({
    required int orderId,
    required String status,
  }) async {
    if (status.trim().isEmpty) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: 'No next status found.',
          title: 'Error'.tr,
        ),
      );
      return;
    }

    changingOrderId.value = orderId;

    try {
      final e = await OrderRepository().changeOrderStatus(
        orderId.toString(),
        status,
      );

      if (e['status'] == 'success') {
        await assignedDelivery();
        await deliveredDeliveryController();
        await completedAllDeliveryController();

        Get.showSnackbar(
          Ui.SuccessSnackBar(
            message: e['message'] ?? 'Status updated successfully',
            title: 'Success'.tr,
          ),
        );
      } else {
        Get.showSnackbar(
          Ui.ErrorSnackBar(
            message: e['message'] ?? 'Could not update status.',
            title: 'Error'.tr,
          ),
        );
      }
    } catch (e) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: 'Could not update status.',
          title: 'Error'.tr,
        ),
      );
    } finally {
      changingOrderId.value = 0;
    }
  }
}
