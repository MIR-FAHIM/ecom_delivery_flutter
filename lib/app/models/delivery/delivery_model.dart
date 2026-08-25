class DeliveryModel {
  final String? status;
  final String? message;
  final AssignedDeliveryPagination? data;

  DeliveryModel({
    this.status,
    this.message,
    this.data,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? AssignedDeliveryPagination.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class AssignedDeliveryPagination {
  final int? currentPage;
  final List<DatumDeOrder> deliveries;

  final int? from;
  final int? lastPage;
  final int? perPage;
  final int? to;
  final int? total;

  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final String? path;

  AssignedDeliveryPagination({
    this.currentPage,
    this.deliveries = const [],
    this.from,
    this.lastPage,
    this.perPage,
    this.to,
    this.total,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.prevPageUrl,
    this.path,
  });

  factory AssignedDeliveryPagination.fromJson(Map<String, dynamic> json) {
    return AssignedDeliveryPagination(
      currentPage: _toInt(json['current_page']),
      deliveries: json['data'] is List
          ? (json['data'] as List)
          .map((item) => DatumDeOrder.fromJson(
        Map<String, dynamic>.from(item),
      ))
          .toList()
          : [],
      from: _toInt(json['from']),
      lastPage: _toInt(json['last_page']),
      perPage: _toInt(json['per_page']),
      to: _toInt(json['to']),
      total: _toInt(json['total']),
      firstPageUrl: json['first_page_url']?.toString(),
      lastPageUrl: json['last_page_url']?.toString(),
      nextPageUrl: json['next_page_url']?.toString(),
      prevPageUrl: json['prev_page_url']?.toString(),
      path: json['path']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': deliveries.map((item) => item.toJson()).toList(),
      'from': from,
      'last_page': lastPage,
      'per_page': perPage,
      'to': to,
      'total': total,
      'first_page_url': firstPageUrl,
      'last_page_url': lastPageUrl,
      'next_page_url': nextPageUrl,
      'prev_page_url': prevPageUrl,
      'path': path,
    };
  }
}

class DatumDeOrder {
  final int? id;
  final int? deliveryManId;
  final int? orderId;
  final String? status;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AssignedOrder? order;

  DatumDeOrder({
    this.id,
    this.deliveryManId,
    this.orderId,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.order,
  });

  factory DatumDeOrder.fromJson(Map<String, dynamic> json) {
    return DatumDeOrder(
      id: _toInt(json['id']),
      deliveryManId: _toInt(json['delivery_man_id']),
      orderId: _toInt(json['order_id']),
      status: json['status']?.toString(),
      note: json['note']?.toString(),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
      order: json['order'] is Map<String, dynamic>
          ? AssignedOrder.fromJson(json['order'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_man_id': deliveryManId,
      'order_id': orderId,
      'status': status,
      'note': note,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'order': order?.toJson(),
    };
  }
}

class AssignedOrder {
  final int? id;
  final int? userId;
  final String? orderNumber;
  final String? paymentGroupId;
  final String? status;
  final String? paymentStatus;

  final String? customerName;
  final String? customerPhone;
  final String? shippingAddress;

  final String? zone;
  final String? district;
  final String? area;
  final double? lat;
  final double? lon;

  final double? subtotal;
  final double? shippingFee;
  final double? discount;
  final double? total;

  final String? note;
  final String? platform;
  final int? userAddressId;
  final int? isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  AssignedOrder({
    this.id,
    this.userId,
    this.orderNumber,
    this.paymentGroupId,
    this.status,
    this.paymentStatus,
    this.customerName,
    this.customerPhone,
    this.shippingAddress,
    this.zone,
    this.district,
    this.area,
    this.lat,
    this.lon,
    this.subtotal,
    this.shippingFee,
    this.discount,
    this.total,
    this.note,
    this.platform,
    this.userAddressId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AssignedOrder.fromJson(Map<String, dynamic> json) {
    return AssignedOrder(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      orderNumber: json['order_number']?.toString(),
      paymentGroupId: json['payment_group_id']?.toString(),
      status: json['status']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      customerName: json['customer_name']?.toString(),
      customerPhone: json['customer_phone']?.toString(),
      shippingAddress: json['shipping_address']?.toString(),
      zone:json['zone'] == null ? "No Zone" : json['zone']?.toString(),
      district: json['district']?.toString(),
      area: json['area']?.toString(),
      lat: _toDouble(json['lat']),
      lon: _toDouble(json['lon']),
      subtotal: _toDouble(json['subtotal']),
      shippingFee: _toDouble(json['shipping_fee']),
      discount: _toDouble(json['discount']),
      total: _toDouble(json['total']),
      note: json['note']?.toString(),
      platform: json['platform']?.toString(),
      userAddressId: _toInt(json['user_address_id']),
      isActive: _toInt(json['is_active']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'payment_group_id': paymentGroupId,
      'status': status,
      'payment_status': paymentStatus,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'shipping_address': shippingAddress,
      'zone': zone,
      'district': district,
      'area': area,
      'lat': lat,
      'lon': lon,
      'subtotal': subtotal,
      'shipping_fee': shippingFee,
      'discount': discount,
      'total': total,
      'note': note,
      'platform': platform,
      'user_address_id': userAddressId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}


int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;

  final String dateText = value.toString().trim();

  if (dateText.isEmpty) return null;

  return DateTime.tryParse(dateText);
}