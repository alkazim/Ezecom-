// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String?> getSellerCompanyName(String currentUserEmail) async {
  try {
    print('Fetching company name for email: $currentUserEmail'); // Debug log
    final response = await Supabase.instance.client
        .from('Seller_User')
        .select('Company_Name')
        .eq('Company_Email', currentUserEmail)
        .maybeSingle();

    print('Query response: $response'); // Debug log
    return response?['Company_Name'] as String?;
  } catch (e) {
    print('Error fetching seller company name: $e');
    return null; // Returning null is more appropriate for error cases when expecting a String?
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
