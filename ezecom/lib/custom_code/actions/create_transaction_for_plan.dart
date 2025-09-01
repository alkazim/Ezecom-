// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';

Future<String> createTransactionForPlan(
  String planName,
  String sellerEmail,
) async {
  final supabase = Supabase.instance.client;

  try {
    // 1. Get the plan by name
    final planResponse = await supabase
        .from('Plan_Table')
        .select()
        .eq('Plan_Name', planName)
        .limit(1)
        .single();
    print("action started");
    print(sellerEmail);
    print(planResponse);

    if (planResponse == null || !planResponse.containsKey('Price')) {
      print('Plan not found or missing price');
      return 'false';
    }

    final num price = planResponse['Price'];
    final int? yearMembership = planResponse['Year_Membership'];
    final int? noOfProducts = planResponse['No_of_Products'];
    final int? noOfBanners = planResponse['No_of_Banners'];

    // 2. Generate transaction token
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(9000) + 1000;
    final transactionToken = 'PLNPY${timestamp}${random}';

    // 3. Insert into Payment_Transactions_Plan
    final insertResponse =
        await supabase.from('Payment_Transactions_Plan').insert({
      'Seller_Company_Email': sellerEmail,
      'Purchased_Plan_Name': planName,
      'Amount_Paid': price,
      'Currency': 'USD',
      'Payment_Gateway': 'PayPal',
      'Transaction_Status': 'false',
      'transaction_token': transactionToken,
      'Year_plan': yearMembership,
      'No_of_Products': noOfProducts,
      'No_of_Banners': noOfBanners,
    });

    // 4. Return transaction token
    return transactionToken;
  } catch (e) {
    print('Error in custom action: $e');
    return 'false';
  }
}
