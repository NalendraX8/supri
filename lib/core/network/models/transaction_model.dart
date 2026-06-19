import 'dart:convert';

/// Transaction item model.
class TransactionItemModel {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  const TransactionItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory TransactionItemModel.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return TransactionItemModel(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
  };
}

/// Transaction model for API.
class TransactionModel {
  final String? id;
  final String outletId;
  final List<TransactionItemModel> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String paymentMethod;
  final String? customerName;
  final String status;
  final DateTime? createdAt;

  const TransactionModel({
    this.id,
    required this.outletId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    this.customerName,
    required this.status,
    this.createdAt,
  });

  factory TransactionModel.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    return TransactionModel(
      id: json['id']?.toString(),
      outletId: json['outletId'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TransactionItemModel.fromJson(e))
          .toList() ?? [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'cash',
      customerName: json['customerName'],
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  String toJson() {
    final map = {
      'outletId': outletId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'discount': discount,
      'total': total,
      'paymentMethod': paymentMethod,
      'customerName': customerName,
      'status': status,
      'createdAt': DateTime.now().toIso8601String(),
    };
    return jsonEncode(map);
  }
}
