// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//import '/custom_code/actions/index.dart'; // Imports other custom actions
//import '/flutter_flow/custom_functions.dart'; // Imports custom functions

import 'dart:math';
//import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<int>> fetchRelatedProductIds(int currentProductId) async {
  print('[Debug] Function started with Product_id: $currentProductId');

  try {
    // Initialize Supabase client
    final supabase = Supabase.instance.client;
    print('[Debug] Supabase client initialized');

    // Step 1: Get the company name for the current product
    print('[Debug] Fetching company name for product $currentProductId');
    final productResponse = await supabase
        .from('Products_Table')
        .select('Added_by') // Fixed: Removed quotes, use consistent naming
        .eq('Product_id', currentProductId)
        .maybeSingle();

    print('[Debug] Product response: $productResponse');

    if (productResponse == null || productResponse['Added_by'] == null) {
      print('[Debug] No company name found for this product');
      return [];
    }

    final companyName =
        productResponse['Added_by'] as String; // Fixed: Use consistent key
    print('[Debug] Found company name: $companyName');

    // Step 2: Get all product IDs from the same company (excluding current product)
    print('[Debug] Fetching related products for company: $companyName');
    final relatedProductsResponse = await supabase
        .from('Products_Table')
        .select('Product_id, Added_by') // Fixed: Consistent column naming
        .eq('Added_by', companyName) // Fixed: Consistent column naming
        .neq('Product_id', currentProductId); // Exclude current product

    print('[Debug] Related products response: $relatedProductsResponse');

    if (relatedProductsResponse == null || relatedProductsResponse.isEmpty) {
      print('[Debug] No related products found');
      return [];
    }

    // Extract product IDs
    final allProductIds = (relatedProductsResponse as List)
        .map((product) => product['Product_id'] as int)
        .toList();

    print('[Debug] All related product IDs: $allProductIds');

    // Shuffle and take 3 random IDs
    if (allProductIds.length > 1) {
      final random = Random();
      allProductIds.shuffle(random);
    }

    final result = allProductIds.take(3).toList();
    print('[Debug] Final result (3 random IDs): $result');

    return result;
  } catch (e) {
    print('[ERROR] in fetchRelatedProductIds: $e');
    return [];
  }
}
