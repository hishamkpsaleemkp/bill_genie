import 'package:bill_genie/admin-pages/admin_home.dart';
import 'package:bill_genie/admin-pages/worker_details.dart';
import 'package:bill_genie/admin-pages/worker_registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkerList extends StatefulWidget {
  const WorkerList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WorkerListState createState() => _WorkerListState();
}

class _WorkerListState extends State<WorkerList> {
  final Query<Map<String, dynamic>> _workersCollection = FirebaseFirestore
      .instance
      .collection('users')
      .where('role', isEqualTo: 'worker')
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) => snapshot.data()!,
        toFirestore: (userData, _) => userData,
      );

  void _navigateToWorkerDetails(DocumentSnapshot document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkerDetails(document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 170, 54),
        title: const Text(
          'Workers',
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
            )),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _workersCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
                onTap: () => _navigateToWorkerDetails(document),
                title: Text(
                  data['name'],
                  style: const TextStyle(fontSize: 20.0),
                ),
                subtitle: Text('Phone:${data['phone']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
      floatingActionButton: Container(
        width: 70.0,
        height: 70.0,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WorkerRegistration()));
          },
          backgroundColor: const Color.fromARGB(255, 16, 170, 54),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          splashColor: Color.fromARGB(255, 36, 212, 42),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class Worker {
  final String id;
  final String name;

  Worker({required this.id, required this.name});
}
