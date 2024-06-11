import "package:dahlah/controller/AuthController.dart";
import "package:dahlah/employee_dashboard.dart";
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginEmployeePage extends StatefulWidget {
  @override
  _LoginEmployeePageState createState() => _LoginEmployeePageState();
}

class _LoginEmployeePageState extends State<LoginEmployeePage> {
  String? _errorMessage = '';
  bool _isObscured = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _empIdController = TextEditingController();

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    //match the employee ID with the employee ID in the database
    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _empIdController.text.isEmpty) {
        setState(() {
          _errorMessage = 'Please fill all fields';
        });
        return;
      }
      await AuthController().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (AuthController().user != null) {
        final user = FirebaseAuth.instance.currentUser;
        final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
        if (userData['role'] != 'employee') {
          if (mounted)
            setState(() {
              _errorMessage = 'You are not an employee';
            });
          return;
        }
        if (context != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const EmployeeDashboard(),
            ),
            (route) => false,
          );
        }
      } else {
        if(mounted) {
          setState(() {
            _errorMessage = 'Invalid email or password';
          });
        
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/cat_with_balloons.png',
                  height: 300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Login into your account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. agusgan@ganteng.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Employee ID',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  TextField(
                    controller: _empIdController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter Employee ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isObscured,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (_errorMessage != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          signInWithEmailAndPassword(context);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}