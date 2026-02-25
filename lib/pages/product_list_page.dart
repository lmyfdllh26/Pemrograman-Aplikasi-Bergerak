import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  String searchQuery = '';
  String selectedCategory = 'All';

  final List<String> categories = ['All', 'Food', 'Drink'];

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Vanilla Cake',
      price: 60000,
      emoji: '🎂',
      description: 'Delicious vanilla cake',
      category: 'Food',
    ),
    Product(
      id: '2',
      name: 'Soft Cookies',
      price: 8000,
      emoji: '🍪',
      description: 'Soft and chewy cookies',
      category: 'Food',
    ),
    Product(
      id: '3',
      name: 'matcha Latte',
      price: 15000,
      emoji: '🍵',
      description: 'Creamy matcha latte',
      category: 'Drink',
    ),
    Product(
      id: '4',
      name: 'Espresso',
      price: 12000,
      emoji: '☕',
      description: 'Strong and bold espresso',
      category: 'Drink',
    ),
    Product(
      id: '5',
      name: 'Brownies',
      price: 25000,
      emoji: '🍫',
      description: 'Rich and fudgy brownies',
      category: 'Food',
    ),
  ];

  @override
  Widget build(BuildContext context) {

    final filteredProducts = products.where((product) {
      final matchSearch = product.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchCategory = selectedCategory == 'All'
          || product.category == selectedCategory;

      return matchSearch && matchCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.brown,
                        child: Text(
                          cart.itemCount.toString(),
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color.fromARGB(255, 234, 217, 211)),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField(
              value: selectedCategory,
              items: categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {

                final product = filteredProducts[index];

                return Card(
                  color: const Color.fromARGB(255, 213, 146, 168),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                    
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 241, 241),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                         child: Center(
                        child: Text(
                          product.emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  ),

                      Text(product.name,
                          textAlign: TextAlign.center),

                  

                      Text(
                        'Rp ${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<CartModel>()
                              .addItem(product);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}