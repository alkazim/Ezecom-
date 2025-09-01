// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<double> calculatePriceWithGST(double price) async {
  print('[calculatePriceWithGST] Action started');
  print('[calculatePriceWithGST] Input price: $price');

  try {
    // Query the single row from the GST table
    final response = await Supabase.instance.client
        .from('(GST) manufacture_plan_details')
        .select('GST')
        .limit(1)
        .maybeSingle();

    if (response == null || response['GST'] == null) {
      print('[calculatePriceWithGST] GST not found in the table.');
      throw Exception('GST value is missing from the database');
    }

    final gstPercentage = response['GST'] as num;
    print('[calculatePriceWithGST] Retrieved GST: $gstPercentage');

    // Calculate final price with GST
    final gstValue = price * gstPercentage / 100;
    final finalPrice = price + gstValue;

    print('[calculatePriceWithGST] GST amount: $gstValue');
    print('[calculatePriceWithGST] Final price with GST: $finalPrice');

    return finalPrice;
  } catch (e) {
    print('[calculatePriceWithGST] Error occurred: $e');
    return price; // fallback to original price
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
