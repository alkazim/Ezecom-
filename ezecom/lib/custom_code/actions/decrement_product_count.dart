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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> decrementProductCount(String companyMailId) async {
  // --- Start Debug Statements ---
  debugPrint('Action Name: decrementProductCount');
  debugPrint(
      'Action: decrementProductCount - Attempting to decrement product count for email: $companyMailId');
  // --- End Debug Statements ---

  // Check if the provided email matches the one to be skipped
  if (companyMailId == "g.raja.trading@gmail.com") {
    debugPrint(
        'Action: decrementProductCount - Skipping operation for g.raja.trading@gmail.com as requested.');
    return; // Exit the function without performing any action
  }

  try {
    // Initialize Supabase client
    final supabase = Supabase.instance.client;

    // Fetch the current No_of_Products for the given companyMailId
    // Changed 'company_mail_id' to 'Company_Email'
    final response = await supabase
        .from('Seller_User')
        .select('No_of_Products')
        .eq('Company_Email', companyMailId) // Changed column name here
        .single();

    if (response == null || response['No_of_Products'] == null) {
      // --- Start Debug Statements ---
      debugPrint(
          'Action: decrementProductCount - Error: User with email $companyMailId not found or No_of_Products is null.');
      // --- End Debug Statements ---
      return;
    }

    int currentProductCount = response['No_of_Products'] as int;
    // --- Start Debug Statements ---
    debugPrint(
        'Action: decrementProductCount - Current product count for $companyMailId: $currentProductCount');
    // --- End Debug Statements ---

    // Ensure the count doesn't go below zero
    if (currentProductCount > 0) {
      int newProductCount = currentProductCount - 1;

      // Update the No_of_Products in the Seller_User table
      // Changed 'company_mail_id' to 'Company_Email'
      await supabase
          .from('Seller_User')
          .update({'No_of_Products': newProductCount}).eq(
              'Company_Email', companyMailId); // Changed column name here

      // --- Start Debug Statements ---
      debugPrint(
          'Action: decrementProductCount - Successfully decremented product count for $companyMailId to: $newProductCount');
      // --- End Debug Statements ---
    } else {
      // --- Start Debug Statements ---
      debugPrint(
          'Action: decrementProductCount - Product count for $companyMailId is already zero or less. No decrement performed.');
      // --- End Debug Statements ---
    }
  } catch (e) {
    // --- Start Debug Statements ---
    debugPrint(
        'Action: decrementProductCount - Error in decrementProductCount: $e');
    // --- End Debug Statements ---
    // You might want to throw an exception or return a specific error status
    // depending on how you want to handle errors in your FlutterFlow app.
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
