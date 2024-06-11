import 'package:dahlah/model/User.dart';

class Employee extends User {
  final String _phoneNumber;
  final String _role;
  
  Employee({
    required String id,
    required String email,
    required String name,
    required String phoneNumber,
    required String role,
  }) : _phoneNumber = phoneNumber, _role = role, super(id: id, email: email, name: name);

  String get phoneNumber => _phoneNumber;
  String get role => _role;

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }

  factory Employee.fromDocument(Map<String, dynamic> doc) {
    return Employee(
      id: doc['id'],
      email: doc['email'],
      name: doc['name'],
      phoneNumber: doc['phoneNumber'],
      role: doc['role'],
    );
  }
}