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

Future<List<int>> getTopDealProductIDs() async {
  // Only changed return type
  try {
    // Initialize Supabase client
    final supabase = Supabase.instance.client;

    // Debug log
    print('Starting top deals product search...');

    // First verify the table structure by fetching one product
    final testProduct = await supabase
        .from('public_products_view')
        .select()
        .limit(1)
        .maybeSingle();

    if (testProduct == null) {
      print('No products found in table');
      return []; // Changed from '' to []
    }

    // Determine the actual ID column name (works for 'id', 'product_id', etc.)
    final idColumn = testProduct.keys.firstWhere(
        (key) => key.toLowerCase().contains('id'),
        orElse: () => 'id' // Default fallback
        );
    print('Using ID column: $idColumn');

    // Method 1: Preferred JSON query (works for most Supabase versions)
    final response = await supabase
        .from('public_products_view')
        .select(idColumn)
        .eq('Status->>TopDeals', 'true')
        .eq('Status->>NewArrival', 'false')
        .eq('Status->>FeaturedOffer', 'false');
    // .eq('Approval',
    //     'approved'); // Added the new condition for approval status

    print('Found ${response.length} matching products in Top Deals section');

    // Extract and convert to List<int>
    final productIDs = response
        .map<int>((product) =>
            int.parse(product[idColumn].toString())) // Added int conversion
        .toList();

    print(
        'Returning product IDs (as numbers): $productIDs'); // Updated debug print
    return productIDs; // Now returns List<int>
  } catch (e) {
    print('Error in getTopDealProductIDs: $e');
    return []; // Changed from '' to []
  }
}
