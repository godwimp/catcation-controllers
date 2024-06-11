class Message {
  String _id;
  String _message;
  String _sender;
  String _receiver;
  String _timestamp;
  
  Message({
    required String id,
    required String message,
    required String sender,
    required String receiver,
    required String timestamp,
  }) : _id = id, _message = message, _sender = sender, _receiver = receiver, _timestamp = timestamp;

  String get id => _id;
  String get message => _message;
  String get sender => _sender;
  String get receiver => _receiver;
  String get timestamp => _timestamp;

  Map<String, dynamic> toDocument() {
    return {
      'id': _id,
      'message': _message,
      'sender': _sender,
      'receiver': _receiver,
      'timestamp': _timestamp,
    };
  }

  factory Message.fromDocument(Map<String, dynamic> doc) {
    return Message(
      id: doc['id'],
      message: doc['message'],
      sender: doc['sender'],
      receiver: doc['receiver'],
      timestamp: doc['timestamp'],
    );
  }
}