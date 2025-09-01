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

Future<double?> calculateTotalPriceByEnquiryId(String enquiryId) async {
  try {
    // Get the Supabase client instance
    final supabase = Supabase.instance.client;

    // Query the Enquiry_Table_FactoryThrough table for matching enquiry ID
    final response = await supabase
        .from('Enquiry_Table_FactoryThrough')
        .select('GST_Total_Price')
        .eq('Enquiry_ID', enquiryId);

    // Check if any rows were found
    if (response.isEmpty) {
      return null; // No matching enquiry found
    }

    // Calculate total price by summing all GST_Total_Price values
    double totalPrice = 0.0;

    for (final row in response) {
      final gstPrice = row['GST_Total_Price'];
      if (gstPrice != null) {
        totalPrice += double.parse(gstPrice.toString());
      }
    }

    return totalPrice;
  } catch (e) {
    // Handle any errors
    print('Error calculating total price: $e');
    return null;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
