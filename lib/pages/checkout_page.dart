import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  final _formKey = GlobalKey<FormState>();

  String name = '';
  String address = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {

    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...cart.itemsList.map((item) => Text(
                          '${item.product.name} x${item.quantity}',
                        )),
                    const Divider(),
                    Text(
                      'Total: Rp ${cart.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                children: [

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Required' : null,
                    onSaved: (value) => name = value!,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Required' : null,
                    onSaved: (value) => address = value!,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Required' : null,
                    onSaved: (value) => phone = value!,
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {

                    _formKey.currentState!.save();

                    cart.clear();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content:
                            Text('Order Successful!'),
                      ),
                    );

                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Place Order'),
              ),
            )
          ],
        ),
      ),
    );
  }
}