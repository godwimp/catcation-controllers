// make a table contains all transactions fetched from the database

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dahlah/controller/OrderController.dart';
import 'package:dahlah/model/Transaction.dart' as order;
import 'package:firebase_auth/firebase_auth.dart';

class TransactionTable extends StatefulWidget {
  const TransactionTable({Key? key}) : super(key: key);

  @override
  _TransactionTableState createState() => _TransactionTableState();
}

// use datatable to show the transaction data

class _TransactionTableState extends State<TransactionTable> {
  final _orderController = OrderController();

  User? _user = FirebaseAuth.instance.currentUser;
  String _selectedStatus = 'Pending';

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _orderController.getOrders(),
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Order ID'),
                    ),
                    DataColumn(
                      label: Text('Owner ID'),
                    ),
                    DataColumn(
                      label: Text('Date Ordered'),
                    ),
                    DataColumn(
                      label: Text('Service Type'),
                    ),
                    DataColumn(
                      label: Text('Class Type'),
                    ),
                    DataColumn(
                      label: Text('Phone Number'),
                    ),
                    DataColumn(
                      label: Text('Address'),
                    ),
                    DataColumn(
                      label: Text('Total Price'),
                    ),
                    DataColumn(
                      label: Text('Status'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    orders.length,
                    (index) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(orders[index].id)),
                        DataCell(Text(orders[index].ownerId)),
                        DataCell(Text(orders[index].timestamp.toString())),
                        DataCell(Text(orders[index].service)),
                        DataCell(Text(orders[index].classType)),
                        DataCell(Text(orders[index].phoneNumber)),
                        DataCell(Text(orders[index].address)),
                        DataCell(Text(orders[index].total.toString())),
                        DataCell(
                          DropdownButton<String>(
                            value: orders[index].status,
                            icon: const Icon(Icons.arrow_downward, color: Colors.transparent),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.orange),
                            onChanged: (String? newValue) {
                              setState(() {
                                _orderController.updateOrderStatus(orders[index].id, newValue!).then((value) {
                                  setState(() {});
                                });
                              });
                            },
                            items: <String>['Pending', 'Completed', 'Cancelled', 'On Progress']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ),
            );
          }
        },
      ),
    );
  }
}