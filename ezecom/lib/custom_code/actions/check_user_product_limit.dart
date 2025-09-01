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

Future<String> checkUserProductLimit(String mail) async {
  // Add the bypass condition for the specific email address
  if (mail == "g.raja.trading@gmail.com") {
    print(
        'checkUserProductLimit : Bypassing product limit check for g.raja.trading@gmail.com');
    return 'proceed'; // Always proceed for this specific email
  }

  final SupabaseClient client = Supabase.instance.client;

  try {
    // 1. Fetch user data from Seller_User table
    final response = await client
        .from('Seller_User')
        .select('No_of_Products')
        .eq('Company_Email', mail)
        .single();

    // If response is null, it means no user found with that mail
    if (response == null) {
      print(
          'checkUserProductLimit : Error: User with mail $mail not found in Seller_User table.');
      return 'reject'; // User not found, so cannot proceed
    }

    final int noOfProducts = response['No_of_Products'] as int; // Cast to int

    // 2. Compare No_of_Products with 0
    if (noOfProducts > 0) {
      return 'proceed';
    } else {
      return 'reject'; // No available product slots
    }
  } on PostgrestException catch (e) {
    // Handle Supabase specific errors (e.g., no rows found for .single(), network issues)
    print(
        'checkUserProductLimit : Supabase Error checking product limit for $mail: ${e.message}');
    return 'reject'; // Treat any Supabase error as a rejection
  } catch (e) {
    // Handle any other unexpected errors
    print('checkUserProductLimit : An unexpected error occurred: $e');
    return 'reject'; // Treat any other error as a rejection
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
