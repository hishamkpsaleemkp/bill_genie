import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bill_genie/login_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a dialog when back button is pressed
        bool? result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );

        // If the user selects "Yes", exit the app
        if (result ?? false) {
          // Call the system's exit method
          // This will close the app immediately
          exit(0);
        }

        // Return false to prevent the default back button behavior
        return false;
      },
      child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 249, 249, 250),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add some space at the top
              Image.asset(
                'assets/images/billgenie.png', // Replace with your logo image path
                height: 100, // Adjust the height as needed
              ),
              const SizedBox(height: 20),
              const Text(
                'Bill Genie',
                style: TextStyle(
                  color: Color.fromARGB(255, 16, 170, 54),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 40,
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 17, 168, 55),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'ADMIN',
                    style: TextStyle(
                      color: Color.fromARGB(255, 236, 234, 234),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 17, 168, 55),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'WORKER',
                    style: TextStyle(
                      color: Color.fromARGB(255, 236, 234, 234),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              const SizedBox(
                height: 40,
                width: 300,
                child: Center(
                  child: Text(
                    'Choose Your Role and Continue..',
                    style: TextStyle(
                      color: Color.fromARGB(255, 32, 32, 32),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
