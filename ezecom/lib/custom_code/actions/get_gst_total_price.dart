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

Future<double> getGstTotalPrice(String enquiryId) async {
  try {
    // Debug: Print enquiry ID being queried
    print('Querying GST Total Price for Enquiry ID: $enquiryId');

    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('Enquiry_Table_FactoryThrough')
        .select('GST_Total_Price')
        .eq('Enquiry_ID', enquiryId)
        .single();

    if (response != null && response['GST_Total_Price'] != null) {
      final gstPrice = (response['GST_Total_Price'] as num).toDouble();

      // Debug: Print successful result
      print('GST Total Price found: \$${gstPrice.toStringAsFixed(2)}');

      return gstPrice;
    }

    // Debug: Print when no data found
    print('No GST Total Price found for Enquiry ID: $enquiryId');

    return 0.0;
  } catch (e) {
    print('Error fetching GST Total Price: $e');
    return 0.0;
  }
}

// Alternative version if you need to show SnackBars - requires BuildContext parameter
Future<double> getGstTotalPriceWithContext(
    String enquiryId, BuildContext context) async {
  try {
    // Debug: Show enquiry ID being queried
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Querying GST Total Price for Enquiry ID: $enquiryId'),
        duration: Duration(seconds: 2),
      ),
    );

    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('Enquiry_Table_FactoryThrough')
        .select('GST_Total_Price')
        .eq('Enquiry_ID', enquiryId)
        .single();

    if (response != null && response['GST_Total_Price'] != null) {
      final gstPrice = (response['GST_Total_Price'] as num).toDouble();

      // Debug: Show successful result
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('GST Total Price found: \$${gstPrice.toStringAsFixed(2)}'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      return gstPrice;
    }

    // Debug: Show when no data found
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No GST Total Price found for Enquiry ID: $enquiryId'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.orange,
      ),
    );

    return 0.0;
  } catch (e) {
    print('Error fetching GST Total Price: $e');

    // Debug: Show error in SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching GST Price: ${e.toString()}'),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red,
      ),
    );

    return 0.0;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
