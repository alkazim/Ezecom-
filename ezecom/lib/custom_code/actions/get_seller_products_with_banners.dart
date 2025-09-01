// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

// Set your action name here
// getSellerProductsWithBanners

// Set your return type here
// List<String>

Future<List<String>> getSellerProductsWithBanners(String authId) async {
  print('[getSellerProductsWithBanners] Starting action with Auth ID: $authId');

  try {
    final supabase = Supabase.instance.client;

    // Step 1: Get all product IDs for the seller from Products_Table
    print(
        '[getSellerProductsWithBanners] Step 1: Fetching products for seller');

    final productsResponse = await supabase
        .from('Products_Table')
        .select('Product_id, Product_Name')
        .eq('Auth_ID', authId);

    print(
        '[getSellerProductsWithBanners] Products query response: ${productsResponse.length} products found');

    if (productsResponse.isEmpty) {
      print('[getSellerProductsWithBanners] No products found for this seller');
      return [];
    }

    // Extract product IDs
    List<int> productIds = productsResponse
        .map<int>((product) => product['Product_id'] as int)
        .toList();

    print('[getSellerProductsWithBanners] Product IDs found: $productIds');

    // Step 2: Get product IDs that have banners from Banner_table
    print('[getSellerProductsWithBanners] Step 2: Fetching banner information');

    final bannersResponse = await supabase
        .from('Banner_table')
        .select('Product_id')
        .inFilter('Product_id', productIds)
        .eq('Auth_ID', authId);

    print(
        '[getSellerProductsWithBanners] Banners query response: ${bannersResponse.length} banners found');

    if (bannersResponse.isEmpty) {
      print(
          '[getSellerProductsWithBanners] No banners found for seller products');
      return [];
    }

    // Extract product IDs that have banners
    List<int> productIdsWithBanners = bannersResponse
        .map<int>((banner) => banner['Product_id'] as int)
        .toList();

    print(
        '[getSellerProductsWithBanners] Product IDs with banners: $productIdsWithBanners');

    // Step 3: Get product names for products that have banners
    print('[getSellerProductsWithBanners] Step 3: Fetching product names');

    final productNamesResponse = await supabase
        .from('Products_Table')
        .select('Product_Name')
        .inFilter('Product_id', productIdsWithBanners)
        .eq('Auth_ID', authId);

    print(
        '[getSellerProductsWithBanners] Product names query response: ${productNamesResponse.length} names found');

    // Extract product names and filter out null values
    List<String> productNames = productNamesResponse
        .where((product) => product['Product_Name'] != null)
        .map<String>((product) => product['Product_Name'] as String)
        .toList();

    print('[getSellerProductsWithBanners] Final product names: $productNames');
    print('[getSellerProductsWithBanners] Action completed successfully');

    return productNames;
  } catch (e, stackTrace) {
    print('[getSellerProductsWithBanners] Error occurred: $e');
    print('[getSellerProductsWithBanners] Stack trace: $stackTrace');

    // Return empty list on error
    return [];
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
