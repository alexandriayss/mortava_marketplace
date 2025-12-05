class OrderModel {
  final int id;
  final int userBeli;
  final int? userJual;
  final int productId;
  final int? totalPrice;
  final String paymentMethod;
  final String status;
  final String? shippingPhone;
  final String? shippingStreet;
  final String? shippingCity;
  final String? shippingState;
  final String? shippingPostalCode;
  final String? shippingCountry;
  final String? createdAt;

  // tambahan username sesuai endpoint
  final String? sellerUsername; // muncul di buy/:userId
  final String? buyerUsername; // muncul di sell/:userId

  OrderModel({
    required this.id,
    required this.userBeli,
    this.userJual,
    required this.productId,
    this.totalPrice,
    required this.paymentMethod,
    required this.status,
    this.shippingPhone,
    this.shippingStreet,
    this.shippingCity,
    this.shippingState,
    this.shippingPostalCode,
    this.shippingCountry,
    this.createdAt,
    this.sellerUsername,
    this.buyerUsername,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      userBeli: json['user_beli'] is int
          ? json['user_beli']
          : int.tryParse('${json['user_beli']}') ?? 0,
      userJual: json['user_jual'] is int
          ? json['user_jual']
          : (json['user_jual'] != null
                ? int.tryParse('${json['user_jual']}')
                : null),
      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse('${json['product_id']}') ?? 0,
      totalPrice: json['total_price'] is int
          ? json['total_price']
          : (json['total_price'] != null
                ? int.tryParse('${json['total_price']}')
                : null),
      paymentMethod: (json['payment_method'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      shippingPhone: json['shipping_phone']?.toString(),
      shippingStreet: json['shipping_street']?.toString(),
      shippingCity: json['shipping_city']?.toString(),
      shippingState: json['shipping_state']?.toString(),
      shippingPostalCode: json['shipping_postal_code']?.toString(),
      shippingCountry: json['shipping_country']?.toString(),
      createdAt: json['created_at']?.toString(),
      sellerUsername: json['seller_username']?.toString(),
      buyerUsername: json['buyer_username']?.toString(),
    );
  }
}
