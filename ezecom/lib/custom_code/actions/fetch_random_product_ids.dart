// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';
//import 'package:flutter_flow/flutter_flow_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<int>> fetchRandomProductIds(String companyName) async {
  try {
    // Initialize Supabase client
    final supabase = Supabase.instance.client;

    // Query the Products_Table for products matching the company name
    final response = await supabase
        .from('Products_Table')
        .select('product_id')
        .eq('company_name', companyName);

    if (response == null || response.isEmpty) {
      return []; // Return empty list if no products found
    }

    // Extract all matching product IDs
    final allProductIds = (response as List)
        .map((product) => product['product_id'] as int)
        .toList();

    // Shuffle the list to randomize
    final random = Random();
    allProductIds.shuffle(random);

    // Return up to 3 product IDs (or less if there aren't enough)
    return allProductIds.take(3).toList();
  } catch (e) {
    print('Error fetching product IDs: $e');
    return []; // Return empty list on error
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
