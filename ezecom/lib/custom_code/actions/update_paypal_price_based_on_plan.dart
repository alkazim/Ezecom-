// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> updatePaypalPriceBasedOnPlan(String enquiryId) async {
  try {
    print('Starting updatePaypalPriceBasedOnPlan for Enquiry_ID: $enquiryId');

    // Step 1: Get all enquiry rows with the given Enquiry_ID
    final enquiryRows = await Supabase.instance.client
        .from('Enquiry_Table_FactoryThrough')
        .select()
        .eq('Enquiry_ID', enquiryId);

    print('Fetched enquiry rows: $enquiryRows');

    if (enquiryRows == null || enquiryRows.isEmpty) {
      print('No enquiry rows found for Enquiry_ID: $enquiryId');
      return false;
    }

    final count = enquiryRows.length;
    print('Number of enquiry rows: $count');

    // Step 2: Get the FIRST row from manufacture_plan_details (no condition)
    final planRows = await Supabase.instance.client
        .from('(GST) manufacture_plan_details')
        .select()
        .limit(1);

    print('Fetched plan details: $planRows');

    if (planRows == null || planRows.isEmpty) {
      print('No manufacture plan details found');
      return false;
    }

    final rupeePrice = planRows[0]['Rupee_price'] ?? 0;
    final gst = planRows[0]['GST'] ?? 0;

    print('Rupee_price: $rupeePrice');
    print('GST: $gst');

    // Step 3: Calculate the PayPal price
    final singlePrice = rupeePrice + (rupeePrice * gst / 100);
    final totalPaypalPrice = singlePrice * count;

    print('Calculated single item PayPal price: $singlePrice');
    print('Total PayPal price for all enquiries: $totalPaypalPrice');

    // Step 4: Update all enquiry rows with the calculated price
    final updateResponse = await Supabase.instance.client
        .from('Enquiry_Table_FactoryThrough')
        .update({'Paypalprice': totalPaypalPrice})
        .eq('Enquiry_ID', enquiryId)
        .select(); // ← Needed to confirm update

    print('Update response: $updateResponse');

    // ✅ Check if update response has rows
    if (updateResponse != null &&
        updateResponse is List &&
        updateResponse.isNotEmpty) {
      print('Update successful for Enquiry_ID: $enquiryId');
      return true;
    } else {
      print('Update failed or no rows affected for Enquiry_ID: $enquiryId');
      return false;
    }
  } catch (e) {
    print('Error in updatePaypalPriceBasedOnPlan: $e');
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
