// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> updatePaymentStatus(
  String enquiryId,
  String status,
  String? transactionId,
) async {
  try {
    await Supabase.instance.client.from('Enquiry_Table_FactoryThrough').update({
      'Payment_Status': status,
      'Transaction_ID': transactionId,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('Enquiry_ID', enquiryId);
    return true;
  } catch (e) {
    print('Error updating payment: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
