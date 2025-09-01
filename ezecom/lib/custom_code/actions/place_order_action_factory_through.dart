// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Action Name: placeOrderActionFactoryThrough
// Arguments:
// - productId (int, required): The product ID to place order for
// - email (String, required): The buyer's email ID
// - quantity (String, required): The quantity to order
// Return Type: Future<String>
import 'dart:math';

Future<String> placeOrderActionFactoryThrough(
    BuildContext context, int productId, String email, String quantity) async {
  try {
    print('[placeOrderActionFactoryThrough] --- START ---');
    print(
        '[placeOrderActionFactoryThrough] Input - productId: $productId, email: $email, quantity: $quantity');

    if (email.isEmpty) {
      print('[placeOrderActionFactoryThrough] Invalid email');
      return "false";
    }

    if (productId <= 0) {
      print('[placeOrderActionFactoryThrough] Invalid productId');
      return "false";
    }

    int quantityValue = int.tryParse(quantity.split('.')[0]) ?? 0;
    print(
        '[placeOrderActionFactoryThrough] Parsed quantityValue: $quantityValue');
    if (quantityValue <= 0) {
      print('[placeOrderActionFactoryThrough] Invalid quantity');
      return "false";
    }

    print('[placeOrderActionFactoryThrough] Fetching buyer details...');
    final buyerResponse = await SupaFlow.client
        .from('Buyer_User')
        .select('Company_Name, Contact_Number')
        .eq('Email', email)
        .maybeSingle();

    if (buyerResponse == null) {
      print('[placeOrderActionFactoryThrough] Buyer not found');
      return "false";
    }

    print(
        '[placeOrderActionFactoryThrough] Buyer details fetched: $buyerResponse');
    String buyerName = buyerResponse['Company_Name'] ?? 'Unknown Buyer';
    String contactNumber = buyerResponse['Contact_Number'] ?? '';

    print('[placeOrderActionFactoryThrough] Fetching product details...');
    final productResponse = await SupaFlow.client
        .from('public_products_view')
        .select('Product_Name,"Discounted_Price"')
        .eq('Product_id', productId)
        .maybeSingle();

    if (productResponse == null) {
      print('[placeOrderActionFactoryThrough] Product not found');
      return "false";
    }

    print(
        '[placeOrderActionFactoryThrough] Product details fetched: $productResponse');
    String productName = productResponse['Product_Name'] ?? 'Unknown Product';
    //String sellerName = productResponse['Added_by'] ?? 'Unknown Seller';
    // String sellerEmail = productResponse['Seller_Email'] ?? '';
    final double productPrice =
        (productResponse['Discounted_Price'] as num?)?.toDouble() ?? 0.0;

    print('[placeOrderActionFactoryThrough] Fetching GST and plan amount...');
    final gstPlanResponse = await SupaFlow.client
        .from('(GST) manufacture_plan_details')
        .select('Plan_amount, GST')
        .maybeSingle();

    if (gstPlanResponse == null) {
      print('[placeOrderActionFactoryThrough] GST plan not found');
      return "false";
    }

    print(
        '[placeOrderActionFactoryThrough] GST plan details: $gstPlanResponse');
    double planAmount = (gstPlanResponse['Plan_amount'] ?? 0).toDouble();
    double gstPercentage = (gstPlanResponse['GST'] ?? 0).toDouble();

    print('[placeOrderActionFactoryThrough] Calculating prices...');
    double totalPrice = planAmount;
    final double ProductActualPrice = productPrice * quantityValue;
    double gstAmount = (totalPrice * gstPercentage) / 100;
    double gstTotalPrice = totalPrice + gstAmount;

    print('[placeOrderActionFactoryThrough] Total Price: $totalPrice');
    print(
        '[placeOrderActionFactoryThrough] ProductActualPrice: $ProductActualPrice');
    print('[placeOrderActionFactoryThrough] GST Amount: $gstAmount');
    print('[placeOrderActionFactoryThrough] GST Total Price: $gstTotalPrice');

    String enquiryId =
        'ENQFACT${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(9000) + 1000}';
    print('[placeOrderActionFactoryThrough] Generated enquiryId: $enquiryId');

    Map<String, dynamic> enquiryEntry = {
      'created_at': DateTime.now().toIso8601String(),
      'Product_Name': productName,
      'Product_Id': productId,
      'Quantity': quantityValue,
      'Buyer_Name': buyerName,
      'Contact_no': contactNumber,
      'Payment_Status': 'false',
      // 'Seller_Name': sellerName,
      //'Seller_Email': sellerEmail,
      'Enquiry_ID': enquiryId,
      'Buyer_Email': email,
      'Total_Price': totalPrice,
      'GST_Total_Price': gstTotalPrice,
      'Product_Actual_Price': ProductActualPrice,
      'Paypalprice': gstTotalPrice
    };

    print(
        '[placeOrderActionFactoryThrough] Inserting enquiry into Enquiry_Table_FactoryThrough...');
    await SupaFlow.client
        .from('Enquiry_Table_FactoryThrough')
        .insert(enquiryEntry);
    print('[placeOrderActionFactoryThrough] Insertion successful');

    print('[placeOrderActionFactoryThrough] --- END ---');
    return enquiryId;
  } catch (e) {
    print('[placeOrderActionFactoryThrough] Error occurred: $e');
    return "false";
  }
}
