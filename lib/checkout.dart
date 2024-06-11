//make checkout page for the user to checkout the items in the cart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _user = FirebaseAuth.instance.currentUser;
  List<CartItem> _cartItems = [];

  //make a future to get the items in the cart
  Future<void> getCartItems() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('carts')
        .get();
    _cartItems = snapshot.docs.map((doc) => CartItem.fromDocument(doc.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            return ProductSection(item: _cartItems[index]);
                          },
                        ),
                      ),
                      DeliveryOptionSection(),
                      ElevatedButton(
                        onPressed: () {
                          //make a function to clear the cart
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(_user!.uid)
                              .collection('carts')
                              .get()
                              .then((snapshot) {
                            for (DocumentSnapshot doc in snapshot.docs) {
                              doc.reference.delete();
                            }
                          });
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItem {
  final String name;
  final String price;
  final String image;
  final int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory CartItem.fromDocument(Map<String, dynamic> document) {
    return CartItem(
      name: document['name'],
      price: document['price'],
      image: document['image'],
      quantity: document['quantity'],
    );
  }
}

class ProductSection extends StatelessWidget{
  final CartItem item;

  ProductSection({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(item.image),
        title: Text(item.name),
        subtitle: Text(item.price),
        trailing: Text('x${item.quantity}'),
      ),
    );
  }
}

class DeliveryOptionSection extends StatelessWidget {
  final List<String> deliveryOptions = ['Standard Delivery', 'Express Delivery'];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              items: deliveryOptions
                  .map((option) => DropdownMenuItem(
                        child: Text(option),
                        value: option,
                      ))
                  .toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              )
            ),
            SizedBox(height: 10),
            const Text(
              'Note: Standard Delivery is free, Express Delivery costs an additional \$5',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
    );
  }
}