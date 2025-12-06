// lib/views/marketplace_page.dart
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../controllers/product_controller.dart';

import 'product_detail_page.dart';
import 'profile_page.dart';
import 'my_products_page.dart';
import 'my_orders_page.dart';
import 'my_sales_page.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _BerandaPage(),
    MyOrdersPage(),
    MyProductsPage(),
    MySalesPage(),
    _ProfilUserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Produk Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Penjualan Saya',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (idx) {
          // Tambahan guard biar aman
          if (idx < _pages.length) {
            setState(() {
              _currentIndex = idx;
            });
          }
        },
      ),
    );
  }
}

/// ================== BERANDA (GET ALL PRODUCTS) ==================

class _BerandaPage extends StatefulWidget {
  const _BerandaPage();

  @override
  State<_BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<_BerandaPage> {
  late Future<List<Product>> _futureProducts;
  final ProductController _productController = ProductController();

  @override
  void initState() {
    super.initState();
    _futureProducts = _productController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace')),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('Belum ada produk di marketplace'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(productId: p.id),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: p.image != null && p.image!.isNotEmpty
                              ? Image.network(
                                  p.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                )
                              : const Center(
                                  child: Icon(Icons.image, size: 40),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (p.offerPrice != null)
                              Text(
                                'Rp ${p.offerPrice}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else if (p.price != null)
                              Text('Rp ${p.price}'),
                            const SizedBox(height: 2),
                            if (p.category != null)
                              Text(
                                p.category!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
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

/// ================== TAB LAIN (placeholder dulu) ==================

// class _PesananSayaPage extends StatelessWidget {
//   const _PesananSayaPage();

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       appBar: AppBar(title: Text('Pesanan Saya')),
//       body: Center(
//         child: Text('Halaman Pesanan Saya (belum diimplementasikan)'),
//       ),
//     );
//   }
// }

// class _ProdukSayaPage extends StatelessWidget {
//   const _ProdukSayaPage();

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       appBar: AppBar(title: Text('Produk Saya')),
//       body: Center(
//         child: Text('Halaman Produk Saya (belum diimplementasikan)'),
//       ),
//     );
//   }
// }

class _ProfilUserPage extends StatelessWidget {
  const _ProfilUserPage();

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}
