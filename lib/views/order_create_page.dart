// lib/views/order_create_page.dart
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';
import '../controllers/order_controller.dart';
import '../controllers/user_controller.dart';

class OrderCreatePage extends StatefulWidget {
  final Product product;

  const OrderCreatePage({super.key, required this.product});

  @override
  State<OrderCreatePage> createState() => _OrderCreatePageState();
}

class _OrderCreatePageState extends State<OrderCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneC = TextEditingController();
  final TextEditingController _streetC = TextEditingController();
  final TextEditingController _cityC = TextEditingController();
  final TextEditingController _stateC = TextEditingController();
  final TextEditingController _postalC = TextEditingController();
  final TextEditingController _countryC =
      TextEditingController(text: 'Indonesia');

  String _paymentMethod = 'cod';
  bool _isSubmitting = false;
  UserModel? _currentUser;

  final OrderController _orderController = OrderController();
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _userController.getCurrentUser();

    if (!mounted) return;

    setState(() {
      _currentUser = user;
    });
  }

  @override
  void dispose() {
    _phoneC.dispose();
    _streetC.dispose();
    _cityC.dispose();
    _stateC.dispose();
    _postalC.dispose();
    _countryC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User belum login')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final msg = await _orderController.createOrder(
        userId: _currentUser!.id,
        productId: widget.product.id,
        shippingPhone: _phoneC.text.trim(),
        shippingStreet: _streetC.text.trim(),
        shippingCity: _cityC.text.trim(),
        shippingState: _stateC.text.trim(),
        shippingPostalCode: _postalC.text.trim(),
        shippingCountry: _countryC.text.trim(),
        paymentMethod: _paymentMethod,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Order')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan produk
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    p.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      if (p.offerPrice != null)
                        Text('Harga: Rp ${p.offerPrice}')
                      else if (p.price != null)
                        Text('Harga: Rp ${p.price}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Alamat Pengiriman',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _phoneC,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No. Telepon',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _streetC,
                decoration: const InputDecoration(
                  labelText: 'Jalan / Detail alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cityC,
                decoration: const InputDecoration(
                  labelText: 'Kota / Kabupaten',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stateC,
                decoration: const InputDecoration(
                  labelText: 'Provinsi',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _postalC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kode Pos',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _countryC,
                decoration: const InputDecoration(
                  labelText: 'Negara',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Metode Pembayaran',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                items: const [
                  DropdownMenuItem(
                    value: 'cod',
                    child: Text('Bayar di Tempat (COD)'),
                  ),
                  DropdownMenuItem(value: 'qris', child: Text('QRIS')),
                  DropdownMenuItem(value: 'paylater', child: Text('Paylater')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _paymentMethod = val;
                    });
                  }
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Buat Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
