// lib/views/order_detail_page.dart
import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import '../controllers/order_controller.dart';
import '../controllers/product_controller.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<OrderModel> _futureOrder;

  final OrderController _orderController = OrderController();
  final ProductController _productController = ProductController();

  @override
  void initState() {
    super.initState();
    _futureOrder = _orderController.fetchOrderDetail(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Order')),
      body: FutureBuilder<OrderModel>(
        future: _futureOrder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Order tidak ditemukan'));
          }

          final o = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =======================
                // Info produk yang dibeli
                // =======================
                FutureBuilder<Product>(
                  future: _productController.getProductDetail(o.productId),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Memuat info produk...',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      );
                    }

                    if (snap.hasError || !snap.hasData) {
                      return Text(
                        'Produk #${o.productId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      );
                    }

                    final p = snap.data!;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: (p.image != null && p.image!.isNotEmpty)
                                ? Image.network(
                                    p.image!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image_not_supported),
                                  )
                                : const Icon(Icons.image, size: 40),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (p.offerPrice != null)
                                Text('Rp ${p.offerPrice}')
                              else if (p.price != null)
                                Text('Rp ${p.price}'),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Seller username (jika ada)
                if (o.sellerUsername != null &&
                    o.sellerUsername!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Penjual: ${o.sellerUsername!}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                // =======================
                // Info order
                // =======================
                Text(
                  'Order #${o.id}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Buyer username (jika ada)
                if (o.buyerUsername != null &&
                    o.buyerUsername!.isNotEmpty) ...[
                  Text('Pembeli: ${o.buyerUsername!}'),
                  const SizedBox(height: 8),
                ],

                Text('Status: ${o.status}'),
                const SizedBox(height: 8),
                Text('Metode Pembayaran: ${o.paymentMethod.toUpperCase()}'),
                if (o.totalPrice != null) Text('Total: Rp ${o.totalPrice}'),
                const SizedBox(height: 16),

                const Text(
                  'Alamat Pengiriman',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (o.shippingStreet != null && o.shippingStreet!.isNotEmpty)
                  Text(o.shippingStreet!),
                if (o.shippingCity != null || o.shippingState != null)
                  Text(
                    '${o.shippingCity ?? ''}'
                    '${o.shippingCity != null && o.shippingState != null ? ', ' : ''}'
                    '${o.shippingState ?? ''}',
                  ),
                if (o.shippingPostalCode != null || o.shippingCountry != null)
                  Text(
                    '${o.shippingPostalCode ?? ''}'
                    '${o.shippingPostalCode != null && o.shippingCountry != null ? ', ' : ''}'
                    '${o.shippingCountry ?? ''}',
                  ),
                if (o.shippingPhone != null && o.shippingPhone!.isNotEmpty)
                  Text('Telp: ${o.shippingPhone}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
