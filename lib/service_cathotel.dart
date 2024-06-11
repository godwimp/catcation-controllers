import 'package:dahlah/controller/OrderController.dart';
import 'package:dahlah/model/Transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CatHotelPage extends StatefulWidget {
  const CatHotelPage({Key? key}) : super(key: key);

  @override
  _CatHotelPageState createState() => _CatHotelPageState();
}

class _CatHotelPageState extends State<CatHotelPage> {
  final TextEditingController _checkInDateController = TextEditingController();
  final TextEditingController _checkOutDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _catNameController = TextEditingController();
  String _selectedClass = '';
  int _price = 0;
  int _totalPrice = 0;
  int _totalDays = 0;

  void _selectClass(String selectedClass, int price) {
    setState(() {
      _selectedClass = selectedClass;
      _price = price;
    });
  }

  void _countTotalPrice() {
    final DateTime checkInDate = DateTime.parse(_checkInDateController.text);
    final DateTime checkOutDate = DateTime.parse(_checkOutDateController.text);
    final int difference = checkOutDate.difference(checkInDate).inDays;
    _totalPrice = _price * difference;
  }

  void _countTotalDays() {
    final DateTime checkInDate = DateTime.parse(_checkInDateController.text);
    final DateTime checkOutDate = DateTime.parse(_checkOutDateController.text);
    _totalDays = checkOutDate.difference(checkInDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/article.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CAT HOTEL',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Offer your cat a comfortable and safe stay at our Cat Hotel. With facilities designed specifically for feline well-being, such as cozy private rooms, spacious play areas, and daily care provided with love and attention, you can rest assured that your cat will receive the best attention while you\'re away.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Cat name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      TextField(
                        controller: _catNameController,
                        decoration: InputDecoration(
                          hintText: 'Insert your cat\'s name here',
                          prefixIcon: const Icon(
                            Icons.pets,
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText: 'Insert your location here',
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Colors.orange,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Check-in date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      TextField(
                        controller: _checkInDateController,
                        decoration: InputDecoration(
                          hintText: 'Insert your check-in date here',
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.orange,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365 * 5)),
                            );
                          if (date != null) {
                            _checkInDateController.text = date.toString().substring(0, 10);
                          }
                        }
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Check-out date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      TextField(
                        controller: _checkOutDateController,
                        decoration: InputDecoration(
                          hintText: 'Insert your check-out date here',
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.orange,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365 * 5)),
                            );
                          if (date != null) {
                            _checkOutDateController.text = date.toString().substring(0, 10);
                          }
                        }
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select Class',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _selectClass('Standard', 150000);
                              },
                              onLongPress: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Standard Class',
                                        style: TextStyle(
                                          color: Colors.orange,
                                        ),
                                      ),
                                      content: const Text('Standard Class is the most affordable class with a price of Rp. 150.000/night. This class is suitable for cats who are used to living in a simple environment.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Close',
                                            style: TextStyle(
                                              color: Colors.orange,),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                );
                              },
                              child: Card(
                                color: _selectedClass == 'Standard' ? Colors.orange : Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Standard',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Rp. 150.000',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _selectClass('Deluxe', 250000);
                              },
                              onLongPress: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Deluxe Class',
                                        style: TextStyle(
                                          color: Colors.orange,
                                        ),
                                      ),
                                      content: const Text('Deluxe Class is a class with a price of Rp. 250.000/night. This class is suitable for cats who are used to living in a luxurious environment.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Close',
                                            style: TextStyle(
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                );
                              },
                              child: Card(
                                color: _selectedClass == 'Deluxe' ? Colors.orange : Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Deluxe',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Rp. 250.000',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Notes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Insert your notes here',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                )
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                if (_selectedClass.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please select a class for your cat.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    }
                  );
                } else if (_checkInDateController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please insert your check-in date.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    }
                  );
                } else if (_checkOutDateController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please insert your check-out date.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    }
                  );
                } else if (_addressController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please insert your address.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    }
                  );
                }else{
                  _countTotalPrice();
                  _countTotalDays();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return PaymentModal(
                        totalPrice: _totalPrice,
                        catName: _catNameController.text,
                        address: _addressController.text,
                        totalDays: _totalDays.toString(),
                        service: 'Cat Hotel',
                        checkInDate: _checkInDateController.text,
                        checkOutDate: _checkOutDateController.text,
                        classType: _selectedClass,
                        notes: _notesController.text,
                      );
                    },
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}

class PaymentModal extends StatefulWidget {
  final int _totalPrice;
  final String _catName;
  final String _address;
  final String _totalDays;
  final String _service;
  String _paymentMethod = 'Credit Card';
  final String _checkInDate;
  final String _checkOutDate;
  final String _classType;
  final String _notes;
  
  PaymentModal({
    Key? key,
    required int totalPrice,
    required String catName,
    required String address,
    required String totalDays,
    required String service,
    required String checkInDate,
    required String checkOutDate,
    required String classType,
    required String notes,
  })  : _totalPrice = totalPrice,
        _catName = catName,
        _address = address,
        _totalDays = totalDays,
        _service = service,
        _checkInDate = checkInDate,
        _checkOutDate = checkOutDate,
        _classType = classType,
        _notes = notes,
        super(key: key);

  @override
  _PaymentModalState createState() => _PaymentModalState();
}



class _PaymentModalState extends State<PaymentModal> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cat Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget._catName,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget._address,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Service',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget._service,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Days',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget._totalDays,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp. ${widget._totalPrice}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          // dropdown button for payment method
          DropdownButton<String>(
            isExpanded: true,
            value: widget._paymentMethod,
            items: <String>['Credit Card', 'Bank Transfer', 'OVO', 'GoPay', 'DANA']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                widget._paymentMethod = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final Transaction transaction = Transaction(
                  id: const Uuid().v4(),
                  ownerId: user.uid,
                  service: widget._service,
                  status: 'Pending',
                  paymentMethod: widget._paymentMethod,
                  address: widget._address,
                  phoneNumber: user.phoneNumber ?? '',
                  total: widget._totalPrice.toString(),
                  timestamp: DateTime.now().toString(), 
                  checkInDate: widget._checkInDate,
                  checkOutDate: widget._checkOutDate,
                  classType: widget._classType,
                  notes: widget._notes,
                );
                await OrderController().addOrder(transaction);
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Success'),
                      content: const Text('Your transaction has been added.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  }
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Please login first.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  }
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Pay Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}