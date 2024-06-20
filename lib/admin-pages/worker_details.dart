import 'package:bill_genie/admin-pages/worker_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkerDetails extends StatefulWidget {
  final DocumentSnapshot worker;

  WorkerDetails(this.worker);

  @override
  _WorkerDetailsState createState() => _WorkerDetailsState();
}

class _WorkerDetailsState extends State<WorkerDetails> {
  String Name = '';
  String Phone = '';
  String Email = '';
  String Password = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _getWorkerDetails();
  }

  void _getWorkerDetails() {
    if (widget.worker.exists) {
      setState(() {
        Name = widget.worker.get('name');
        Phone = widget.worker.get('phone');
        Email = widget.worker.get('email');
        Password = widget.worker.get('password');
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _deleteWorker() async {
    try {
      // Get the user's email and password from Firestore
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.worker.id)
          .get();
      final email = user.get('email');
      final password = user.get('password');
// Sign out the current user
      await FirebaseAuth.instance.signOut();

      // Sign in the user with the retrieved email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Delete the user from Firebase Authentication
      await FirebaseAuth.instance.currentUser?.delete();

      // Delete the user from Firestore
      await widget.worker.reference.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Worker deleted successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 243, 116, 31),
          content: Text('Error deleting worker: $e'),
          duration: const Duration(seconds: 2),
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
          'Worker Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WorkerList()),
              );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name:         $Name',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Phone:        $Phone',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email:         $Email',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Password:  $Password',
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 201, 16, 16),
                          ),
                          onPressed: _deleteWorker,
                          child: const Text(
                            'Delete',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
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
