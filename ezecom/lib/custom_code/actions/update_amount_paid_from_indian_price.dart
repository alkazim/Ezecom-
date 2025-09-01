// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> updateAmountPaidFromIndianPrice(String transactionToken) async {
  final supabase = Supabase.instance.client;

  try {
    print('🔍 Step 1: Fetching transaction by token: $transactionToken');

    final transactionResponse = await supabase
        .from('Payment_Transactions_Plan')
        .select('Purchased_Plan_Name')
        .eq('transaction_token', transactionToken)
        .maybeSingle();

    print('✅ Transaction response: $transactionResponse');

    if (transactionResponse == null) {
      print('❌ Transaction not found');
      return false;
    }

    final planName = transactionResponse['Purchased_Plan_Name'];
    print('📦 Purchased_Plan_Name: $planName');

    if (planName == null) {
      print('❌ Purchased_Plan_Name is null');
      return false;
    }

    print('🔍 Step 2: Fetching plan by Plan_Name: $planName');

    final planResponse = await supabase
        .from('Plan_Table')
        .select('Indian_Price')
        .eq('Plan_Name', planName)
        .maybeSingle();

    print('✅ Plan response: $planResponse');

    if (planResponse == null) {
      print('❌ Plan not found');
      return false;
    }

    final indianPrice = planResponse['Indian_Price'];
    print('💰 Indian_Price: $indianPrice');

    if (indianPrice == null) {
      print('❌ Indian_Price is null');
      return false;
    }

    print('✏️ Step 3: Updating Amount_Paid to $indianPrice');

    final updateResponse = await supabase
        .from('Payment_Transactions_Plan')
        .update({'Amount_Paid': indianPrice})
        .eq('transaction_token', transactionToken)
        .select('*') // <-- add this to get updated data
        .maybeSingle();

    print('✅ Update response: $updateResponse');

    if (updateResponse == null) {
      print('❌ Update failed: response is null');
      return false;
    }

    print('🎉 Amount_Paid updated successfully!');
    return true;
  } catch (e) {
    print('🔥 Exception caught: $e');
    return false;
  }
}
