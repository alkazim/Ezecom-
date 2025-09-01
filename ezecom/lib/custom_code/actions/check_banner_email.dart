// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> checkBannerEmail(String email) async {
  try {
    print('[checkBannerEmail] - Starting check for email: $email');

    // Query the "Banner_table" where "Seller_Email" matches the given email
    final response = await Supabase.instance.client
        .from('Banner_table')
        .select('id')
        .eq('Seller_Email', email);

    // If special email, return the count
    if (email == 'g.raja.trading@gmail.com') {
      final count = response.length;
      print('[checkBannerEmail] - Count for g.raja.trading@gmail.com: $count');
      return count.toString(); // returning count as string
    }

    // For other emails, return 1 if match found, else 0
    if (response.isNotEmpty) {
      print('[checkBannerEmail] - Found entries for: $email');
      return '1';
    } else {
      print('[checkBannerEmail] - No entries for: $email');
      return '0';
    }
  } catch (error) {
    print('[checkBannerEmail] - Error occurred: $error');
    return 'error';
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
