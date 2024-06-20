// ignore: file_names
import 'package:bill_genie/admin-pages/admin_profile.dart';
import 'package:bill_genie/admin-pages/customer_cash_book.dart';
import 'package:bill_genie/admin-pages/customer_invoice.dart';
import 'package:bill_genie/admin-pages/customer_invoice_list.dart';
import 'package:bill_genie/admin-pages/farmer_cash_book.dart';
import 'package:bill_genie/admin-pages/farmer_invoice.dart';
import 'package:bill_genie/admin-pages/farmer_invoice_list.dart';
import 'package:bill_genie/admin-pages/product_list.dart';
import 'package:bill_genie/admin-pages/settings_page.dart';
import 'package:bill_genie/admin-pages/worker_list.dart';
import 'package:bill_genie/login_page.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String searchQuery = '';
  var height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _showLogoutConfirmation,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 16, 170, 54),
          elevation: 0.0,
          leading: const CustomMenuIcon(
            iconData: Icons.sort,
            color: Colors.white,
            size: 40,
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 22, 180, 61),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminProfile()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.currency_rupee_outlined),
                title: const Text('Customer Balance'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomerCashBook()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.currency_rupee_outlined),
                title: const Text('Farmer Balance'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FarmerCashBook()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Workers'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkerList()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Products & Price'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductList()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  _showLogoutConfirmation();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 16, 170, 54),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 16, 170, 54),
                  ),
                  height: height * 0.10,
                  width: width,
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "BillGenie",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      )),
                  height: height * 0.70,
                  width: width,
                  padding: const EdgeInsets.only(top: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 30,
                    padding: const EdgeInsets.all(7),
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CustomerInvoice()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 25),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 233, 129, 115),
                            boxShadow: const [],
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Invoice To Customer",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FarmerInvoice()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 25),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 241, 211, 127),
                            boxShadow: const [
                              // BoxShadow(
                              //   color: Color.fromARGB(255, 102, 99, 99),
                              //   spreadRadius: 1,
                              //   blurRadius: 3,
                              // )
                            ],
                          ),
                          child: const Align(
                            alignment: Alignment
                                .center, // Center the text at the bottom
                            child: Text(
                              "Invoice To Farmer",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerInvoiceList()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 25),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 241, 233, 107),
                            boxShadow: const [
                              // BoxShadow(
                              //   color: Color.fromARGB(255, 102, 99, 99),
                              //   spreadRadius: 1,
                              //   blurRadius: 3,
                              // )
                            ],
                          ),
                          child: const Align(
                            alignment: Alignment
                                .center, // Center the text at the bottom
                            child: Text(
                              "Customer Invoices",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FarmerInvoiceList()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 35),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 112, 182, 240),
                            boxShadow: const [
                              // BoxShadow(
                              //   color: Color.fromARGB(255, 102, 99, 99),
                              //   spreadRadius: 1,
                              //   blurRadius: 3,
                              // )
                            ],
                          ),
                          child: const Align(
                            alignment: Alignment
                                .center, // Center the text at the bottom
                            child: Text(
                              "Farmer Invoices",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showLogoutConfirmation() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout Confirmation'),
            content: const Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

//custom menu icon
class CustomMenuIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final double size;

  const CustomMenuIcon({
    required this.iconData,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        iconData,
        color: color,
        size: size,
      ),
      onPressed: () => Scaffold.of(context).openDrawer(), // Open drawer on tap
    );
  }
}

@override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);
