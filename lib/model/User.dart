class User {
  final String _id;
  final String _email;
  final String _name;
  
  User({
    required String id,
    required String email,
    required String name,
  }) : _id = id, _email = email, _name = name;

  String get id => _id;
  String get email => _email;
  String get name => _name;

  Map<String, dynamic> toDocument() {
    return {
      'id': _id,
      'email': _email,
      'name': _name,
    };
  }

  factory User.fromDocument(Map<String, dynamic> doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      name: doc['name'],
    );
  }
}