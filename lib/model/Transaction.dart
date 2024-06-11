class Transaction {
  final String _id;
  final String _ownerId;
  final String _service;
  String status;
  final String _paymentMethod;
  final String _address;
  final String _phoneNumber;
  final String _total;
  final String _timestamp;
  final String _checkInDate;
  final String _checkOutDate;
  final String _classType;
  final String _notes;

  Transaction({
    required String id,
    required String ownerId,
    required String service,
    required String status,
    required String paymentMethod,
    required String address,
    required String phoneNumber,
    required String total,
    required String timestamp,
    required String checkInDate,
    required String checkOutDate,
    required String classType,
    required String notes,
  })  : _id = id,
        _ownerId = ownerId,
        _service = service,
        status = status,
        _paymentMethod = paymentMethod,
        _address = address,
        _phoneNumber = phoneNumber,
        _total = total,
        _timestamp = timestamp,
        _checkInDate = checkInDate,
        _checkOutDate = checkOutDate,
        _classType = classType,
        _notes = notes;

  String get id => _id;
  String get ownerId => _ownerId;
  String get service => _service;
  String get paymentMethod => _paymentMethod;
  String get address => _address;
  String get phoneNumber => _phoneNumber;
  String get total => _total;
  String get timestamp => _timestamp;
  String get checkInDate => _checkInDate;
  String get checkOutDate => _checkOutDate;
  String get classType => _classType;
  String get notes => _notes;

  factory Transaction.fromDocument(Map<String, dynamic> doc) {
    return Transaction(
      id: doc['id'],
      ownerId: doc['ownerId'],
      service: doc['service'],
      status: doc['status'],
      paymentMethod: doc['paymentMethod'],
      address: doc['address'],
      phoneNumber: doc['phoneNumber'],
      total: doc['total'],
      timestamp: doc['timestamp'],
      checkInDate: doc['checkInDate'] ?? '',
      checkOutDate: doc['checkOutDate'] ?? '',
      classType: doc['classType'] ?? '',
      notes: doc['notes'] ?? '',
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': _id,
      'ownerId': _ownerId,
      'service': _service,
      'status': status,
      'paymentMethod': _paymentMethod,
      'address': _address,
      'phoneNumber': _phoneNumber,
      'total': _total,
      'timestamp': _timestamp,
      'checkInDate': _checkInDate,
      'checkOutDate': _checkOutDate,
      'classType': _classType,
      'notes': _notes,
    };
  }
}