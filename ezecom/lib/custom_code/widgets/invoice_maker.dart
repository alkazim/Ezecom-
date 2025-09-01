// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

/// A custom invoice widget for FlutterFlow, matching the original design as closely as possible.
///
/// Parameters:
/// - [logoAssetPath]: Asset path for the top-right logo image.
/// - [billedFrom]: String for the 'Billed from' section.widgets
/// - [billedTo]: String for the 'Billed to' section.
/// - [invoiceNumber]: Invoice number string.
/// - [dateRelease]: Date string.
/// - [items]: List of item maps with keys: 'detail', 'qty', 'rate', 'amount'.
/// - [subtotal]: Subtotal string.
/// - [tax]: Tax string.
/// - [total]: Total string.
/// - [address]: Address string for the bottom section.
/// - [footerText]: Footer string.
class InvoiceMaker extends StatelessWidget {
  final double width;
  final double height;

  const InvoiceMaker({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  static const Color blueColor = Color(0xFF5DADE2);

  @override
  Widget build(BuildContext context) {
    final String logoAssetPath = 'assets/ezecom.png';
    final String billedFrom =
        'Ezebit Digital Solutions Pvt,Ltd\nSunpaul Blueberry, Infopark Expy,\nInfopark, Kakkanad, Kerala 682030';
    final String billedTo = 'Jettin sha\nErnakulam\nInfopark';
    final String invoiceNumber = 'xxxxxx';
    final String dateRelease = 'MM/DD/YYYY';
    final List<Map<String, String>> items = [
      {
        'detail': 'Subscription name',
        'qty': '1',
        'rate': '1000',
        'amount': '25,000,000'
      },
      {
        'detail': 'Subscription name',
        'qty': '1',
        'rate': '1000',
        'amount': '100,000'
      },
      {
        'detail': 'Subscription name',
        'qty': '1',
        'rate': '1000',
        'amount': '6,555,000'
      },
    ];
    final String subtotal = 'USD 240.00';
    final String tax = 'USD 20.00';
    final String total = 'USD 220.00';
    final String address =
        'DOOR NO 11/1544, SUNPAUL DEZIRA,\n4-B, INFOPARK, EXPRESSWAY\nKAKKANAD, South Indian Bank ATM,\nRajagiri Valley,Kakkanad, Ernakulam,\nKerala, 682039';
    final String footerText = 'Ezebit Digital Solutions Pvt,Ltd';

    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top blue header (solid, no curve)
            Container(
              height: 100,
              width: double.infinity,
              color: blueColor,
              child: Stack(
                children: [
                  Positioned(
                    top: 25,
                    left: 25,
                    child: Text(
                      'GST:32AAECE4641C1Z8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 25,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          logoAssetPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content section
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      // Logo and Invoice title section
                      Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'LOGO 2\nEZECOM',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Buyer Invoice',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Invoice Number: ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    invoiceNumber,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    'Date Release: ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    dateRelease,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Billing information
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Billed from:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  billedFrom,
                                  style: TextStyle(fontSize: 14, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 60),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Billed to:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  billedTo,
                                  style: TextStyle(fontSize: 14, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Table
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade400, width: 1),
                        ),
                        child: Column(
                          children: [
                            // Table header
                            Container(
                              color: blueColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Item Detail',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Qty',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Rate',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Amount',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Table rows
                            ...List.generate(items.length, (index) {
                              final item = items[index];
                              return Container(
                                color: index % 2 == 0
                                    ? Colors.grey.shade100
                                    : Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item['detail'] ?? '',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        item['qty'] ?? '',
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        item['rate'] ?? '',
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        item['amount'] ?? '',
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      // Totals section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 250,
                            child: Column(
                              children: [
                                _buildTotalRow('Subtotal:', subtotal),
                                SizedBox(height: 10),
                                _buildTotalRow('Tax(%):', tax),
                                SizedBox(height: 10),
                                _buildTotalRow('Total:', total, isBold: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 80),
                      // Bottom section with address and signature
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              address,
                              style: TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                          SizedBox(width: 60),
                          Column(
                            children: [
                              Text(
                                'Authorized Signatory',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom blue bar (footer)
            Container(
              height: 50,
              color: blueColor,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                footerText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// Set your custom widget class name, define your parameter, and then add the
// boilerplate code using the green button on the right!
