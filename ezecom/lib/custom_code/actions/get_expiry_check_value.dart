// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports this file

Future<bool?> getExpiryCheckValue(String authId) async {
  try {
    final response = await SupaFlow.client
        .from('Seller_User')
        .select('Expiry_Check')
        .eq('Auth_ID', authId)
        .maybeSingle();

    if (response == null) {
      return null; // No record found
    }

    final expiryCheck = response['Expiry_Check'];

    // Return as bool (can be true, false, or null)
    if (expiryCheck is bool) {
      return expiryCheck;
    }

    return null; // If somehow not bool
  } catch (e) {
    print('Error fetching Expiry_Check: $e');
    return null;
  }
}
