// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//import 'package:flutterflow_utils/flutterflow_utils.dart';

Future<int> getDirectOrderCount(String email) async {
  try {
    print('try Block');
    // Step 1: Get company name from client_table using email
    final clientResponse = await Supabase.instance.client
        .from('client_table')
        .select('company_name')
        .eq('email', email)
        .single();

    final companyName = clientResponse['company_name'] as String?;
    if (companyName == null || companyName.isEmpty) {
      return 0;
    }

    // Step 2: Get direct order count for the company
    final orderResponse = await Supabase.instance.client
        .from('Direct-Purchase_Product_Details')
        .select()
        .eq('Company_Name', companyName)
        .eq('Purchase_mode', 'direct');

    return orderResponse.length;
  } catch (e) {
    print('Error fetching orders: $e');
    return 0;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
