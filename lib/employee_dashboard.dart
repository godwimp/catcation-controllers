import 'package:dahlah/transaction_table.dart';
import 'package:dahlah/widget_tree.dart';
import 'package:dahlah/widget_tree_employee.dart';
import 'package:flutter/material.dart';
import 'package:dahlah/controller/AuthController.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({Key? key}) : super(key: key);

  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  String _pages = 'Transaction';
  Widget _currentPage = TransactionTable();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Material(
          elevation: 5.0,
          child: AppBar(
            title: Text(_pages, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            backgroundColor: Color.fromARGB(255, 255, 247, 232),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.orange),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.orange),
                onPressed: () {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 247, 232)
              ),
              child: Center(
                child: Text(
                  'CatCation.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Transaction'),
              onTap: () {
                setState(() {
                  _pages = 'Transaction';
                  _currentPage = TransactionTable();
                });
              },
            ),
            ListTile(
              title: Text('Cat List'),
              onTap: () {
                setState(() {
                  _pages = 'Cat List';
                });
              },
            ),
            ListTile(
              title: Text('Employee List'),
              onTap: () {
                setState(() {
                  _pages = 'Employee List';
                });
              },
            ),
            ListTile(
              title: Text('Online Shop'),
              onTap: () {
                setState(() {
                  _pages = 'Online Shop';
                });
              },
            ),
            ListTile(
              title: Text('Article'),
              onTap: () {
                setState(() {
                  _pages = 'Article';
                });
              },
            ),
            ListTile(
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                AuthController().signOut();
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WidgetTreeEmployee()), (route) => false);
                });
              },
            ),
          ],
        ),
      ),
      body: _currentPage,
    );
  }
}