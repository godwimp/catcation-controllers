import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dahlah/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class CatShopPage extends StatefulWidget {
  @override
  _CatShopPageState createState() => _CatShopPageState();
}

class _CatShopPageState extends State<CatShopPage> {
  int _selectedIndex = 0;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<String> _getImageUrl(String path) async {
    final ref = _storage.ref().child(path);
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 9),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
              },
            )
          ],
        )
      ),
      body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/article.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Get special discounts\nup to 50%',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Get now!'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.orangeAccent),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 75,
                      height: 30,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        child: Text(
                          'All',
                          style: TextStyle(fontSize:10)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _selectedIndex == 0 ? Colors.orange : Colors.white,
                          side: BorderSide(color: Colors.orange),
                          foregroundColor: _selectedIndex == 0 ? Colors.white : Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 75,
                      height: 30,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Text(
                          'New',
                          style: TextStyle(fontSize:10)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _selectedIndex == 1 ? Colors.orange : Colors.white,
                          side: BorderSide(color: Colors.orange),
                          foregroundColor: _selectedIndex == 1 ? Colors.white : Colors.orange,
                        ),
                      ),
                    
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 85,
                      height: 30,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                        child: Text(
                          'Popular',
                          style: TextStyle(fontSize:10)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _selectedIndex == 2 ? Colors.orange : Colors.white,
                          side: BorderSide(color: Colors.orange),
                          foregroundColor: _selectedIndex == 2 ? Colors.white : Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 75,
                      height: 30,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 3;
                          });
                        },
                        child: Text(
                          'Food',
                          style: TextStyle(fontSize:10)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _selectedIndex == 3 ? Colors.orange : Colors.white,
                          side: BorderSide(color: Colors.orange),
                          foregroundColor: _selectedIndex == 3 ? Colors.white : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _getProducts(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<Map<String, dynamic>> products = snapshot.data!;
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: products.length,
                      itemBuilder: (_, index) {
                        var product = products[index];
                        return FutureBuilder<String>(
                          //i have to test the storage path, my storage is only have 1 image at /image/wiskas.png, use it for now
                          future: _getImageUrl('image/wiskas.png'),
                          builder: (_, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return ProductCard(
                              product: product,
                              imageUrl: snapshot.data!,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final String imageUrl;

  const ProductCard({
    required this.product,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ProductDetailModal(
                      id: product['id'],
                      name: product['name'],
                      price: product['price'].toString(),
                      image: imageUrl,
                      description: product['description'],
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'], style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Text(product['price'].toString(), style: TextStyle(fontSize: 16, color: Colors.orange)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailModal extends StatefulWidget {
  final String id;
  final String name;
  final String price;
  final String image;
  final String description;

  const ProductDetailModal({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  @override
  _ProductDetailModalState createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  
  Future<void> _addToCart() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please login first'),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ));
    }
    final String uid = user!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final cartRef = firestore.collection('users').doc(uid).collection('carts');
    final snapshot = await cartRef.where('id', isEqualTo: widget.id).get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      final quantity = doc['quantity'] + 1;
      await doc.reference.update({'quantity': quantity});
      Navigator.pop(context);
      return;
    }

    await cartRef.add(
      {
        'id': widget.id,
        'name': widget.name,
        'price': widget.price,
        'image': widget.image,
        'description': widget.description,
        'quantity': 1,
      },
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(widget.image, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('Rp ${widget.price.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text(widget.description, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addToCart,
                      child: Text('Add to cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}