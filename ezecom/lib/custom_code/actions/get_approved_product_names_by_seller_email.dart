// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/supabase/supabase.dart'; // Ensure this import is correct

Future<List<String>> getApprovedProductNamesBySellerEmail(
    String sellerEmail) async {
  final supabase = SupaFlow.client; // Get a reference to your Supabase client

  try {
    // The .select() method directly returns List<Map<String, dynamic>>
    // in recent versions of the Supabase client.
    final List<Map<String, dynamic>> response = await supabase
        .from('Products_Table') // Your table name
        .select('Product_Name') // Select only the Product_Name field
        .eq('Seller_Email', sellerEmail) // Filter by seller email
        .eq('Approval', 'approved') // Filter by approval status
        .order('Product_Name', ascending: true); // Optional: Order results

    // If the response list is empty, it means no matching products were found.
    if (response.isEmpty) {
      return [];
    }

    // Map the list of maps to a list of strings (product names).
    final List<String> productNames = response
        .map((item) =>
            item['Product_Name']?.toString() ??
            '') // Convert to String, handle null
        .where((name) => name.isNotEmpty) // Filter out any empty names
        .toList();

    return productNames;
  } catch (e) {
    print('Error fetching approved product names: $e');
    // It's good practice to log the error.
    // Depending on your app's needs, you might want to:
    // 1. Re-throw the error: throw e;
    // 2. Return an empty list to signify no data was fetched due to an error:
    return [];
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
