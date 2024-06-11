import 'package:dahlah/home_nav.dart';
import 'package:dahlah/login.dart';
import "package:dahlah/controller/AuthController.dart";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree>{
  @override
  Widget build(BuildContext context){
    //check if the user is employee or not
    return StreamBuilder<User?>(
      stream: AuthController().authStateChanges,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if(snapshot.hasError){
          return const Center(
            child: Text('Error'),
          );
        } else if(snapshot.hasData){
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).snapshots(),
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
                final data = snapshot.data!.data() as Map<String, dynamic>;
                if(data['role'] == 'employee'){
                  return const Center(child: Text('Logout and login as employee'));
                } else {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeNav(),
                      ),
                      (route) => false,
                    );
                  });
                  return const SizedBox();
                }
              }
            },
          );
        } else {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
              (route) => false,
            );
          });
          return const SizedBox();
        }
      },
    );
  }
}