// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> fetchCurrentProductName(String sellerEmail) async {
  try {
    // Step 1: Get the Product_id from Banner_table for this seller
    final bannerResponse = await Supabase.instance.client
        .from('Banner_table')
        .select('Product_id')
        .eq('Seller_Email', sellerEmail)
        // .eq('Active', true) // optional: only active banners
        .limit(1)
        .maybeSingle(); // returns Map<String, dynamic>? or null

    if (bannerResponse == null) {
      print('No banner found for seller: $sellerEmail');
      return 'false';
    }

    final productId = bannerResponse['Product_id'] as int?;
    if (productId == null) {
      print('Product_id is null in banner for seller: $sellerEmail');
      return 'false';
    }

    print('Fetched Product_id: $productId');

    // Step 2: Fetch Product_Name from Products_Table
    final productResponse = await Supabase.instance.client
        .from('Products_Table')
        .select('Product_Name')
        .eq('Product_id', productId)
        .limit(1)
        .maybeSingle();

    if (productResponse == null) {
      print('No product found for Product_id: $productId');
      return 'false';
    }

    final productName = productResponse['Product_Name'] as String?;
    if (productName != null && productName.isNotEmpty) {
      print('Fetched Product_Name: $productName');
      return productName;
    } else {
      print('Product_Name is null or empty for Product_id: $productId');
      return 'false';
    }
  } catch (e) {
    print('Error fetching Product_Name: $e');
    return 'false';
  }
}
