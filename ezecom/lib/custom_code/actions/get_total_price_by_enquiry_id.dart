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

// Custom Action: getTotalPriceByEnquiryId
// This action takes an enquiry ID as parameter and returns the total price
// of all rows matching that enquiry ID, or "false" if error/no data

Future<String> getTotalPriceByEnquiryId(String enquiryId) async {
  try {
    // Get the Supabase client instance
    final supabase = Supabase.instance.client;

    // Query the table to get all rows matching the enquiry ID
    final response = await supabase
        .from('Enquiry_Table_AgentThrough')
        .select('Total_Price')
        .eq('Enquiry_ID', enquiryId);

    // Check if we have valid data
    if (response == null || response.isEmpty) {
      return "false";
    }

    // Calculate the total price
    double totalPrice = 0.0;
    bool hasValidPrice = false;

    for (var row in response) {
      final price = row['Total_Price'];
      if (price != null) {
        double parsedPrice = double.tryParse(price.toString()) ?? 0.0;
        if (parsedPrice > 0) {
          totalPrice += parsedPrice;
          hasValidPrice = true;
        }
      }
    }

    // Return the total price if we found valid prices, otherwise "false"
    return hasValidPrice ? totalPrice.toString() : "false";
  } catch (e) {
    // Return "false" on any error
    print('Error fetching total price: $e');
    return "false";
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
