// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Import necessary packages
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> checkBannerApprovalStatus(String email) async {
  // Debug: Action started
  print('[checkBannerApprovalStatus] Action started with email: $email');

  final supabase = Supabase.instance.client;

  try {
    // Query the Banner_table for the given Seller_Email
    final response = await supabase
        .from('Banner_table')
        .select('Approval')
        .eq('Seller_Email', email)
        .limit(1)
        .maybeSingle();

    // Debug: Query result
    print('[checkBannerApprovalStatus] Query result: $response');

    if (response == null) {
      // No matching row found
      print(
          '[checkBannerApprovalStatus] No matching row found. Returning "add".');
      return 'add';
    }

    final approval = response['Approval'] as String?;

    if (approval == null || approval.toLowerCase() == 'pending') {
      // Entry found, Approval is pending
      print(
          '[checkBannerApprovalStatus] Approval is pending. Returning "pending".');
      return 'pending';
    } else if (approval.toLowerCase() == 'approved') {
      // Entry found, Approval is approved
      print(
          '[checkBannerApprovalStatus] Approval is approved. Returning "edit".');
      return 'edit';
    } else {
      // Entry found, Approval is some other value
      print(
          '[checkBannerApprovalStatus] Approval is "$approval". Returning "pending" as fallback.');
      return 'pending';
    }
  } catch (e, stack) {
    // Debug: Error occurred
    print('[checkBannerApprovalStatus] Error: $e');
    print('[checkBannerApprovalStatus] Stack: $stack');
    // You may want to handle errors differently in production
    return 'add';
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
