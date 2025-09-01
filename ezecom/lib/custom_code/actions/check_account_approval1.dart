// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// DO NOT REMOVE OR MODIFY THE CO DE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> checkAccountApproval1(String? email) async {
  print('checkAccountApproval -1 - Action started');
  print('checkAccountApproval - 1 Email received: $email');

  if (email == null || email.isEmpty) {
    print('checkAccountApproval - 1 Error: Email is null or empty');
    return null;
  }

  try {
    print('checkAccountApproval - 1 Querying client_table for email: $email');

    // Use Supabase.instance.client instead of SupabaseFlow.client
    final response = await Supabase.instance.client
        .from('client_table')
        .select('Account_Approval')
        .eq('Email', email) // Make sure column name matches your database
        .maybeSingle();

    print(
        'checkAccountApproval - 1 Query response: $response'); // Added debug log

    if (response != null && response['Account_Approval'] != null) {
      final approvalStatus =
          response['Account_Approval'].toString().toLowerCase();
      print('checkAccountApproval - 1 Approval status found: $approvalStatus');
      return approvalStatus;
    } else {
      print('checkAccountApproval - 1 No approval status found for this email');
      return null;
    }
  } catch (e) {
    print('checkAccountApproval - 1 Error querying database: $e');
    return '$email error happened @ checkAccountApproval function';
  }
}
