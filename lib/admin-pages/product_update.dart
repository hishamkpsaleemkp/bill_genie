import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bill_genie/admin-pages/product_list.dart';

class ProductUpdate extends StatefulWidget {
  final DocumentSnapshot product;

  ProductUpdate(this.product);

  @override
  _ProductUpdateState createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  String productName = '';
  double productPrice = 0.0;
  DateTime productDate = DateTime.now();
  bool loading = true;
  final TextEditingController _newPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getProductDetails();
  }

  void _getProductDetails() {
    if (widget.product.exists) {
      setState(() {
        productName = widget.product.get('name');
        productPrice = widget.product.get('price').toDouble();
        productDate = (widget.product.get('date') as Timestamp).toDate();
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _updateProduct() async {
    final newPrice = double.tryParse(_newPriceController.text);
    if (newPrice != null) {
      try {
        await widget.product.reference.update({
          'price': newPrice,
          'date': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color.fromARGB(255, 243, 116, 31),
            content: Text('Error updating product: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 231, 211, 24),
          content: Text('Please enter a valid price'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteProduct() async {
    try {
      await widget.product.reference.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 243, 116, 31),
          content: Text('Error deleting product: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _newPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 170, 54),
        title: const Text(
          'Product Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductList()),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $productName',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Price: \$${productPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Date: ${productDate.toString().substring(0, 10)}',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New Price:',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _newPriceController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter new price',
                              prefixIcon: Icon(Icons.currency_rupee),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                fontSize: 14.0), // Adjust text field size
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 17, 168, 55),
                          ),
                          onPressed: _updateProduct,
                          child: const Text(
                            'UPDATE',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 201, 16, 16),
                        ),
                        onPressed: _deleteProduct,
                        child: const Text(
                          'DELETE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
