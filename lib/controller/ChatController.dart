import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendMessage(String message, String receiver) async {
    try {
      final sender = _auth.currentUser!.uid;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final id = _firestore.collection('messages').doc().id;
      await _firestore.collection('messages').doc(id).set({
        'id': id,
        'message': message,
        'sender': sender,
        'receiver': receiver,
        'timestamp': timestamp,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages(String receiver) {
    try {
      return _firestore.collection('messages').where('receiver', isEqualTo: receiver).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  //get users
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}