// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Action Name: placeOrderAction
// Arguments:
// - email (String, required): The buyer's email ID
// Return Type: Future<String>
import 'dart:math';

Future<String> placeOrderAction(String email) async {
  try {
    print("placeOrderAction - Starting placeOrderAction with email: $email");

    // Step 1: Get buyer information from Buyer_User table
    print(
        "placeOrderAction - Fetching buyer information from Buyer_User table");
    final buyerResponse = await SupaFlow.client
        .from('Buyer_User')
        .select('Company_Name')
        .eq('Email', email)
        .single();

    if (buyerResponse == null) {
      print("placeOrderAction - Buyer not found with email: $email");
      return "false";
    }

    String buyerName = buyerResponse['Company_Name'] ?? 'Unknown Buyer';
    print("placeOrderAction - Found buyer: $buyerName");

    // Step 2: Get cart data from client_table
    print("placeOrderAction - Fetching cart data from client_table");
    final clientResponse = await SupaFlow.client
        .from('client_table')
        .select('CartList')
        .eq('Email', email)
        .single();

    if (clientResponse == null || clientResponse['CartList'] == null) {
      print("placeOrderAction - No cart data found for email: $email");
      return "false";
    }

    // Parse CartList JSON
    List<dynamic> cartList = clientResponse['CartList'];
    print(
        "placeOrderAction - Cart list retrieved with ${cartList.length} items");
    print("placeOrderAction - Cart data: $cartList");

    if (cartList.isEmpty) {
      print("placeOrderAction - Cart is empty");
      return "false";
    }

    // Step 3: Generate single Enquiry_ID for all products in this cart
    // String enquiryId =
    //     'ENQ${DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14)}';
    // print("placeOrderAction - Generated Enquiry_ID: $enquiryId");

    final String enquiryId =
        'ENQAGNT${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(9000) + 1000}';

    // Step 4: Process each item in the cart
    print("placeOrderAction - Starting to process cart items");
    List<Map<String, dynamic>> enquiryEntries = [];

    for (int index = 0; index < cartList.length; index++) {
      var cartItem = cartList[index];
      print("placeOrderAction - Processing cart item ${index + 1}: $cartItem");

      int productId = cartItem['productid'];
      int quantity = cartItem['quantity'];
      print("placeOrderAction - Product ID: $productId, Quantity: $quantity");

      // Get product details from Products_Table
      print("placeOrderAction - Fetching product details for ID: $productId");
      final productResponse = await SupaFlow.client
          .from('public_products_view')
          .select('Product_Name, Discounted_Price')
          .eq('Product_id', productId)
          .single();

      if (productResponse != null) {
        String productName =
            productResponse['Product_Name'] ?? 'Unknown Product';
        //String sellerName = productResponse['Added_by'] ?? 'Unknown Seller';
        double discountedPrice =
            (productResponse['Discounted_Price'] ?? 0).toDouble();
        double unitPrice = productResponse['Discounted_Price'];
        // Calculate total price for this product
        double totalPrice = discountedPrice * quantity;
        totalPrice = double.parse(totalPrice.toStringAsFixed(2));
        // print(
        //     "placeOrderAction - Product found - Name: $productName, Seller: $sellerName");
        print(
            "placeOrderAction - Discounted Price: $discountedPrice, Total Price: $totalPrice");

        // Create entry for Enquiry_Table_AgentThrough
        Map<String, dynamic> enquiryEntry = {
          'created_at': DateTime.now().toIso8601String(),
          'Product_Name': productName,
          'Product_id': productId,
          'Quantity': quantity,
          'Buyer_Name': buyerName,
          //'Seller_Name': sellerName,
          'Status': 'false',
          'Enquiry_ID': enquiryId,
          'Total_Price': totalPrice,
          'Buyer_Mail': email,
          'Unit_price': unitPrice
        };

        enquiryEntries.add(enquiryEntry);
        print(
            "placeOrderAction - Added enquiry entry for product: $productName with Enquiry_ID: $enquiryId");
      } else {
        print("placeOrderAction - Product not found with ID: $productId");
        // Continue processing other items even if one product is not found
      }
    }

    // Step 5: Insert all entries into Enquiry_Table_AgentThrough
    print(
        "placeOrderAction - Preparing to insert ${enquiryEntries.length} enquiry entries");
    if (enquiryEntries.isNotEmpty) {
      print(
          "placeOrderAction - Inserting entries into Enquiry_Table_AgentThrough");
      final insertResponse = await SupaFlow.client
          .from('Enquiry_Table_AgentThrough')
          .insert(enquiryEntries);

      print(
          "placeOrderAction - Successfully inserted ${enquiryEntries.length} enquiry entries with Enquiry_ID: $enquiryId");

      // Step 6: Clear the cart after successful order placement
      print("placeOrderAction - Clearing cart for email: $email");
      await SupaFlow.client
          .from('client_table')
          .update({'CartList': []}).eq('Email', email);

      print("placeOrderAction - Cart cleared successfully");
      print("placeOrderAction - placeOrderAction completed successfully");
      return enquiryId;
    } else {
      print("placeOrderAction - No valid cart items to process");
      return "false";
    }
  } catch (e) {
    print("placeOrderAction - Error in placeOrderAction: $e");
    return "false";
  }
}

// Alternative version with better error handling and detailed response
Future<Map<String, dynamic>> placeOrderActionDetailed(String email) async {
  print(
      "placeOrderAction - Starting placeOrderActionDetailed with email: $email");

  Map<String, dynamic> result = {
    'success': false,
    'message': '',
    'entriesCreated': 0,
    'enquiryId': '',
    'totalAmount': 0.0,
    'errors': <String>[],
  };

  try {
    // Step 1: Validate email parameter
    print("placeOrderAction - Validating email parameter");
    if (email.isEmpty) {
      print("placeOrderAction - Email parameter is empty or null");
      result['message'] = 'Email parameter is required';
      return result;
    }

    // Step 2: Get buyer information
    print("placeOrderAction - Fetching buyer information for email: $email");
    final buyerResponse = await SupaFlow.client
        .from('Buyer_User')
        .select('Company_Name')
        .eq('Email', email)
        .maybeSingle();

    if (buyerResponse == null) {
      print("placeOrderAction - Buyer not found with email: $email");
      result['message'] = 'Buyer not found with email: $email';
      return result;
    }

    String buyerName = buyerResponse['Company_Name'] ?? 'Unknown Buyer';
    print("placeOrderAction - Found buyer: $buyerName");

    // Step 3: Get cart data
    print("placeOrderAction - Fetching cart data from client_table");
    final clientResponse = await SupaFlow.client
        .from('client_table')
        .select('CartList')
        .eq('Email', email)
        .maybeSingle();

    if (clientResponse == null || clientResponse['CartList'] == null) {
      print("placeOrderAction - No cart data found for email: $email");
      result['message'] = 'No cart data found for email: $email';
      return result;
    }

    List<dynamic> cartList = [];
    try {
      cartList = List<dynamic>.from(clientResponse['CartList']);
      print(
          "placeOrderAction - Successfully parsed cart list with ${cartList.length} items");
      print("placeOrderAction - Cart data: $cartList");
    } catch (e) {
      print("placeOrderAction - Error parsing CartList: $e");
      result['message'] = 'Invalid cart data format';
      result['errors'].add('CartList parsing error: $e');
      return result;
    }

    if (cartList.isEmpty) {
      print("placeOrderAction - Cart is empty");
      result['message'] = 'Cart is empty';
      return result;
    }

    // Step 4: Generate single Enquiry_ID for all products in this cart
    String enquiryId =
        'ENQ${DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14)}';
    print("placeOrderAction - Generated Enquiry_ID: $enquiryId");
    result['enquiryId'] = enquiryId;

    // Step 5: Process each cart item
    print(
        "placeOrderAction - Starting to process ${cartList.length} cart items");
    List<Map<String, dynamic>> enquiryEntries = [];
    List<String> processingErrors = [];
    double totalOrderAmount = 0.0;

    for (int i = 0; i < cartList.length; i++) {
      try {
        print("placeOrderAction - Processing cart item ${i + 1}");
        var cartItem = cartList[i];
        print("placeOrderAction - Cart item data: $cartItem");

        int productId = cartItem['productid'];
        int quantity = cartItem['quantity'];
        print("placeOrderAction - Product ID: $productId, Quantity: $quantity");

        // Get product details
        print("placeOrderAction - Fetching product details for ID: $productId");
        final productResponse = await SupaFlow.client
            .from('public_products_view')
            .select('Product_Name, Discounted_Price')
            .eq('Product_id', productId)
            .maybeSingle();

        if (productResponse != null) {
          String productName =
              productResponse['Product_Name'] ?? 'Unknown Product';
          //String sellerName = productResponse['Added_by'] ?? 'Unknown Seller';
          double discountedPrice =
              (productResponse['Discounted_Price'] ?? 0).toDouble();

          // Calculate total price for this product
          double totalPrice = discountedPrice * quantity;
          totalOrderAmount += totalPrice;

          // print(
          //     "placeOrderAction - Product found - Name: $productName, Seller: $sellerName");
          print(
              "placeOrderAction - Discounted Price: $discountedPrice, Total Price: $totalPrice");

          Map<String, dynamic> enquiryEntry = {
            'created_at': DateTime.now().toIso8601String(),
            'Product_Name': productName,
            'Product_id': productId,
            'Quantity': quantity,
            'Buyer_Name': buyerName,
            //'Seller_Name': sellerName,
            'Status': 'false',
            'Enquiry_ID': enquiryId,
            'Total_Price': totalPrice,
            'Buyer_Mail': email,
          };

          enquiryEntries.add(enquiryEntry);
          print(
              "placeOrderAction - Added enquiry entry for product: $productName");
        } else {
          String errorMsg = 'Product not found with ID: $productId';
          print("placeOrderAction - $errorMsg");
          processingErrors.add(errorMsg);
        }
      } catch (e) {
        String errorMsg = 'Error processing cart item $i: $e';
        print("placeOrderAction - $errorMsg");
        processingErrors.add(errorMsg);
      }
    }

    // Step 6: Insert entries
    print(
        "placeOrderAction - Preparing to insert ${enquiryEntries.length} valid entries");
    if (enquiryEntries.isNotEmpty) {
      print(
          "placeOrderAction - Inserting entries into Enquiry_Table_AgentThrough");
      await SupaFlow.client
          .from('Enquiry_Table_AgentThrough')
          .insert(enquiryEntries);

      result['success'] = true;
      result['entriesCreated'] = enquiryEntries.length;
      result['totalAmount'] = totalOrderAmount;
      result['message'] =
          'Order placed successfully. ${enquiryEntries.length} items processed with Enquiry_ID: $enquiryId. Total Amount: ₹${totalOrderAmount.toStringAsFixed(2)}';
      print(
          "placeOrderAction - Successfully inserted ${enquiryEntries.length} entries");

      if (processingErrors.isNotEmpty) {
        result['errors'] = processingErrors;
        result['message'] += ' Some items had errors.';
        print(
            "placeOrderAction - Some processing errors occurred: $processingErrors");
      }

      // Clear cart after successful order
      print("placeOrderAction - Clearing cart after successful order");
      await SupaFlow.client
          .from('client_table')
          .update({'CartList': []}).eq('Email', email);
      print("placeOrderAction - Cart cleared successfully");
    } else {
      print("placeOrderAction - No valid items could be processed from cart");
      result['message'] = 'No valid items could be processed from cart';
      result['errors'] = processingErrors;
    }

    print(
        "placeOrderAction - placeOrderActionDetailed completed with result: $result");
  } catch (e) {
    print(
        "placeOrderAction - Unexpected error in placeOrderActionDetailed: $e");
    result['message'] = 'Unexpected error occurred';
    result['errors'].add('Main error: $e');
  }

  return result;
}
