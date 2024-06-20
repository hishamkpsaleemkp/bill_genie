import 'package:bill_genie/worker-pages/cash_update.dart';
import 'package:bill_genie/worker-pages/worker_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CashBook extends StatefulWidget {
  const CashBook({super.key});

  @override
  _CashBookState createState() => _CashBookState();
}

class _CashBookState extends State<CashBook> {
  String searchText = "";
  List<QueryDocumentSnapshot<Object?>>? filteredBalances;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 179, 165),
        title: const Text(
          'Farmer Cash Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WorkerHome()),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by phone number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                        filteredBalances = null; // Reset filtered list
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    filterBalancesByPhone();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('balance').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final balances = snapshot.data!.docs;

                if (filteredBalances == null) {
                  // Show all balances initially
                  return ListView.builder(
                    itemCount: balances.length,
                    itemBuilder: (context, index) {
                      final balance = balances[index];
                      return _buildListTile(balance);
                    },
                  );
                } else {
                  // Show only filtered balances
                  return ListView.builder(
                    itemCount: filteredBalances!.length,
                    itemBuilder: (context, index) {
                      final balance = filteredBalances![index];
                      return _buildListTile(balance);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(QueryDocumentSnapshot<Object?> balance) {
    final personId = balance['person_id'];
    final phone = balance['phone'];
    final amount = balance['amount'];

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('persons').doc(personId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ListTile(
            title: Text('Loading...'),
          );
        }

        final data = snapshot.data!.data();
        if (data == null || data is! Map<String, dynamic>) {
          return const ListTile(
            title: Text('Error fetching person data'),
          );
        }

        final name = data['name'];
        final role = data['role'];

        if (role != 'farmer') {
          return const SizedBox.shrink();
        }

        return ListTile(
          title: Text(
            '$name ',
            style: const TextStyle(fontSize: 20.0),
          ),
          subtitle: Text(
            '$phone',
            style: const TextStyle(fontSize: 16.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.currency_rupee),
              Text(
                ' $amount',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CashUpdate(phone: phone, balance: amount, name: name),
              ),
            );
          },
        );
      },
    );
  }

  void filterBalancesByPhone() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('balance')
        .where('phone', isEqualTo: searchText)
        .get();

    setState(() {
      filteredBalances = snapshot.docs.cast<QueryDocumentSnapshot<Object?>>();
    });
  }
}
