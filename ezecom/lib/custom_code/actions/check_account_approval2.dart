// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String?> checkAccountApproval2(String? email) async {
  print('checkAccountApproval - 2 - Action started');
  print('checkAccountApproval - 2 Email received: $email');

  if (email == null || email.trim().isEmpty) {
    print('checkAccountApproval - 2 Error: Email is null or empty');
    return null;
  }

  try {
    final cleanEmail = email.trim();

    final response = await Supabase.instance.client
        .from('client_table')
        .select('Account_Approval')
        .ilike('Email', cleanEmail) // case-insensitive match
        .maybeSingle();

    print('checkAccountApproval - 2 Raw DB row: $response');

    if (response != null && response['Account_Approval'] != null) {
      final approvalStatus = response['Account_Approval'].toString().trim();
      print('checkAccountApproval - 2 Approval status found: $approvalStatus');
      return approvalStatus;
    } else {
      print('checkAccountApproval - 2 No approval status found for this email');
      return null;
    }
  } catch (e) {
    print('checkAccountApproval - 2 Error querying database: $e');
    return '$email error happened @ checkAccountApproval function';
  }
}
