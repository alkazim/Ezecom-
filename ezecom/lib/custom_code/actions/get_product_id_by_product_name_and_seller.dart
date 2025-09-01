// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions

Future<int?> getProductIdByProductNameAndSeller(
  String productName,
  String sellerEmail,
) async {
  try {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('Products_Table')
        .select('Product_id')
        .eq('Product_Name', productName)
        .eq('Seller_Email', sellerEmail)
        .single(); // Assumes each seller has unique product name
    print(response['Product_id']);
    return response['Product_id'] as int?;
  } catch (error) {
    print('Error fetching Product_id: $error');
    return 0;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
