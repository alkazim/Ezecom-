// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase/supabase.dart';

Future<void> paymentFactoryThroughAction(
  BuildContext context,
  String productId,
  String quantityStr,
  String buyerEmail,
) async {
  // Debug print
  print("Payment Factory Through - Action started");

  try {
    // Initialize Supabase client
    final supabase = Supabase.instance.client;

    // Debug print parameters
    print("Payment Factory Through - Parameters received:");
    print("Product ID: $productId");
    print("Quantity (string): $quantityStr");
    print("Buyer Email: $buyerEmail");

    // Convert quantity from string to numeric
    final quantity = double.tryParse(quantityStr) ?? 0.0;
    print("Payment Factory Through - Converted quantity to numeric: $quantity");

    // Fetch product details - FIXED: Changed 'id' to 'Product_id'
    print("Payment Factory Through - Fetching product details...");
    final productResponse = await supabase
        .from('Products_Table')
        .select('Product_Name, "Added_by"') // Quoted column name
        .eq('Product_id',
            productId) // ← FIXED: Changed from 'id' to 'Product_id'
        .single();

    final productName = productResponse['Product_Name'] as String? ?? '';
    final sellerName = productResponse['Added_by'] as String? ??
        ''; // No quotes when accessing

    print("Payment Factory Through - Product Name: $productName");
    print("Payment Factory Through - Seller Name: $sellerName");

    // Fetch buyer details
    print("Payment Factory Through - Fetching buyer details...");
    final buyerResponse = await supabase
        .from('Buyer_User')
        .select('Company_Name, Contact_Number')
        .eq('Email',
            buyerEmail.toLowerCase()) // FIXED: Changed from 'email' to 'Email'
        .single();

    final buyerName = buyerResponse['Company_Name'] as String? ?? '';
    final contactNo = buyerResponse['Contact_Number'] as String? ?? '';

    print("Payment Factory Through - Buyer Name: $buyerName");
    print("Payment Factory Through - Contact Number: $contactNo");

    // Insert into Enquiry_Table_FactoryThrough
    print("Payment Factory Through - Preparing to insert enquiry...");
    final insertResponse =
        await supabase.from('Enquiry_Table_FactoryThrough').insert({
      'Product_Name': productName,
      'Quantity': quantity,
      'Buyer_Name': buyerName,
      'Contact_no': contactNo,
      'Payment_Status': 'pending',
      'Seller_Name': sellerName,
      'Product_Id': productId,
    }).select();

    print("Payment Factory Through - Insertion successful");
    print("Payment Factory Through - Response: ${insertResponse.toString()}");

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enquiry submitted successfully!')),
    );
  } catch (e) {
    // Error handling
    print("Payment Factory Through - Error occurred: ${e.toString()}");

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to submit enquiry: ${e.toString()}')),
    );

    // Re-throw the error if you want FlutterFlow to handle it
    throw e;
  }
}
