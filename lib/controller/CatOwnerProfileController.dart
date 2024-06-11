import 'package:dahlah/model/CatOwner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CatOwnerProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<void> updateProfile(CatOwner catOwner) async {
    try {
      await _firestore.collection('cat_owners').doc(catOwner.id).update(catOwner.toDocument());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CatOwner> getProfile() async {
    try {
      final snapshot = await _firestore.collection('cat_owners').doc(_auth.currentUser!.uid).get();
      return CatOwner.fromDocument(snapshot.data()!);
    } catch (e) {
      throw Exception(e);
    }
  }
}