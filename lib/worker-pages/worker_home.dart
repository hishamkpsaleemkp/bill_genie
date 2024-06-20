import 'package:bill_genie/login_page.dart';
import 'package:bill_genie/worker-pages/cash_book.dart';
import 'package:bill_genie/worker-pages/invoice.dart';
import 'package:bill_genie/worker-pages/invoice_list.dart';
import 'package:bill_genie/worker-pages/products_page.dart';
import 'package:bill_genie/worker-pages/worker_profile.dart';
import 'package:bill_genie/worker-pages/worker_settings.dart';
import 'package:flutter/material.dart';

class WorkerHome extends StatefulWidget {
  const WorkerHome({Key? key}) : super(key: key);

  @override
  _WorkerHomeState createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
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
          backgroundColor: const Color.fromARGB(255, 11, 179, 165),
          elevation: 0.0,
          leading: const CustomMenuIcon(
            iconData: Icons.sort,
            color: Colors.white,
            size: 40,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WorkerProfile()),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 11, 179, 165),
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
              // ListTile(
              //   leading: const Icon(Icons.person),
              //   title: const Text('Profile'),
              //   onTap: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(builder: (context) => const ProfilePage()),
              //     // );
              //   },
              // ),
              const Divider(),
              // ListTile(
              //   leading: const Icon(Icons.currency_rupee_outlined),
              //   title: const Text('Farmer Balance'),
              //   onTap: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //       builder: (context) => const FarmerCashBookPage()),
              //     // );
              //   },
              // ),
              // ListTile(
              //   leading: const Icon(Icons.library_books_sharp),
              //   title: const Text('Products & Price'),
              //   onTap: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //       builder: (context) => const ProductListPage()),
              //     // );
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WorkerSettings()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 11, 179, 165),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 11, 179, 165),
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
                                builder: (context) => const Invoice()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 25),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 233, 129, 115),
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
                                builder: (context) => const InvoiceList()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 241, 211, 127),
                          ),
                          child: const Align(
                            alignment: Alignment
                                .center, // Center the text at the bottom
                            child: Text(
                              "All Invoices",
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
                                builder: (context) => const CashBook()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 241, 233, 107),
                          ),
                          child: const Align(
                            alignment: Alignment
                                .center, // Center the text at the bottom
                            child: Text(
                              "Cash Book",
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
                                builder: (context) => const ProductsPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 112, 240, 187),
                          ),
                          child: const Align(
                            alignment: Alignment
                                .center, // Center the text at the bottom
                            child: Text(
                              "Products & Price",
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

  const CustomMenuIcon(
      {required this.iconData, required this.color, required this.size});

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
