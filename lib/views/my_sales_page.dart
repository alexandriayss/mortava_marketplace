// lib/views/my_sales_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import '../controllers/order_controller.dart';
import '../controllers/product_controller.dart';
import 'order_detail_page.dart';

class MySalesPage extends StatefulWidget {
  const MySalesPage({super.key});

  @override
  State<MySalesPage> createState() => _MySalesPageState();
}

class _MySalesPageState extends State<MySalesPage> {
  Future<List<OrderModel>>? _futureSales;

  final OrderController _orderController = OrderController();
  final ProductController _productController = ProductController();

  @override
  void initState() {
    super.initState();
    _loadUserAndSales();
  }

  Future<void> _loadUserAndSales() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');

    if (!mounted) return;

    if (id == null) {
      setState(() {
        _futureSales = Future.error('User belum login');
      });
      return;
    }

    setState(() {
      _futureSales = _orderController.fetchSalesForUser(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penjualan Saya')),
      body: _futureSales == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<OrderModel>>(
              future: _futureSales,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final sales = snapshot.data ?? [];

                if (sales.isEmpty) {
                  return const Center(child: Text('Belum ada penjualan'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: sales.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final o = sales[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailPage(orderId: o.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // buyer username
                              if (o.buyerUsername != null &&
                                  o.buyerUsername!.isNotEmpty)
                                Text(
                                  'Pembeli: ${o.buyerUsername!}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),

                              const SizedBox(height: 8),

                              // Info produk terjual
                              FutureBuilder<Product>(
                                future: _productController
                                    .getProductByIdCached(o.productId),
                                builder: (context, snap) {
                                  if (snap.connectionState ==
                                      ConnectionState.waiting) {
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
                                        fontSize: 16,
                                      ),
                                    );
                                  }

                                  final p = snap.data!;
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: (p.image != null &&
                                                  p.image!.isNotEmpty)
                                              ? Image.network(
                                                  p.image!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                      ),
                                                )
                                              : const Icon(
                                                  Icons.image,
                                                  size: 32,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
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

                              // Info order
                              Text(
                                'Order #${o.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (o.totalPrice != null)
                                Text('Total: Rp ${o.totalPrice}'),
                              Text('Metode: ${o.paymentMethod.toUpperCase()}'),
                              Text('Status: ${o.status}'),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
