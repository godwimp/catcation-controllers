import 'package:dahlah/controller/AuthController.dart';
import 'package:dahlah/manage_profile.dart';
import 'package:dahlah/service_catgroom.dart';
import 'package:dahlah/service_cathealth.dart';
import 'package:dahlah/service_cathotel.dart';
import 'package:dahlah/service_catshop.dart';
import 'package:dahlah/service_cattraining.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  User? user = AuthController().user;

  Future<void> signOut() async {
    await AuthController().signOut();
    Navigator.pop(context);
  }

  Widget _userId(){
    return Text(user?.email ?? 'No User');
  }

  Widget _serviceButton(IconData icon, String title, Widget page){
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            },
            child: Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              backgroundColor: const Color(0xFFFF6F3C),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6F3C),
            ),
          )
        ],
      ),
    );
  }

  Widget _recommendedItem(String imagePath, String title, String price){
    return InkWell(
      onTap: (){},
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 10),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          )
        )
      )
    );
  }

  Widget _articleItem(String imagePath, String title){
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
              
            ),
          ),
        ),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Read',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Color(0xFFFF6F3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFFF6F3C),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFF6F3C),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CatCation.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageProfile()),
                );
              },
              child: Row(
                children: [
                  Text(
                    user?.email?.split('@').first ?? 'No User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                ],
              ),
            )
            
          ],
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Cat Service Status
            Container(
              color: Color(0xFFFF6F3C),
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              //if user has display name use it, else use email parse before @
                              'Hi, ${
                                user?.displayName ?? user?.email?.split('@').first
                              }! Your cat is currently on our care!',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                onPressed: (){},
                                child: Text(
                                  'Check Status',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF6F3C),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/cuate.png',
                        width: 100,
                        height: 100,
                      )
                    ],
                  )
                ),
              ),
            ),
            //Services
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _serviceButton(Icons.hotel, 'Cat Hotel', const CatHotelPage()),
                        _serviceButton(Icons.shower, 'Cat Groom' , const CatGroomPage()),
                        _serviceButton(Icons.health_and_safety, 'Cat Health', const CatHealthPage()),
                        _serviceButton(Icons.shopping_bag, 'Cat Shop', CatShopPage()),
                        _serviceButton(Icons.pets, 'Cat Training', const CatTrainingPage()),
                      ],
                    ),
                  ),
                  //recommended items
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Recommended for your cat!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6F3C),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          // show all of product item in database
                          child: Row(
                            children: [
                              _recommendedItem('assets/wiskas.png', 'Cat Food', 'Rp 50.000'),
                              _recommendedItem('assets/wiskas.png', 'Cat Toy', 'Rp 100.000'),
                              _recommendedItem('assets/wiskas.png', 'Cat Bed', 'Rp 200.000'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  //Article
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Articles for you!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6F3C),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        _articleItem('assets/article.png', 'How to make your cat happy'),
                        _articleItem('assets/article.png', 'The best food for your cat'),
                        _articleItem('assets/article.png', 'The best toys for your cat'),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}