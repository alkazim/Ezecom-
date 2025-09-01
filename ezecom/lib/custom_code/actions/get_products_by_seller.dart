// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> getProductsBySeller(String sellerEmail) async {
  print('[GetProductsBySeller] Action started with seller email: $sellerEmail');

  try {
    // Step 1: Query Banner_table to get Product_ids for the given Seller_Email
    print(
        '[GetProductsBySeller] Querying Banner_table for seller email: $sellerEmail');

    final bannerResponse = await SupaFlow.client
        .from('Banner_table')
        .select('Product_id')
        .eq('Auth_ID', sellerEmail);

    print('[GetProductsBySeller] Banner_table query response: $bannerResponse');

    if (bannerResponse == null || bannerResponse.isEmpty) {
      print(
          '[GetProductsBySeller] No banners found for seller email: $sellerEmail');
      return [];
    }

    // Step 2: Extract Product_ids from the response
    List<int> productIds = [];
    for (var row in bannerResponse) {
      if (row['Product_id'] != null) {
        productIds.add(row['Product_id'] as int);
      }
    }

    print('[GetProductsBySeller] Extracted product IDs: $productIds');

    if (productIds.isEmpty) {
      print('[GetProductsBySeller] No valid product IDs found');
      return [];
    }

    // Step 3: Query Products_Table to get Product_Name for each Product_id
    print(
        '[GetProductsBySeller] Querying Products_Table for product IDs: $productIds');

    dynamic productsResponse;

    if (productIds.length == 1) {
      // For single ID, use eq
      productsResponse = await SupaFlow.client
          .from('Products_Table')
          .select('Product_Name')
          .eq('Product_id', productIds.first);
    } else {
      // For multiple IDs, use inFilter
      productsResponse = await SupaFlow.client
          .from('Products_Table')
          .select('Product_Name')
          .inFilter('Product_id', productIds);
    }

    print(
        '[GetProductsBySeller] Products_Table query response: $productsResponse');

    if (productsResponse == null || productsResponse.isEmpty) {
      print(
          '[GetProductsBySeller] No products found for product IDs: $productIds');
      return [];
    }

    // Step 4: Extract Product_Names from the response
    List<String> productNames = [];
    for (var row in productsResponse) {
      if (row['Product_Name'] != null) {
        productNames.add(row['Product_Name'] as String);
      }
    }

    print(
        '[GetProductsBySeller] Successfully retrieved ${productNames.length} product names: $productNames');
    return productNames;
  } catch (error) {
    print('[GetProductsBySeller] Error occurred: $error');
    return [];
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
