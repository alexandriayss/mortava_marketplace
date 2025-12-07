// lib/views/product_detail_page.dart
//
// Product Detail Page (refined) dengan MortavaTheme
// - Background pakai gradient marketplace MortavaTheme
// - Tombol "BUY NOW" pakai gradient primary MortavaTheme
// - Warna teks utama pakai MortavaColors.darkText

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product_model.dart';
import '../controllers/product_controller.dart';
import '../theme/mortava_theme.dart';
import 'order_create_page.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Product> _futureProduct;
  final ProductController _productController = ProductController();

  @override
  void initState() {
    super.initState();
    _futureProduct = _productController.getProductDetail(widget.productId);
  }

  String _formatPrice(num? value) {
    if (value == null) return '-';
    return 'Rp ${value.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        // Background pakai tema marketplace (cream–peach lembut)
        decoration: MortavaDecorations.marketplaceBackgroundBox(),
        child: SafeArea(
          top: true,
          bottom: false,
          child: FutureBuilder<Product>(
            future: _futureProduct,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.poppins(),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'Product not found',
                    style: GoogleFonts.poppins(),
                  ),
                );
              }

              final p = snapshot.data!;
              final int qty = p.quantity ?? 0;
              final bool inStock = qty > 0;

              final bool hasDiscount =
                  p.offerPrice != null &&
                  p.price != null &&
                  p.offerPrice! < p.price!;

              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: 32 + bottomInset,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ------------ BACK BUTTON ------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    // ------------ TITLE ------------
                    Center(
                      child: Text(
                        'Product Details',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: MortavaColors.darkText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Container(
                        width: 140,
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF8A65),
                              Color(0xFFFF7043),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ------------ MAIN CARD ------------
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFFBF2), // hampir putih
                            Color(0xFFFFE8C8), // peach lembut
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 24,
                            offset: const Offset(0, 16),
                            color: Colors.orange.withOpacity(0.20),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ------------ IMAGE (no crop) ------------
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Container(
                                color: Colors.white,
                                child: p.image != null && p.image!.isNotEmpty
                                    ? Image.network(
                                        p.image!,
                                        fit: BoxFit
                                            .contain, // supaya gambar tidak kepotong
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // ------------ NAME + PRICE ------------
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  p.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: MortavaColors.darkText,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (hasDiscount)
                                    Text(
                                      _formatPrice(p.price),
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        decoration:
                                            TextDecoration.lineThrough,
                                      ),
                                    ),
                                  Text(
                                    _formatPrice(
                                        hasDiscount ? p.offerPrice : p.price),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: MortavaColors.darkText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(height: 18),

                          // ------------ DESCRIPTION ------------
                          Text(
                            'Description',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: MortavaColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 1,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            p.description?.isNotEmpty == true
                                ? p.description!
                                : 'No description available.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              height: 1.4,
                              color: const Color(0xFF4A3424),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ------------ STOCK ------------
                          Text(
                            'Stock',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: MortavaColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 1,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: inStock
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                              border: Border.all(
                                color: inStock
                                    ? const Color(0xFF43A047)
                                    : const Color(0xFFE53935),
                              ),
                            ),
                            child: Text(
                              inStock ? 'READY' : 'OUT OF STOCK',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: inStock
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFC62828),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ------------ BUY NOW BUTTON ------------
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: inStock
                            ? () async {
                                final result = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OrderCreatePage(product: p),
                                  ),
                                );

                                if (result == true && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Order created successfully.',
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: const StadiumBorder(),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            // Pakai gradient utama MortavaTheme kalau stok READY
                            gradient: inStock
                                ? MortavaGradients.primaryButton
                                : null,
                            color: inStock ? null : Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            height: 52,
                            alignment: Alignment.center,
                            child: Text(
                              'BUY NOW',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
