// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter_pdfview/flutter_pdfview.dart'; // Import PDFView widget
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// Future<void> pdfGenerate(BuildContext context, String invoiceDocId) async {
//   final invoice = await FirebaseFirestore.instance
//       .collection('invoice')
//       .doc(invoiceDocId)
//       .get();

//   final personId = invoice.get('person_id');
//   final person = await FirebaseFirestore.instance
//       .collection('persons')
//       .doc(personId)
//       .get();

//   final name = person.get('name');
//   final date = invoice.get('date').toDate();

//   final pdf = pw.Document(); // Use the Document class from the pdf library

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) => pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Center(
//             child: pw.Text(
//               'KPS BANANA MERCHANT MELATTUR',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//           ),
//           pw.Center(
//             child: pw.Text(
//               'Wholesale and Retail',
//               style: pw.TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           pw.Center(
//             child: pw.Text(
//               'Ph: 7034642606',
//               style: pw.TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           pw.SizedBox(height: 20),
//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//             children: [
//               pw.Text('ID: $invoiceDocId'),
//               pw.Text('Date: ${date.toString().split(' ')[0]}'),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text('Name: $name'),
//           pw.SizedBox(height: 20),
//           // Add invoice details here
//         ],
//       ),
//     ),
//   );

//   // Save the PDF temporarily
//   final output = await getPdfPath('invoice_$invoiceDocId.pdf');
//   await pdf.save().then((value) async {
//     // Load and display the PDF
//     final file = File(output);
//     launchPDF(context, file); // Removed usage of result
//   });
// }

// Future<String> getPdfPath(String fileName) async {
//   final appDocDir = await getApplicationDocumentsDirectory();
//   final appDocPath = appDocDir.path;
//   final filePath = '$appDocPath/$fileName';
//   return filePath;
// }

// void launchPDF(BuildContext context, File file) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => PDFView(
//         filePath: file.path,
//         // Optionally pass a title for the PDFView screen
//         // title: "Your PDF Title",
//       ),
//     ),
//   );
// }

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             pdfGenerate(context, 'your_invoice_doc_id');
//           },
//           child: Text('Generate and View PDF'),
//         ),
//       ),
//     ),
//   ));
// }
