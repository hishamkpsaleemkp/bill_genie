import 'dart:io';
import 'package:bill_genie/admin-pages/admin_profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  File? _imageFile;
  String? _name;
  String? _email;
  String? _phone;

  @override
  void initState() {
    super.initState();
    _fetchAdminProfile();
  }

  Future<void> _fetchAdminProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data();
          setState(() {
            _name = data?['name'];
            _email = data?['email'];
            _phone = data?['phone'];
          });
        } else {
          print('No user document found for the current user.');
        }
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error fetching admin profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 170, 54),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                // onTap: _getImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey[800],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              if (_name != null)
                Text(
                  ' $_name',
                  style: const TextStyle(fontSize: 20.0),
                ),
              if (_email != null)
                Text(
                  ' $_email',
                  style: const TextStyle(fontSize: 18.0),
                ),
              if (_phone != null)
                Text(
                  ' $_phone',
                  style: const TextStyle(fontSize: 18.0),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 168, 55),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminProfileEdit(),
                    ),
                  );
                  // Implement update functionality
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
