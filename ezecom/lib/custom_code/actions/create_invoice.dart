// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> createInvoice(String buyerEmail, double totalAmount,
    String quantity, String maidId) async {
  try {
    print('createInvoice - Starting invoice creation process');
    print(
        'createInvoice - Input parameters: buyerEmail=$buyerEmail, totalAmount=$totalAmount, quantity=$quantity, maidId=$maidId');

    // Convert quantity from string to numeric with error handling
    num quantityNum;
    try {
      quantityNum = num.parse(quantity);
      print('createInvoice - Converted quantity to numeric: $quantityNum');
    } catch (e) {
      print('createInvoice - Error converting quantity to numeric: $e');
      throw Exception('Invalid quantity format: $quantity');
    }

    // Validate total amount
    if (totalAmount <= 0) {
      throw Exception('Total amount must be greater than 0');
    }

    // Fetch buyer's address from Buyer_User table
    final buyerData = await SupaFlow.client
        .from('Buyer_User')
        .select('Company_Address')
        .eq('Email', buyerEmail)
        .single();

    print('createInvoice - Fetched buyer data: $buyerData');

    if (buyerData == null) {
      throw Exception('Buyer not found with email: $buyerEmail');
    }

    final String? buyerAddress = buyerData['Company_Address'] as String?;
    if (buyerAddress == null || buyerAddress.isEmpty) {
      throw Exception('Company address not found for buyer: $buyerEmail');
    }

    // Fetch GST percentage from manufacture_plan_details table
    final gstData = await SupaFlow.client
        .from('(GST) manufacture_plan_details')
        .select('GST')
        .single();

    print('createInvoice - Fetched GST data: $gstData');

    if (gstData == null) {
      throw Exception('GST percentage data not found');
    }

    final num gstPercentage = gstData['GST'] as num;

    // Fetch CartList from client_table using maidId (which is actually an email)
    final clientData = await SupaFlow.client
        .from('client_table')
        .select('CartList')
        .eq('Email', maidId)
        .single();

    print('createInvoice - Fetched client data: $clientData');

    if (clientData == null) {
      throw Exception('Client not found with maidId: $maidId');
    }

    final dynamic cartListData = clientData['CartList'];
    if (cartListData == null) {
      throw Exception('CartList not found for maidId: $maidId');
    }

    // Convert CartList to Products_details format
    List<Map<String, dynamic>> productsDetails = [];
    if (cartListData is List) {
      for (var item in cartListData) {
        if (item is Map<String, dynamic>) {
          productsDetails.add({
            "quantity": item['quantity'] ?? 0,
            "productid": item['productid'] ?? item['product_id'] ?? 0
          });
        }
      }
    } else if (cartListData is Map<String, dynamic>) {
      // Handle case where CartList might be a single object
      productsDetails.add({
        "quantity": cartListData['quantity'] ?? 0,
        "productid":
            cartListData['productid'] ?? cartListData['product_id'] ?? 0
      });
    }

    print('createInvoice - Converted products details: $productsDetails');

    // Generate year-based invoice ID
    final int currentYear = DateTime.now().year;
    final String yearPrefix = 'INV-$currentYear-';

    print('createInvoice - Year prefix: $yearPrefix');

    // Get all invoice IDs for the current year and find the highest number
    final invoiceData = await SupaFlow.client
        .from('Invoice_Table')
        .select('Invoice_id')
        .ilike('Invoice_id', '$yearPrefix%')
        .order('created_at', ascending: false);

    print('createInvoice - All invoices for current year: $invoiceData');

    int nextNumber = 1;

    if (invoiceData != null && invoiceData.isNotEmpty) {
      int maxNumber = 0;

      for (var invoice in invoiceData) {
        if (invoice['Invoice_id'] != null) {
          final String invoiceId = invoice['Invoice_id'] as String;
          if (invoiceId.startsWith(yearPrefix)) {
            final String numberPart = invoiceId.substring(yearPrefix.length);
            try {
              final int currentNumber = int.parse(numberPart);
              if (currentNumber > maxNumber) {
                maxNumber = currentNumber;
              }
            } catch (e) {
              print(
                  'createInvoice - Error parsing invoice number $numberPart: $e');
            }
          }
        }
      }

      nextNumber = maxNumber + 1;
    }

    print('createInvoice - Next number will be: $nextNumber');

    // Format the invoice ID with zero-padded number
    final String invoiceId =
        '$yearPrefix${nextNumber.toString().padLeft(4, '0')}';
    print('createInvoice - Generated invoice ID: $invoiceId');

    // Insert new invoice into Invoice_Table
    await SupaFlow.client.from('Invoice_Table').insert({
      'Invoice_id': invoiceId,
      'buyer_email': buyerEmail,
      'Address': buyerAddress,
      'Total_Amount': totalAmount,
      'Tax_%': gstPercentage,
      'Quantity': quantityNum,
      'created_at': DateTime.now().toIso8601String(),
      'Products_details': productsDetails
    });

    print('createInvoice - Successfully inserted invoice data');
    return invoiceId;
  } catch (e) {
    print('createInvoice - Error occurred: $e');
    throw Exception('Failed to create invoice: $e');
  }
}
