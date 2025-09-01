// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import '/flutter_flow/flutter_flow_theme.dart';

import 'dart:math';

Future<String> placeOrderActionInstantBuy(
  BuildContext context,
  int productId,
  String email,
  String quantity,
) async {
  try {
    print("🔍 Starting placeOrderActionInstantBuy...");
    print("➡️ email: $email | productId: $productId | quantity: $quantity");

    // Input validation
    if (email.isEmpty) {
      print("❌ Error: Email is empty.");
      return "false";
    }

    if (productId <= 0) {
      print("❌ Error: Product ID is invalid.");
      return "false";
    }

    int quantityValue = int.tryParse(quantity.split('.')[0]) ?? 0;
    if (quantityValue <= 0) {
      print("❌ Error: Quantity is invalid.");
      return "false";
    }

    // Fetch Buyer Info
    final buyerResponse = await SupaFlow.client
        .from('Buyer_User')
        .select('Company_Name')
        .eq('Email', email)
        .maybeSingle();

    if (buyerResponse == null) {
      print("❌ Error: Buyer not found for email $email.");
      return "false";
    }

    String buyerName = buyerResponse['Company_Name'] ?? 'Unknown Buyer';
    print("✅ Buyer found: $buyerName");

    // Fetch Product Info
    final productResponse = await SupaFlow.client
        .from('public_products_view')
        .select('Product_Name, Discounted_Price')
        .eq('Product_id', productId)
        .maybeSingle();

    if (productResponse == null) {
      print("❌ Error: Product not found for ID $productId.");
      return "false";
    }

    String productName = productResponse['Product_Name'] ?? 'Unknown Product';
    //String sellerName = productResponse['Added_by'] ?? 'Unknown Seller';
    double discountedPrice =
        (productResponse['Discounted_Price'] ?? 0.0).toDouble();
    // print(
    //     "✅ Product found: $productName by $sellerName at \$${discountedPrice}/unit");

    // Calculate total price
    double totalPrice = discountedPrice * quantityValue;
    totalPrice = double.parse(totalPrice.toStringAsFixed(2));
    double unitPrice = productResponse['Discounted_Price'];
    // Generate unique enquiry ID
    String enquiryId =
        'ENQAGNT${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(9000) + 1000}';

    // Prepare enquiry entry
    Map<String, dynamic> enquiryEntry = {
      'created_at': DateTime.now().toIso8601String(),
      'Product_Name': productName,
      'Product_id': productId,
      'Quantity': quantityValue,
      'Buyer_Name': buyerName,
      // 'Seller_Name': sellerName,
      'Status': 'false',
      'Enquiry_ID': enquiryId,
      'Total_Price': totalPrice,
      'Buyer_Mail': email,
      // 'shipping_status': null,
      'Unit_price': unitPrice
    };

    print("📦 Inserting enquiry: $enquiryEntry");

    final session = SupaFlow.client.auth.currentSession;
    if (session == null) {
      print("❌ ERROR: No active Supabase session. User is not authenticated.");
      return "false";
    } else {
      print(
          "🔐 Authenticated as: ${session.user.email} | UID: ${session.user.id}");
    }

    // Insert the enquiry
    final insertResponse = await SupaFlow.client
        .from('Enquiry_Table_AgentThrough')
        .insert(enquiryEntry)
        .select();

    // Check if insert was successful
    if (insertResponse.isEmpty) {
      print('❌ Insert failed: No data returned from insert operation');
      return "false";
    }

    print("✅ Insert successful. Enquiry ID: $enquiryId");
    print("📄 Insert Response: $insertResponse");
    return enquiryId;
  } catch (e, stackTrace) {
    print("🔥 Exception in placeOrderActionInstantBuy: $e");
    print("🧱 Stack Trace: $stackTrace");
    return "false";
  }
}
