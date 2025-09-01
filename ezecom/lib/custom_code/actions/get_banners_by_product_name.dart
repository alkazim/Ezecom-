// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> getBannersByProductName(
  String productName,
) async {
  try {
    // Step 1: Get Product_id from Products_Table using product name
    final productResponse = await SupaFlow.client
        .from('Products_Table')
        .select('Product_id')
        .eq('Product_Name', productName) // Correct column name from schema
        .single();

    if (productResponse == null) {
      print('Product not found: $productName');
      return ['', '']; // Return empty strings if product not found
    }

    final productId = productResponse['Product_id'];
    print('Found product ID: $productId');

    // Step 2: Get banner URLs from Banner_table using Product_id
    final bannerResponse = await SupaFlow.client
        .from('Banner_table')
        .select('Phone_Banner, Desktop_Banner')
        .eq('Product_id', productId)
        .single();

    if (bannerResponse == null) {
      print('Banner not found for product ID: $productId');
      return ['', '']; // Return empty strings if banner not found
    }

    // Step 3: Extract banner URLs
    final phoneBannerUrl = bannerResponse['Phone_Banner'] ?? '';
    final desktopBannerUrl = bannerResponse['Desktop_Banner'] ?? '';

    print('Phone Banner URL: $phoneBannerUrl');
    print('Desktop Banner URL: $desktopBannerUrl');

    // Return the URLs as a list: [0] = mobile, [1] = desktop
    return [phoneBannerUrl, desktopBannerUrl];
  } catch (e) {
    print('Error in getBannersByProductName: $e');

    // Return empty strings in case of error
    return ['', ''];
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
