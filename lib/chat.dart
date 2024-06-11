// make a chat page to chat with other users
// there are two types of users: employee and cat owner
// cat owner can chat with employee
// employee can chat with cat owner

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dahlah/controller/ChatController.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

//use chatcontroller to send and receive messages
//use message.dart as the model for the message

class _ChatState extends State<Chat> {
  final _chatController = ChatController();
  final _messageController = TextEditingController();

  User? _user = FirebaseAuth.instance.currentUser;
  String _selectedUser = '';

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _chatController.getUsers(),
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
            final users = snapshot.data as List;
            return RefreshIndicator(
              onRefresh: _refreshData,
              color: Colors.orange,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('User ID'),
                    ),
                    DataColumn(
                      label: Text('Name'),
                    ),
                  ],
                  rows: users
                      .map(
                        (user) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(user['uid']),
                            ),
                            DataCell(
                              Text(user['name']),
                            ),
                          ],
                          onSelectChanged: (value) {
                            setState(() {
                              _selectedUser = user['uid'];
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Send Message'),
                content: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _chatController.sendMessage(
                        _messageController.text,
                        _selectedUser,
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Send'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}