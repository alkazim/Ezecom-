// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import '/flutter_flow/flutter_flow_theme.dart';
// import '/custom_code/actions/index.dart';
// import '/flutter_flow/custom_functions.dart';

Future<bool> fetchDataFromSupabase(String sellerEmail) async {
  print('fetchDataFromSupabase called with sellerEmail: $sellerEmail');

  try {
    final supabase = Supabase.instance.client;

    // Check current user auth details
    final currentUser = supabase.auth.currentUser;
    print('Current User ID: ${currentUser?.id}');
    print('Current User Email: ${currentUser?.email}');
    print('Seller Email from parameter: $sellerEmail');

    // Check if they match
    if (currentUser?.email != sellerEmail) {
      print(
          'MISMATCH: Logged-in user email (${currentUser?.email}) != sellerEmail ($sellerEmail)');
    } else {
      print('User email matches parameter sellerEmail');
    }

    // Use current date for testing
    final now = DateTime.now();
    final endOfDayCurrentWeek =
        DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startOfDayWeekAgo = endOfDayCurrentWeek
        .subtract(const Duration(days: 6))
        .copyWith(hour: 0, minute: 0, second: 0);

    print(
        'Fetching data for date range: ${startOfDayWeekAgo.toIso8601String()} to ${endOfDayCurrentWeek.toIso8601String()}');

    // Test simple query to check RLS
    try {
      print('Testing simple query to check RLS...');
      final testResponse = await supabase
          .from('Enquiry_Table_FactoryThrough')
          .select(
              'id, Seller_Email, Seller_Auth_ID, Payment_Status, is_email_sent')
          .eq('Seller_Email', sellerEmail)
          .limit(1);

      print('Test query successful. Returned ${testResponse.length} records');
      if (testResponse.isNotEmpty) {
        final record = testResponse[0];
        print('Sample record:');
        print('- Seller_Auth_ID: ${record['Seller_Auth_ID']}');
        print('- Payment_Status: ${record['Payment_Status']}');
        print('- is_email_sent: ${record['is_email_sent']}');
        print('- Current User ID: ${currentUser?.id}');
        print(
            '- Auth IDs match: ${record['Seller_Auth_ID'] == currentUser?.id}');
      }
    } catch (testError) {
      print('Test query failed: $testError');
      print('RLS Policy Issue: $testError');
      return false;
    }

    // Original query with date filters
    final response = await supabase
        .from('Enquiry_Table_FactoryThrough')
        .select('created_at')
        .eq('Seller_Email', sellerEmail)
        .gte('created_at', startOfDayWeekAgo.toIso8601String())
        .lte('created_at', endOfDayCurrentWeek.toIso8601String());

    print(
        'Main query successful. Raw data fetched: ${response.length} records.');

    return true;
  } catch (e, stackTrace) {
    print('Error fetching data: $e');
    print('Stack Trace: $stackTrace');
    return false;
  }
}
