// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

Future<double> sumPrices(List<String> productIds) async {
  // Initialize the Supabase client
  final supabaseClient = supabase.Supabase.instance.client;

  // If the productIds list is empty, return 0
  if (productIds.isEmpty) {
    return 0.0;
  }

  try {
    // Convert string IDs to integers for the database query
    List<int> intIds = productIds
        .map((id) => int.tryParse(id) ?? -1)
        .where((id) => id != -1)
        .toList();

    // If no valid IDs found after conversion, return 0
    if (intIds.isEmpty) {
      return 0.0;
    }

    // Create a comma-separated string of IDs for the query
    String idString = intIds.join(',');

    // Query using the CORRECT column name "Discounted_Price"
    final response = await supabaseClient
        .from('Products_Table')
        .select('Discounted_Price') // Corrected column name
        .filter('Product_id', 'in', '($idString)');

    // Sum all the discounted prices
    double total = 0.0;
    for (final product in response) {
      final price =
          product['Discounted_Price'] as num?; // Corrected column name
      if (price != null) {
        total += price.toDouble();
      }
    }

    return total;
  } catch (e) {
    // Log the error and return 0 in case of any issues
    print('Error calculating discounted prices: $e');
    return 0.0;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
