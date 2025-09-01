// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> fetchDesktopBannerByEmail(String sellerEmail) async {
  try {
    final response = await Supabase.instance.client
        .from('Banner_table')
        .select('Desktop_Banner')
        .eq('Seller_Email', sellerEmail)
        .limit(1)
        .maybeSingle(); // returns Map<String, dynamic>? or null

    if (response != null) {
      final desktopBanner = response['Desktop_Banner'] as String?;
      if (desktopBanner != null && desktopBanner.isNotEmpty) {
        print("Desktop_Banner fetched: $desktopBanner");
        return desktopBanner;
      } else {
        print("Desktop_Banner is null or empty for seller: $sellerEmail");
        return 'false';
      }
    } else {
      print("No record found for seller: $sellerEmail");
      return 'false';
    }
  } catch (e) {
    print('Error fetching Desktop_Banner: $e');
    return 'false';
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
