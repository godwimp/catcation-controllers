import 'package:dahlah/chat.dart';
import 'package:dahlah/checkout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  /*
    my structure in firestore:
    users (koleksi)
    |- userId1 (dokumen)
        |- carts (subkoleksi)
            |- cartItem1 (dokumen)
            |- cartItem2 (dokumen)
    |- userId2 (dokumen)
        |- carts (subkoleksi)
            |- cartItem1 (dokumen)
            |- cartItem2 (dokumen)
  */
  final CollectionReference _cartCollection = FirebaseFirestore.instance.collection('users');

  final User? _user = FirebaseAuth.instance.currentUser;
  
  QuerySnapshot? _cart;

  Future<int> _getTotalPrice() async {
    int totalPrice = 0;
    for(int i = 0; i < _cart!.docs.length; i++){
      int price = int.parse(_cart!.docs[i].get('price').toString());
      int quantity = int.parse(_cart!.docs[i].get('quantity').toString());
      totalPrice += price * quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: _cartCollection.doc(_user!.uid).collection('carts').get(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if(snapshot.hasError){
            return const Center(
              child: Text('Error'),
            );
          } else {
            _cart = snapshot.data!;
            if (_cart!.docs.isEmpty) {
              return const Center(
                child: Text('No item in cart'),
              );
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _cart!.docs.length,
                    itemBuilder: (context, index){
                      if (_cart!.docs.isEmpty) {
                        return const Center(
                          child: Text('No item in cart'),
                        );
                      }
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/wiskas.png',
                                width: 100,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _cart!.docs[index].get('name'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Rp. ${_cart!.docs[index].get('price')}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () async {
                                          if(_cart!.docs[index].get('quantity') > 1){
                                            await _cartCollection.doc(_user!.uid).collection('carts').doc(_cart!.docs[index].id).update({
                                              'quantity': _cart!.docs[index].get('quantity') - 1,
                                            });
                                          }
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all(Colors.orange),
                                        )
                                      ),
                                      Text(
                                        _cart!.docs[index].get('quantity').toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange
                                        )
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        //update quantity
                                        onPressed: () async {
                                          await _cartCollection.doc(_user!.uid).collection('carts').doc(_cart!.docs[index].id).update({
                                            'quantity': _cart!.docs[index].get('quantity') + 1,
                                          });
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all(Colors.orange),
                                        )
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        //delete item from cart
                                        onPressed: () async {
                                          await _cartCollection.doc(_user!.uid).collection('carts').doc(_cart!.docs[index].id).delete();
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<int>(
                          future: _getTotalPrice(),
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const Text('Rp. 0');
                            } else {
                              return Text(
                                textAlign: TextAlign.left,
                                'Total:\nRp. ${snapshot.data}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutPage()));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.orange),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                )
              ],
            );
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your cart',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
              }
            ),
          ],
        ),
      ),
    );
  }
}
