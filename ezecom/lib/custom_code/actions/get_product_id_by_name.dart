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

Future<int?> getProductIdByName(String productName) async {
  print('getProductIdByName Action: Starting execution.');
  print('getProductIdByName Action: Searching for product: $productName');

  final SupabaseClient supabase = Supabase.instance.client;

  try {
    final response = await supabase
        .from('Products_Table')
        .select('Product_id')
        .eq('Product_Name', productName)
        .single(); // Use .single() if you expect only one match

    if (response != null) {
      final productId =
          response['Product_id'] as int?; // Cast to your expected type
      print(
          'getProductIdByName Action: Found Product_id: $productId for Product_Name: $productName');
      return productId;
    } else {
      print(
          'getProductIdByName Action: No product found with Product_Name: $productName');
      return null;
    }
  } catch (e) {
    print('getProductIdByName Action: Error fetching product ID: $e');
    // Depending on your error handling, you might want to re-throw or return null
    return null;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
