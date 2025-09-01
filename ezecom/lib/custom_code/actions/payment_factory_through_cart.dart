// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';

Future<String> paymentFactoryThroughCart(
  BuildContext context,
  String mailId,
) async {
  print("paymentFactoryThroughCart - Action started");
  print("paymentFactoryThroughCart - Mail ID: $mailId");

  try {
    final supabase = Supabase.instance.client;

    // Step 1: Get cart items
    final clientResponse = await supabase
        .from('client_table')
        .select('CartList')
        .eq('Email', mailId)
        .single();

    final List<dynamic> cartItems = clientResponse['CartList'] ?? [];
    if (cartItems.isEmpty) throw Exception('No items found in cart');

    // Step 2: Get buyer info
    final buyerResponse = await supabase
        .from('Buyer_User')
        .select('Company_Name, Contact_Number')
        .eq('Email', mailId)
        .single();

    final String buyerName = buyerResponse['Company_Name'] ?? 'Unknown Buyer';
    final String contactNo = buyerResponse['Contact_Number'] ?? 'Not Provided';

    // Step 3: Fetch GST plan details
    final planResponse = await supabase
        .from('(GST) manufacture_plan_details')
        .select('Plan_amount, GST')
        .limit(1)
        .maybeSingle();

    if (planResponse == null) throw Exception("No plan details found");

    final double planAmount =
        (planResponse['Plan_amount'] as num?)?.toDouble() ?? 0.0;
    final double gstRate = (planResponse['GST'] as num?)?.toDouble() ?? 0.0;

    // Step 4: Generate common enquiry ID
    final String enquiryId =
        'ENQFACT${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(9000) + 1000}';

    // Step 5: Loop through cart and prepare total paypal price
    double totalPaypalPrice = 0;
    List<Map<String, dynamic>> rowsToInsert = [];

    for (final item in cartItems) {
      final int productId = item['productid'];
      final int quantity = item['quantity'];

      final productResponse = await supabase
          .from('public_products_view')
          .select('Product_Name, "Discounted_Price"')
          .eq('Product_id', productId)
          .single();

      final String productName = productResponse['Product_Name'] ?? 'Unknown';
      //final String sellerName = productResponse['Added_by'] ?? 'Unknown';
      // final String sellerEmail =
      //     productResponse['Seller_Email'] ?? 'unknown@email.com';
      final double productPrice =
          (productResponse['Discounted_Price'] as num?)?.toDouble() ?? 0.0;

      final double totalPrice = planAmount;
      final double productActualPrice =
          double.parse((productPrice * quantity).toStringAsFixed(2));
      final double gstTotalPrice = totalPrice + (totalPrice * gstRate / 100);

      totalPaypalPrice += gstTotalPrice;

      rowsToInsert.add({
        'Product_Name': productName,
        'Quantity': quantity,
        'Buyer_Name': buyerName,
        'Contact_no': contactNo,
        'Payment_Status': 'false',
        //'Seller_Name': sellerName,
        'Product_Id': productId,
        'Enquiry_ID': enquiryId,
        'Buyer_Email': mailId,
        'Total_Price': totalPrice,
        'GST_Total_Price': gstTotalPrice,
        // 'Seller_Email': sellerEmail,
        'Product_Actual_Price': productActualPrice,
        'Paypalprice': 0,
      });
    }

    for (int i = 0; i < rowsToInsert.length; i++) {
      rowsToInsert[i]['Paypalprice'] = totalPaypalPrice;
    }

    // Step 6: Insert all rows in bulk
    await supabase.from('Enquiry_Table_FactoryThrough').insert(rowsToInsert);

    print("paymentFactoryThroughCart - Clearing cart for email: $mailId");
    await SupaFlow.client
        .from('client_table')
        .update({'CartList': []}).eq('Email', mailId);

    print("paymentFactoryThroughCart - Cart cleared successfully");
    return enquiryId;
  } catch (e) {
    print("paymentFactoryThroughCart - Error: ${e.toString()}");
    return 'false';
  }
}
