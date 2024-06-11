import 'package:dahlah/controller/OrderController.dart';
import 'package:dahlah/model/Transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CatHealthPage extends StatefulWidget {
  const CatHealthPage({Key? key}) : super(key: key);

  @override
  _catHealthPageState createState() => _catHealthPageState();
}

class _catHealthPageState extends State<CatHealthPage> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _catNameController = TextEditingController();

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
                        'CAT HEALTH',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cat Health is a specialized service offering comprehensive health care for cats, including vaccinations, routine check-ups, disease treatment, and nutritional counseling. Staffed by experienced professionals, "Cat Health" is committed to providing top-tier care focused on your pet’s well-being and happiness.',
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
                if (_addressController.text.isEmpty) {
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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return PaymentModal(
                        catName: _catNameController.text,
                        address: _addressController.text,
                        service: 'Cat Health',
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
  final String _catName;
  final String _address;
  final String _service;
  final String _notes;
  
  const PaymentModal({
    Key? key,
    required String catName,
    required String address,
    required String service,
    required String notes,
  })  : _catName = catName,
        _address = address,
        _service = service,
        _notes = notes,
        super(key: key);

  @override
  _PaymentModalState createState() => _PaymentModalState();
}

//payment modal shows all the details and payment method

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
            'Details',
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
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  widget._catName,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
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
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  widget._address,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                  address: widget._address,
                  phoneNumber: user.phoneNumber ?? '',
                  timestamp: DateTime.now().toString(),
                  total: '',
                  paymentMethod: '',
                  checkInDate: '',
                  checkOutDate: '',
                  classType: '',
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