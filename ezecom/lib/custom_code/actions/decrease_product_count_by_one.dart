// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<void> decreaseProductCountByOne(String companyEmail) async {
  // Skip decrement for specific email
  if (companyEmail == "g.raja.trading@gmail.com") {
    debugPrint(
        '[decreaseProductCountByOne] Skipping decrement for special email: $companyEmail');
    return;
  }

  final supabase = Supabase.instance.client;
  final actionName = 'decreaseProductCountByOne';

  try {
    debugPrint('[$actionName] Starting action for email: $companyEmail');

    // First, fetch the current value
    debugPrint('[$actionName] Fetching current product count...');
    final response = await supabase
        .from('User_Plan_Table')
        .select('No_of_Products')
        .eq('Company_Email', companyEmail)
        .single();

    if (response == null) {
      debugPrint('[$actionName] No record found for email: $companyEmail');
      throw Exception('No user plan found for the provided email');
    }

    final currentCount = response['No_of_Products'] as int;
    debugPrint('[$actionName] Current product count: $currentCount');

    if (currentCount <= 0) {
      debugPrint('[$actionName] Product count is already 0 or negative');
      throw Exception('Product count cannot be decremented below 0');
    }

    // Decrement the count
    final newCount = currentCount - 1;
    debugPrint('[$actionName] Updating to new count: $newCount');

    // Update the record
    final updateResponse = await supabase
        .from('User_Plan_Table')
        .update({'No_of_Products': newCount}).eq('Company_Email', companyEmail);

    debugPrint('[$actionName] Update successful for email: $companyEmail');
    debugPrint('[$actionName] New product count: $newCount');
  } catch (e) {
    debugPrint('[$actionName] Error occurred: $e');
    rethrow;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
