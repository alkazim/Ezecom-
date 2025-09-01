// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> fetchPhoneBannerByEmail(String sellerEmail) async {
  try {
    final response = await Supabase.instance.client
        .from('Banner_table')
        .select('Phone_Banner')
        .eq('Seller_Email', sellerEmail)
        .limit(1)
        .maybeSingle(); // returns Map<String, dynamic>? or null

    if (response != null) {
      final phoneBanner = response['Phone_Banner'] as String?;
      if (phoneBanner != null && phoneBanner.isNotEmpty) {
        print("Phone_Banner fetched: $phoneBanner");
        return phoneBanner;
      } else {
        print("Phone_Banner is null or empty for seller: $sellerEmail");
        return 'false';
      }
    } else {
      print("No record found for seller: $sellerEmail");
      return 'false';
    }
  } catch (e) {
    print('Error fetching Phone_Banner: $e');
    return 'false';
  }

  // Return empty string if not found or error
  return 'false';
}
