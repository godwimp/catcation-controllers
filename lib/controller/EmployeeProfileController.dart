import 'package:dahlah/model/Employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Update profile for employee
  Future<void> updateProfile(Employee employee) async {
    try {
      await _firestore.collection('employees').doc(employee.id).update(employee.toDocument());
    } catch (e) {
      throw Exception(e);
    }
  }

// Get profile for employee
  Future<Employee> getProfile() async {
    try {
      final snapshot = await _firestore.collection('employees').doc(_auth.currentUser!.uid).get();
      return Employee.fromDocument(snapshot.data()!);
    } catch (e) {
      throw Exception(e);
    }
  }
}