class CompletedDeliveryResponseModel {
  final String? status;
  final String? message;
  final CompletedDeliveryPagination? data;

  const CompletedDeliveryResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CompletedDeliveryResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CompletedDeliveryResponseModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? CompletedDeliveryPagination.fromJson(
        json['data'] as Map<String, dynamic>,
      )
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

class CompletedDeliveryPagination {
  final int currentPage;
  final List<CompletedDeliveryData> deliveries;
  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String? path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  const CompletedDeliveryPagination({
    this.currentPage = 1,
    this.deliveries = const [],
    this.firstPageUrl,
    this.from,
    this.lastPage = 1,
    this.lastPageUrl,
    this.links = const [],
    this.nextPageUrl,
    this.path,
    this.perPage = 20,
    this.prevPageUrl,
    this.to,
    this.total = 0,
  });

  factory CompletedDeliveryPagination.fromJson(
      Map<String, dynamic> json,
      ) {
    return CompletedDeliveryPagination(
      currentPage: _parseInt(json['current_page'], fallback: 1),
      deliveries: json['data'] is List
          ? (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(CompletedDeliveryData.fromJson)
          .toList()
          : const [],
      firstPageUrl: json['first_page_url']?.toString(),
      from: _parseNullableInt(json['from']),
      lastPage: _parseInt(json['last_page'], fallback: 1),
      lastPageUrl: json['last_page_url']?.toString(),
      links: json['links'] is List
          ? (json['links'] as List)
          .whereType<Map<String, dynamic>>()
          .map(PaginationLink.fromJson)
          .toList()
          : const [],
      nextPageUrl: json['next_page_url']?.toString(),
      path: json['path']?.toString(),
      perPage: _parseInt(json['per_page'], fallback: 20),
      prevPageUrl: json['prev_page_url']?.toString(),
      to: _parseNullableInt(json['to']),
      total: _parseInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': deliveries.map((item) => item.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((item) => item.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class CompletedDeliveryData {
  final int id;
  final int deliveryManId;
  final int orderId;
  final String? status;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DeliveryOrder? order;
  final DeliveryMan? deliveryMan;

  const CompletedDeliveryData({
    this.id = 0,
    this.deliveryManId = 0,
    this.orderId = 0,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.order,
    this.deliveryMan,
  });

  factory CompletedDeliveryData.fromJson(Map<String, dynamic> json) {
    return CompletedDeliveryData(
      id: _parseInt(json['id']),
      deliveryManId: _parseInt(json['delivery_man_id']),
      orderId: _parseInt(json['order_id']),
      status: json['status']?.toString(),
      note: json['note']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      order: json['order'] is Map<String, dynamic>
          ? DeliveryOrder.fromJson(
        json['order'] as Map<String, dynamic>,
      )
          : null,
      deliveryMan: json['delivery_man'] is Map<String, dynamic>
          ? DeliveryMan.fromJson(
        json['delivery_man'] as Map<String, dynamic>,
      )
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
      'delivery_man': deliveryMan?.toJson(),
    };
  }
}

class DeliveryOrder {
  final int id;
  final int userId;
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
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final String? note;
  final String? platform;
  final int? userAddressId;
  final int isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DeliveryOrder({
    this.id = 0,
    this.userId = 0,
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
    this.subtotal = 0,
    this.shippingFee = 0,
    this.discount = 0,
    this.total = 0,
    this.note,
    this.platform,
    this.userAddressId,
    this.isActive = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) {
    return DeliveryOrder(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      orderNumber: json['order_number']?.toString(),
      paymentGroupId: json['payment_group_id']?.toString(),
      status: json['status']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      customerName: json['customer_name']?.toString(),
      customerPhone: json['customer_phone']?.toString(),
      shippingAddress: _parseFlexibleString(json['shipping_address']),
      zone:json['zone'] == null ? "No Zon": _parseFlexibleString(json['zone']),
      district: _parseFlexibleString(json['district']),
      area: _parseFlexibleString(json['area']),
      lat: _parseNullableDouble(json['lat']),
      lon: _parseNullableDouble(json['lon']),
      subtotal: _parseDouble(json['subtotal']),
      shippingFee: _parseDouble(json['shipping_fee']),
      discount: _parseDouble(json['discount']),
      total: _parseDouble(json['total']),
      note: json['note']?.toString(),
      platform: json['platform']?.toString(),
      userAddressId: _parseNullableInt(json['user_address_id']),
      isActive: _parseInt(json['is_active']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
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

class DeliveryMan {
  final int id;
  final int? referredBy;
  final String? provider;
  final String? providerId;
  final String? userType;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? deviceToken;
  final String? avatar;
  final String? avatarOriginal;
  final String? address;
  final String? country;
  final String? state;
  final String? city;
  final String? postalCode;
  final String? phone;
  final double balance;
  final int banned;
  final String? referralCode;
  final int? customerPackageId;
  final int remainingUploads;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DeliveryMan({
    this.id = 0,
    this.referredBy,
    this.provider,
    this.providerId,
    this.userType,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.deviceToken,
    this.avatar,
    this.avatarOriginal,
    this.address,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.phone,
    this.balance = 0,
    this.banned = 0,
    this.referralCode,
    this.customerPackageId,
    this.remainingUploads = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryMan.fromJson(Map<String, dynamic> json) {
    return DeliveryMan(
      id: _parseInt(json['id']),
      referredBy: _parseNullableInt(json['referred_by']),
      provider: json['provider']?.toString(),
      providerId: json['provider_id']?.toString(),
      userType: json['user_type']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      emailVerifiedAt: _parseDateTime(json['email_verified_at']),
      deviceToken: json['device_token']?.toString(),
      avatar: json['avatar']?.toString(),
      avatarOriginal: json['avatar_original']?.toString(),
      address: json['address']?.toString(),
      country: json['country']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      postalCode: json['postal_code']?.toString(),
      phone: json['phone']?.toString(),
      balance: _parseDouble(json['balance']),
      banned: _parseInt(json['banned']),
      referralCode: json['referral_code']?.toString(),
      customerPackageId: _parseNullableInt(json['customer_package_id']),
      remainingUploads: _parseInt(json['remaining_uploads']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referred_by': referredBy,
      'provider': provider,
      'provider_id': providerId,
      'user_type': userType,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'device_token': deviceToken,
      'avatar': avatar,
      'avatar_original': avatarOriginal,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'postal_code': postalCode,
      'phone': phone,
      'balance': balance,
      'banned': banned,
      'referral_code': referralCode,
      'customer_package_id': customerPackageId,
      'remaining_uploads': remainingUploads,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class PaginationLink {
  final String? url;
  final String? label;
  final bool active;

  const PaginationLink({
    this.url,
    this.label,
    this.active = false,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: json['url']?.toString(),
      label: json['label']?.toString(),
      active: _parseBool(json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}

int _parseInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();

  return int.tryParse(value.toString()) ?? fallback;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();

  return int.tryParse(value.toString());
}

double _parseDouble(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;
  if (value is double) return value;
  if (value is num) return value.toDouble();

  return double.tryParse(value.toString()) ?? fallback;
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();

  return double.tryParse(value.toString());
}

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value == 1;

  final normalized = value?.toString().trim().toLowerCase();

  return normalized == 'true' || normalized == '1';
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;

  return DateTime.tryParse(value.toString());
}

String? _parseFlexibleString(dynamic value) {
  if (value == null) return null;

  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  return value.toString();
}