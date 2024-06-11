import 'package:dahlah/model/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:dahlah/controller/OrderController.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

//show the transaction page
class _TransactionPageState extends State<TransactionPage> {
  final _orderController = OrderController();

  Future<void> _refreshData () async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transactions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _orderController.getOrdersByUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            final orders = snapshot.data as List;
            return RefreshIndicator(
              onRefresh: _refreshData,
              color: Colors.orange,
              backgroundColor: Colors.white,
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index] as Transaction;
                  return TransactionCard(transaction: order);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction _transaction;
  
  const TransactionCard({Key? key, required Transaction transaction})
      : _transaction = transaction,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                //show conditional icon based on service type
                if (_transaction.service == 'Cat Grooming')
                  const Icon(Icons.shower, color: Colors.orange),
                if (_transaction.service == 'Cat Hotel')
                  const Icon(Icons.hotel, color: Colors.orange),
                if (_transaction.service == 'Cat Health')
                  const Icon(Icons.medical_services, color: Colors.orange),
                if (_transaction.service == 'Cat Shop')
                  const Icon(Icons.shopping_cart, color: Colors.orange),
                if (_transaction.service == 'Cat Training')
                  const Icon(Icons.pets, color: Colors.orange),
                SizedBox(width: 8),
                Text(_transaction.service, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    //show 4 different colors based on status
                    color: _transaction.status == 'Pending' ? Colors.yellow : _transaction.status == 'Completed' ? Colors.green : _transaction.status == 'Cancelled' ? Colors.red : Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_transaction.status, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(_transaction.timestamp)), style: const TextStyle(color: Colors.grey)),
                Text(_transaction.id, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            if (_transaction.service != 'Cat Health')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Method: ', style: const TextStyle(fontSize: 15)),
                  Text(_transaction.paymentMethod, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Address: ', style: const TextStyle(fontSize: 15)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(_transaction.address, textAlign: TextAlign.end, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //show '-' if phone number is empty
                Text('Phone Number: ', style: const TextStyle(fontSize: 15)),
                Text(_transaction.phoneNumber == '' ? '-' : _transaction.phoneNumber, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            if (_transaction.service == 'Cat Hotel')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Check In: ', style: const TextStyle(fontSize: 15)),
                  Text(_transaction.checkInDate, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            if (_transaction.service == 'Cat Hotel')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Check Out: ', style: const TextStyle(fontSize: 15)),
                  Text(_transaction.checkOutDate, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            if (_transaction.service == 'Cat Hotel')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Class Type: ', style: const TextStyle(fontSize: 15)),
                  Text(_transaction.classType, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            if (_transaction.service != 'Cat Health')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: ', style: const TextStyle(fontSize: 15)),
                  Text('Rp. ${_transaction.total}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}