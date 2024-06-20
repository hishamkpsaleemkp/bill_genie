import 'package:bill_genie/admin-pages/admin_home.dart';
import 'package:bill_genie/invoice_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FarmerInvoice extends StatefulWidget {
  const FarmerInvoice({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FarmerInvoiceState createState() => _FarmerInvoiceState();
}

class _FarmerInvoiceState extends State<FarmerInvoice> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _items = [];
  String? _selectedItem;
  List<String> _productNames = [];
  Map<String, dynamic>? _productPrices;
  bool _isSaving = false;
  // ignore: non_constant_identifier_names
  double total_amount = 0.0;
  String personId = '';

  bool _isValidName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }
    return true;
  }

  bool _isValidPhone(String? value) {
    if (value == null || value.trim().isEmpty || value.length != 10) {
      return false;
    }
    return true;
  }

  Future<void> _getProductNames() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      _productNames =
          snapshot.docs.map((doc) => doc.get('name') as String).toList();
    });
  }

  Future<void> _updatePriceField(String? selectedItem) async {
    if (selectedItem != null &&
        _productPrices != null &&
        _productPrices!.containsKey(selectedItem)) {
      _priceController.text =
          _productPrices![selectedItem]?.toStringAsFixed(2) ?? '';
    } else {
      _priceController.text = '';
    }
  }

  Future<void> _getProductPrices() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      _productPrices = {
        for (var doc in snapshot.docs) doc.get('name'): doc.get('price')
      };
    });
  }

  Future<void> _savePerson() async {
    if (_formKey.currentState?.validate() ?? false) {
      String phone = _phoneController.text.trim();
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('persons')
          .where('phone', isEqualTo: phone)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String existingName = snapshot.docs.first.get('name');
        personId = snapshot.docs.first.id; // Get the document ID
        _nameController.text = existingName;
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Person already exists with name: $existingName'),
            backgroundColor: Colors.red,
          ),
        );
        _showItemWidget(personId); // Pass the personId to _showItemWidget
      } else {
        setState(() {
          _isSaving = true;
        });
        try {
          // Save person to Firestore and get the document ID
          DocumentReference personRef = await _savePersonToFirestore(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            role: 'farmer',
          );

          personId = personRef.id; // Get the document ID

          // Save initial balance record with the person's document ID
          await _saveInitialBalance(personId, _phoneController.text.trim());

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Farmer saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _showItemWidget(personId); // Pass the personId to _showItemWidget
        } catch (e) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving person: $e'),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  Future<DocumentReference> _savePersonToFirestore({
    required String name,
    required String phone,
    required String role,
  }) async {
    return await FirebaseFirestore.instance.collection('persons').add({
      'name': name,
      'phone': phone,
      'role': role,
    });
  }

  Future<void> _saveInitialBalance(String personId, String phone) async {
    await FirebaseFirestore.instance.collection('balance').add({
      'person_id': personId,
      'phone': phone,
      'amount': 0.00,
      'date': DateTime.now(),
    });
  }

  void _showItemWidget(String personId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedItem,
                    items: _productNames
                        .map((name) => DropdownMenuItem<String>(
                            value: name, child: Text(name)))
                        .toList(),
                    onChanged: (value) async {
                      _selectedItem = value;
                      await _updatePriceField(
                          value); // Update price on selection change
                    },
                    decoration: const InputDecoration(
                      labelText: 'Item',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value != null ? null : 'Please select an item',
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Weight',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.trim().isNotEmpty ?? false
                        ? null
                        : 'Please enter a weight',
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.trim().isNotEmpty ?? false
                        ? null
                        : 'Please enter a quantity',
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    enabled: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.trim().isNotEmpty ?? false
                        ? null
                        : 'Please enter a price',
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ??
                          // ignore: dead_code
                          false && _selectedItem != null) {
                        Map<String, dynamic> itemData = {
                          'item': _selectedItem!,
                          'weight': _weightController.text.trim(),
                          'quantity': _quantityController.text.trim(),
                          'price': _priceController.text.trim(),
                        };
                        setState(() {
                          _items.add(calculate_item(itemData));
                          total_amount +=
                              double.parse(calculate_item(itemData)['amount']!);
                        });
                        _saveInvoiceDetails(personId,
                            itemData); // Pass personId to _saveInvoiceDetails
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 16, 170, 54),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveInvoiceDetails(
      String personId, Map<String, dynamic> itemData) async {
    try {
      Map<String, dynamic> calculatedItem = calculate_item(itemData);
      await FirebaseFirestore.instance.collection('invoice_details').add({
        'person_id': personId,
        'item': calculatedItem['item'],
        'date': DateTime.now(),
        'weight': calculatedItem['weight'],
        'quantity': calculatedItem['quantity'],
        'price': calculatedItem['price'],
        'avg': calculatedItem['avg'],
        'lessWeight': calculatedItem['lessWeight'],
        'netWeight': calculatedItem['netWeight'],
        'amount': calculatedItem['amount'],
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving invoice details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ignore: non_constant_identifier_names
  Map<String, dynamic> calculate_item(Map<String, dynamic> itemData) {
    double weight = double.parse(itemData['weight']!);
    double quantity = double.parse(itemData['quantity']!);
    double price = double.parse(itemData['price']!);

    double avg = weight / quantity;
    double lessWeight;

    if (avg < 20) {
      lessWeight = quantity * 1.5;
    } else {
      lessWeight = quantity * 2;
    }

    double netWeight = weight - lessWeight;
    double amount = netWeight * price;

    return {
      'item': itemData['item'],
      'weight': itemData['weight'],
      'quantity': itemData['quantity'],
      'price': itemData['price'],
      'avg': avg.toStringAsFixed(2),
      'lessWeight': lessWeight.toStringAsFixed(2),
      'netWeight': netWeight.toStringAsFixed(2),
      'amount': amount.toStringAsFixed(2),
    };
  }

  Future<void> _generateInvoice() async {
    if (personId.isNotEmpty && total_amount > 0.0) {
      try {
        // Get the balance amount and date from the 'balance' collection
        QuerySnapshot balanceSnapshot = await FirebaseFirestore.instance
            .collection('balance')
            .where('person_id', isEqualTo: personId)
            .get();

        double balanceAmt = 0.0;
        DateTime balDate = DateTime.now();
        DateTime indate = DateTime.now();
        DateFormat('MMM d, yyyy').format(indate);

        if (balanceSnapshot.docs.isNotEmpty) {
          balanceAmt = balanceSnapshot.docs.first.get('amount');
          balDate = balanceSnapshot.docs.first.get('date').toDate();
        }

        // Store the invoice details in the 'invoice' collection
        DocumentReference invoiceRef =
            await FirebaseFirestore.instance.collection('invoice').add({
          'person_id': personId,
          'date': DateTime.now(),
          'total_amt': total_amount,
          'balance_amt': balanceAmt,
          'bal_date': balDate,
        });

        String invoiceDocId = invoiceRef.id; // Get the generated document ID

        double newBalanceAmt = balanceAmt + total_amount;
        await FirebaseFirestore.instance
            .collection('balance')
            .doc(balanceSnapshot.docs.first.id)
            .update({
          'amount': newBalanceAmt,
          'date': DateTime.now(),
        });

        // Reset the total_amount and clear the _items list
        setState(() {
          total_amount = 0.0;
          _items.clear();
        });

        // Navigate to InvoiceView passing the invoice document ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvoiceView(invoiceId: invoiceDocId),
          ),
        );

        // await pdfGenerate(invoiceDocId);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invoice added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating invoice: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add items and fill in the required fields.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getProductNames();
    _getProductPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 170, 54),
        title: const Text(
          'Farmer Invoice',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminHome()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _isValidName(value) ? null : 'Please enter a valid name',
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _isValidPhone(value)
                      ? null
                      : 'Please enter a valid phone number',
                ),
                const SizedBox(height: 16.0),
                if (_isSaving)
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: CircularProgressIndicator(),
                  )
                else
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await _savePerson();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 16, 170, 54),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                const SizedBox(height: 16.0),
                ..._items.map((item) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Item: ${item['item']}'),
                              const SizedBox(height: 8.0),
                              Text('Weight: ${item['weight']}'),
                              const SizedBox(height: 8.0),
                              Text('Quantity: ${item['quantity']}'),
                              const SizedBox(height: 8.0),
                              Text('Price: ${item['price']}'),
                              const SizedBox(height: 8.0),
                              Text('Avg: ${item['avg']}'),
                              const SizedBox(height: 8.0),
                              Text('Less Weight: ${item['lessWeight']}'),
                              const SizedBox(height: 8.0),
                              Text('Net Weight: ${item['netWeight']}'),
                              const SizedBox(height: 8.0),
                              Text('Amount: ${item['amount']}'),
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          // Show total amount
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Total Amount'),
                                content:
                                    Text('₹${total_amount.toStringAsFixed(2)}'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        // ignore: sort_child_properties_last
                        child: const Text('TOTAL'),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 4.0,
                        shape: const CircleBorder(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: _generateInvoice,
                        // ignore: sort_child_properties_last
                        child: const Icon(Icons.receipt),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 4.0,
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (personId.isNotEmpty) {
                        _showItemWidget(personId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('please fill the above fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
