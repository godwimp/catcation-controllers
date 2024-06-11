import 'package:dahlah/model/Transaction.dart' as order;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  
  Future<void> addOrder(order.Transaction order) async {
    try {
      await _firestore.collection('orders').add(order.toDocument());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<order.Transaction>> getOrders() async {
    try {
      final snapshot = await _firestore.collection('orders').get();
      return snapshot.docs.map((doc) => order.Transaction.fromDocument(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<order.Transaction>> getOrdersByUser() async {
    try {
      final snapshot = await _firestore.collection('orders').where('ownerId', isEqualTo: _auth.currentUser!.uid).get();
      return snapshot.docs.map((doc) => order.Transaction.fromDocument(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final snapshot = await _firestore.collection('orders').where('id', isEqualTo: orderId).get();
      for (final doc in snapshot.docs) {
        await _firestore.collection('orders').doc(doc.id).update({'status': status});
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
