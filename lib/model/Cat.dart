class Cat {
  String _id;
  String _name;
  int _age;
  String _breed;
  String _allergy;
  late String _imageUrl;
  
  Cat({
    required String id,
    required String name,
    required int age,
    required String breed,
    required String allergy,
    required String imageUrl,
  }) : _id = id, _name = name, _age = age, _breed = breed, _allergy = allergy, _imageUrl = imageUrl;

  String get id => _id;
  String get name => _name;
  int get age => _age;
  String get breed => _breed;
  String get allergy => _allergy;
  String get imageUrl => _imageUrl;

  Map<String, dynamic> toDocument() {
    return {
      'id': _id,
      'name': _name,
      'age': _age,
      'breed': _breed,
      'allergy': _allergy,
      'imageUrl': _imageUrl,
    };
  }

  factory Cat.fromDocument(Map<String, dynamic> doc) {
    return Cat(
      id: doc['id'],
      name: doc['name'],
      age: doc['age'],
      breed: doc['breed'],
      allergy: doc['allergy'],
      imageUrl: doc['imageUrl'],
    );
  }
}