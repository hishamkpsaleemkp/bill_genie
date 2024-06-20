import 'package:bill_genie/admin-pages/admin_home.dart';
import 'package:bill_genie/invoice_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmerInvoiceList extends StatefulWidget {
  const FarmerInvoiceList({Key? key}) : super(key: key);

  @override
  _FarmerInvoiceListState createState() => _FarmerInvoiceListState();
}

class _FarmerInvoiceListState extends State<FarmerInvoiceList> {
  String searchDate = '';
  final _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> invoiceList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 170, 54),
        title: const Text(
          'Farmer',
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
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Search Date:',
                  style: TextStyle(fontSize: 16.0),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        searchDate =
                            DateFormat('MMM d,yyyy').format(selectedDate);
                      });
                    }
                  },
                  child: Text(
                    searchDate.isEmpty ? 'Select Date' : searchDate,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (searchDate.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a search date'),
                    ),
                  );
                } else {
                  final formattedSearchDate =
                      DateFormat('MMM d,yyyy').parse(searchDate);

                  final snapshot = await _firestore.collection('invoice').get();

                  setState(() {
                    invoiceList = snapshot.docs.where((doc) {
                      final Timestamp timestamp = doc['date'];
                      final DateTime invoiceDate = timestamp.toDate();
                      // Check if the date part matches
                      return DateFormat('yyyy-MM-dd').format(invoiceDate) ==
                          DateFormat('yyyy-MM-dd').format(formattedSearchDate);
                    }).toList();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 17, 168, 55),
              ),
              child: const Text(
                'SEARCH',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: invoiceList.isEmpty
                  ? const Center(
                      child: Text(
                        'No data found for the selected date',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )
                  : ListView.builder(
                      itemCount: invoiceList.length,
                      itemBuilder: (context, index) {
                        final invoice = invoiceList[index];
                        final personId = invoice['person_id'];
                        final Timestamp timestamp = invoice['date'];
                        final DateTime invoiceDate = timestamp.toDate();

                        return FutureBuilder<DocumentSnapshot>(
                          future: _firestore
                              .collection('persons')
                              .doc(personId)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(); // Return an empty SizedBox instead of loading text
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            final person = snapshot.data!;
                            final customerName = person['name'];
                            final customerRole = person['role'];

                            if (customerRole == 'farmer') {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          InvoiceView(invoiceId: invoice.id),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        customerName,
                                        style: const TextStyle(fontSize: 20.0),
                                      ),
                                      subtitle: Text(
                                        '${DateFormat('MMM d, yyyy').format(invoiceDate)} ',
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      trailing: Text(
                                        'ID: ${invoice.id}',
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                    const Divider(), // Add a separation line
                                  ],
                                ),
                              );
                            } else {
                              // If person's role is not 'customer', return an empty container
                              return const SizedBox();
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
