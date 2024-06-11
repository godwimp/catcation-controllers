import 'package:dahlah/model/User.dart';

class CatOwner extends User {
  final String _phoneNumber;
  final String _address;

  CatOwner({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    required String address,
  }) : _phoneNumber = phoneNumber, _address = address, super(id: id, name: name, email: email);

  String get phoneNumber => _phoneNumber;
  String get address => _address;

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': _phoneNumber,
      'address': _address,
    };
  }

  factory CatOwner.fromDocument(Map<String, dynamic> doc) {
    return CatOwner(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      phoneNumber: doc['phoneNumber'],
      address: doc['address'],
    );
  }
}