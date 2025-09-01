// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:supabase/supabase.dart';

Future<void> createFactoryThroughEnquiries(
  String buyerEmail,
) async {
  try {
    print(
        '[DEBUG] Starting createFactoryThroughEnquiries for email: $buyerEmail');
    final supabase = SupaFlow.client;

    // 1. Get buyer information
    print('[DEBUG] Fetching buyer information from Buyer_User table...');
    final buyerResponse = await supabase
        .from('Buyer_User')
        .select()
        .eq('Email', buyerEmail)
        .maybeSingle(); // Using maybeSingle instead of single for safety

    if (buyerResponse == null) {
      print('[ERROR] No buyer found with email: $buyerEmail');
      throw Exception('Buyer not found');
    }

    print('[DEBUG] Buyer data received: $buyerResponse');

    final buyerName = buyerResponse['Name'] as String? ?? '';
    final contactNo = buyerResponse['Contact_no'] as String? ?? '';

    print(
        '[DEBUG] Extracted buyer details - Name: $buyerName, Contact: $contactNo');

    // 2. Get client's cart items
    print('[DEBUG] Fetching cart items from client_table...');
    final clientResponse = await supabase
        .from('client_table')
        .select('CartList')
        .eq('Email', buyerEmail)
        .maybeSingle();

    if (clientResponse == null) {
      print('[ERROR] No client found with email: $buyerEmail');
      throw Exception('Client not found');
    }

    print('[DEBUG] Client cart data received: $clientResponse');

    final cartList = clientResponse['CartList'] as List<dynamic>? ?? [];
    print('[DEBUG] Found ${cartList.length} items in cart');

    // 3. For each product in cart, create enquiry
    for (final item in cartList.cast<Map<String, dynamic>>()) {
      final productId = item['productid'] as int;
      final quantity = item['quantity'] as num;

      print(
          '[DEBUG] Processing product ID: $productId with quantity: $quantity');

      // Get product details
      print('[DEBUG] Fetching product details for ID: $productId');
      final productResponse = await supabase
          .from('Products_Table')
          .select('Product_Name, Added by')
          .eq('id', productId)
          .maybeSingle();

      if (productResponse == null) {
        print('[ERROR] Product not found with ID: $productId');
        continue; // Skip to next product if current one not found
      }

      print('[DEBUG] Product details received: $productResponse');

      final productName = productResponse['Product_Name'] as String? ?? '';
      final sellerName = productResponse['Added by'] as String? ?? '';

      print(
          '[DEBUG] Extracted product details - Name: $productName, Seller: $sellerName');

      // Insert into enquiry table
      print(
          '[DEBUG] Preparing to insert enquiry record for product: $productName');
      final insertData = {
        'Product_Name': productName,
        'Quantity': quantity,
        'Buyer_Name': buyerName,
        'Contact_no': contactNo,
        'Payment_Status': 'Pending',
        'Seller_Name': sellerName,
      };

      print('[DEBUG] Insert data: $insertData');

      try {
        await supabase.from('Enquiry_Table_FactoryThrough').insert(insertData);
        print('[SUCCESS] Inserted enquiry for product: $productName');
      } catch (e) {
        print('[ERROR] Failed to insert record for product $productId: $e');
      }
    }

    print('[COMPLETE] Finished processing all cart items');
  } catch (e) {
    print('[FATAL ERROR] in createFactoryThroughEnquiries: $e');
    print('[STACK TRACE] ${e.toString()}');
    rethrow;
  }
}
