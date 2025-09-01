// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/auth/supabase_auth/auth_util.dart';

Future<String?> getUserPaymentStatus(String currentUserEmail) async {
  try {
    print('Fetching Payment Status for email: $currentUserEmail'); // Debug log
    final response = await Supabase.instance.client
        .from('client_table')
        .select('payment_status')
        .eq('Email', currentUserEmail)
        .maybeSingle();

    print('Query response: $response'); // Debug log
    return response?['payment_status'] as String?;
  } catch (e) {
    print('Error fetching user role: $e');
    return '$currentUserEmail error happend @ function';
  }
}
