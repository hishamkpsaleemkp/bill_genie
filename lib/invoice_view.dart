import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

class InvoiceView extends StatelessWidget {
  final String invoiceId;

  // Helper function to format date without time
  String _formatDate(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the date to only include day, month, and year
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  const InvoiceView({Key? key, required this.invoiceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INVOICE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'KPS BANANA MERCHANT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Melattur, Malappuram, PIN 679326',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Ph: 7034642606',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('invoice')
                  .doc(invoiceId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('Invoice not found');
                }

                final invoice = snapshot.data!;
                final date =
                    DateFormat('dd-MM-yyyy').format(invoice['date'].toDate());

                final balamt = invoice['balance_amt'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'INVOICE NO: ${invoice.id.substring(invoice.id.length - 4)}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'DATE: $date',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('persons')
                          .doc(invoice['person_id'])
                          .get(),
                      builder: (context, personSnapshot) {
                        if (personSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!personSnapshot.hasData ||
                            !personSnapshot.data!.exists) {
                          return const Text('Person not found');
                        }

                        final person = personSnapshot.data!;
                        final personPhone =
                            person['phone']; // Fetch phone number

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'NAME: ${person['name']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'PHONE: $personPhone', // Display phone number
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('invoice_details')
                          .where('person_id', isEqualTo: invoice['person_id'])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text('No invoice details found');
                        }

                        final List<DocumentSnapshot> invoiceDetailsDocs =
                            snapshot.data!.docs;

                        final invoiceDate = _formatDate(invoice['date']);

                        final filteredInvoiceDetails =
                            invoiceDetailsDocs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final detailDate = _formatDate(data['date']);
                          return detailDate == invoiceDate;
                        }).toList();

                        double totalAmount = 0;
                        for (final doc in filteredInvoiceDetails) {
                          final data = doc.data() as Map<String, dynamic>;
                          totalAmount +=
                              double.parse(data['amount'].toString());
                        }

                        double finalAmount = totalAmount + balamt;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                label: SizedBox(
                                  width: 20,
                                  child: Text('No.'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 30,
                                  child: Text('Item'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 30,
                                  child: Text('Wght'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 20,
                                  child: Text('Qty'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 40,
                                  child: Text('Price'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 40,
                                  child: Text('L.wght'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 50,
                                  child: Text('Net.whgt'),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 70,
                                  child: Text('Amount'),
                                ),
                              ),
                            ],
                            rows: [
                              ...filteredInvoiceDetails.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final rowIndex =
                                    invoiceDetailsDocs.indexOf(doc) + 1;

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: 20,
                                        child: Text('$rowIndex'),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 30,
                                        child: Text('${data['item']}'),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 30,
                                        child: Text('${data['weight']}'),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 20,
                                        child: Text('${data['quantity']}'),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 40,
                                        child: Text('${data['price']}'),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 40,
                                        child: Text('${data['lessWeight']}'),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 50,
                                        child: Text('${data['netWeight']}'),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 70,
                                        child: Text('${data['amount']}'),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              DataRow(
                                cells: [
                                  DataCell(SizedBox(width: 20)),
                                  DataCell(SizedBox(width: 30)),
                                  DataCell(SizedBox(width: 30)),
                                  DataCell(SizedBox(width: 20)),
                                  DataCell(SizedBox(width: 40)),
                                  DataCell(SizedBox(width: 40)),
                                  DataCell(SizedBox(
                                    width: 60,
                                    child: Text('Total:'),
                                  )),
                                  DataCell(
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                          '${totalAmount.toStringAsFixed(2)}'),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(SizedBox(width: 20)),
                                  DataCell(SizedBox(width: 30)),
                                  DataCell(SizedBox(width: 30)),
                                  DataCell(SizedBox(width: 20)),
                                  DataCell(SizedBox(width: 40)),
                                  DataCell(SizedBox(width: 40)),
                                  DataCell(SizedBox(
                                    width: 60,
                                    child: Text('Balance:'),
                                  )),
                                  DataCell(
                                    SizedBox(
                                      width: 70,
                                      child:
                                          Text('${balamt.toStringAsFixed(2)}'),
                                    ),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: [
                                  DataCell(SizedBox(width: 20)),
                                  DataCell(SizedBox(width: 30)),
                                  DataCell(SizedBox(width: 30)),
                                  DataCell(SizedBox(width: 20)),
                                  DataCell(SizedBox(width: 40)),
                                  DataCell(SizedBox(width: 40)),
                                  DataCell(SizedBox(
                                    width: 60,
                                    child: Text('Amount:'),
                                  )),
                                  DataCell(
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                          '${finalAmount.toStringAsFixed(2)}'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              deleteBalanceAndDetailsAndInvoice(context,
                  invoiceId); // Call function to delete balance and invoice details
            },
            icon: Icon(Icons.delete),
            label: Text('Delete'),
            backgroundColor: Color.fromARGB(255, 248, 37, 9),
          ),
          SizedBox(width: 10),
          FloatingActionButton.extended(
            onPressed: () {
              _shareInvoice(context); // Call function to share invoice
            },
            icon: Icon(Icons.share),
            label: Text('Share'),
            backgroundColor: Colors.blue,
          ),
          SizedBox(width: 10),
          FloatingActionButton.extended(
            onPressed: () {
              // Handle printing functionality
            },
            icon: Icon(Icons.print),
            label: Text('Print'),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Function to share invoice
  void _shareInvoice(BuildContext context) {
    // Define the message to share
    String message = 'Your message here';

    // Define the URL scheme for WhatsApp
    String urlScheme = 'whatsapp://send?text=$message';

    // Try to launch WhatsApp with the provided message
    launch(urlScheme).then((value) {
      // Handle success
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing invoice'),
        ),
      );
    });
  }

  // Function to delete balance and invoice details
  Future<void> deleteBalanceAndDetailsAndInvoice(
      BuildContext context, String invoiceId) async {
    try {
      // Fetch the invoice details
      DocumentSnapshot invoiceSnapshot = await FirebaseFirestore.instance
          .collection('invoice')
          .doc(invoiceId)
          .get();

      if (!invoiceSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invoice not found'),
          ),
        );
        return;
      }

      final invoice = invoiceSnapshot.data() as Map<String, dynamic>;
      final personId = invoice['person_id'];

      // Fetch the balance document for the person
      QuerySnapshot balanceQuerySnapshot = await FirebaseFirestore.instance
          .collection('balance')
          .where('person_id', isEqualTo: personId)
          .limit(1)
          .get();

      if (balanceQuerySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Balance not found for this person'),
          ),
        );
        return;
      }

      final balanceDoc = balanceQuerySnapshot.docs.first;
      final balanceData = balanceDoc.data() as Map<String, dynamic>;

      // Calculate the total amount from invoice details
      QuerySnapshot invoiceDetailsSnapshot = await FirebaseFirestore.instance
          .collection('invoice_details')
          .where('person_id', isEqualTo: personId)
          .get();

      final invoiceDate = _formatDate(invoice['date']);

      double totalAmount = 0;
      for (var doc in invoiceDetailsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (_formatDate(data['date']) == invoiceDate) {
          totalAmount += double.parse(data['amount'].toString());
        }
      }

      // Deduct the total amount from the balance
      double currentBalance = double.parse(balanceData['amount'].toString());
      double newBalance = currentBalance - totalAmount;

      // Update the balance in Firestore
      await FirebaseFirestore.instance
          .collection('balance')
          .doc(balanceDoc.id)
          .update({'amount': newBalance});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Balance updated successfully'),
        ),
      );

      // Delete the invoice details
      await deleteInvoiceDetails(personId, invoiceDate);

      // Delete the invoice document
      await deleteInvoice(invoiceId);
      // Navigate to the previous page
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error updating balance, deleting invoice details, or deleting invoice'),
        ),
      );
    }
  }

  // Function to delete invoice details
  Future<void> deleteInvoiceDetails(String personId, String invoiceDate) async {
    try {
      QuerySnapshot invoiceDetailsSnapshot = await FirebaseFirestore.instance
          .collection('invoice_details')
          .where('person_id', isEqualTo: personId)
          .get();

      for (var doc in invoiceDetailsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (_formatDate(data['date']) == invoiceDate) {
          await FirebaseFirestore.instance
              .collection('invoice_details')
              .doc(doc.id)
              .delete();
        }
      }
    } catch (error) {
      throw Exception('Error deleting invoice details');
    }
  }

  // Function to delete the invoice document
  Future<void> deleteInvoice(String invoiceId) async {
    try {
      await FirebaseFirestore.instance
          .collection('invoice')
          .doc(invoiceId)
          .delete();
    } catch (error) {
      throw Exception('Error deleting invoice');
    }
  }
}
