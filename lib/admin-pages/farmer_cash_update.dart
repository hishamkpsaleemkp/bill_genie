import 'package:bill_genie/admin-pages/farmer_cash_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmerCashUpdate extends StatefulWidget {
  final String phone;
  final double balance;
  final String name;

  const FarmerCashUpdate({
    Key? key,
    required this.phone,
    required this.balance,
    required this.name,
  }) : super(key: key);

  @override
  _FarmerCashUpdateState createState() => _FarmerCashUpdateState();
}

class _FarmerCashUpdateState extends State<FarmerCashUpdate> {
  String? date;
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDate();
  }

  Future<void> fetchDate() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('balance')
          .where('phone', isEqualTo: widget.phone)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final Timestamp timestamp = querySnapshot.docs.first['date'];
        final DateTime dateTime = timestamp.toDate();
        final DateFormat formatter =
            DateFormat.yMMMd(); // Adjust the format as needed
        final String formattedDate = formatter.format(dateTime);

        setState(() {
          date = formattedDate;
        });
      } else {
        setState(() {
          date = 'Not Found';
        });
      }
    } catch (error) {
      setState(() {
        date = 'Error: $error';
      });
    }
  }

  Future<void> updateBalance() async {
    try {
      double enteredAmount = double.parse(_amountController.text);
      double newBalance = widget.balance - enteredAmount;

      // Query the documents where the 'phone' field matches the provided phone number
      var querySnapshot = await FirebaseFirestore.instance
          .collection('balance')
          .where('phone', isEqualTo: widget.phone)
          .get();

      // Check if any document matches the query
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document in the result set
        var docSnapshot = querySnapshot.docs.first;

        // Update the 'amount' field in the document
        await docSnapshot.reference.update({'amount': newBalance});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Balance updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document not found for the provided phone number.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update balance: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 170, 54),
        title: const Text(
          'Farmer cash update',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FarmerCashBook()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Name:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 10, 10, 10),
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 2, 2, 2),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Date:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 3, 3, 3),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 180), // Add some space here
                Text(
                  date ??
                      'Loading...', // Display the fetched date or 'Loading...' if it's still loading
                  style: const TextStyle(
                    color: Color.fromARGB(255, 10, 10, 10),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Balance Amt:',
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 13, 13),
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.balance.toString(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 7, 7, 7),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Cash Paid:',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Amount',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 16, 170, 54),
              ),
              onPressed: () {
                if (_amountController.text.isNotEmpty) {
                  updateBalance();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter an amount.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'UPDATE',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
