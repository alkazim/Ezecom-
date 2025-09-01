// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> getPaymentStatusFromSellerUser(
  String email,
) async {
  // Action Name: getPaymentStatusFromSellerUser
  print('[getPaymentStatusFromSellerUser] Action started for email: $email');

  try {
    final response = await Supabase.instance.client
        .from('Seller_User')
        .select('payment_status')
        .eq('email', email)
        .limit(1)
        .maybeSingle();

    print('[getPaymentStatusFromSellerUser] Response: $response');

    if (response == null || !response.containsKey('payment_status')) {
      print(
          '[getPaymentStatusFromSellerUser] No payment_status found. Returning "pending".');
      return 'pending';
    }

    final status = response['payment_status'];
    print('[getPaymentStatusFromSellerUser] Retrieved payment_status: $status');

    if (status == 'COMPLETED') {
      print(
          '[getPaymentStatusFromSellerUser] Payment is COMPLETED. Returning "completed".');
      return 'completed';
    } else {
      print(
          '[getPaymentStatusFromSellerUser] Payment not completed. Returning "pending".');
      return 'pending';
    }
  } catch (e) {
    print('[getPaymentStatusFromSellerUser] Error: $e');
    return 'pending';
  }
}
