import "package:dahlah/controller/AuthController.dart";
import 'package:dahlah/employee_dashboard.dart';
import 'package:dahlah/login_employee.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WidgetTreeEmployee extends StatefulWidget{
  const WidgetTreeEmployee({Key? key}) : super(key: key);

  @override
  _WidgetTreeEmployeeState createState() => _WidgetTreeEmployeeState();
}

class _WidgetTreeEmployeeState extends State<WidgetTreeEmployee>{
  //check if the user is employee or not
  @override
  Widget build(BuildContext context){
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
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmployeeDashboard(),
                      ),
                      (route) => false,
                    );
                  });
                  return const SizedBox();
                } else {
                  return Center(child: Text('Logout and login as Cat Owner'));
                }
              }
            },
          );
        } else {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginEmployeePage(),
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