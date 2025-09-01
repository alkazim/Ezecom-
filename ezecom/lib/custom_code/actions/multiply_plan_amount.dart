// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Custom Action for FlutterFlow with Supabase
// Action Name: calculatePlanAmount
// Parameters: int count
// Return Type: Future<double>

import 'package:supabase_flutter/supabase_flutter.dart';

Future<double> multiplyPlanAmount(int count) async {
  print("🔵 STEP 1: Function started with count = $count");

  try {
    print("🔵 STEP 2: Entered try block");

    print("🔵 STEP 3: Getting Supabase instance...");
    final supabase = Supabase.instance.client;
    print("🔵 STEP 4: Supabase instance obtained successfully");

    print("🔵 STEP 5: Starting database query...");
    final response = await supabase
        .from('(GST) manufacture_plan_details')
        .select('Plan_amount')
        .maybeSingle();
    print("🔵 STEP 6: Database query completed");

    print("🔵 STEP 7: Checking response...");
    if (response == null) {
      print("🔴 STEP 8: Response is NULL - no data found");
      return 0.0;
    }
    print("🔵 STEP 8: Response is not null");

    print("🔵 STEP 9: Response data: $response");
    print("🔵 STEP 10: Response type: ${response.runtimeType}");
    print("🔵 STEP 11: Available keys: ${response.keys}");

    print("🔵 STEP 12: Extracting Plan_amount...");
    final rawPlanAmount = response['Plan_amount'];
    print(
        "🔵 STEP 13: Raw Plan_amount value: $rawPlanAmount (type: ${rawPlanAmount.runtimeType})");

    print("🔵 STEP 14: Converting to double...");
    final double planAmount = (rawPlanAmount ?? 0).toDouble();
    print("🔵 STEP 15: Converted Plan_amount: $planAmount");

    print("🔵 STEP 16: Performing multiplication...");
    final result = planAmount * count;
    print("🔵 STEP 17: Multiplication result: $result");

    print("🔵 STEP 18: Returning result");
    return result;
  } catch (e) {
    print("🔴 ERROR CAUGHT: $e");
    print("🔴 ERROR TYPE: ${e.runtimeType}");
    print("🔴 ERROR DETAILS: ${e.toString()}");

    // If it's a PostgrestException, get more details
    if (e is PostgrestException) {
      print("🔴 POSTGRES ERROR CODE: ${e.code}");
      print("🔴 POSTGRES ERROR MESSAGE: ${e.message}");
      print("🔴 POSTGRES ERROR DETAILS: ${e.details}");
      print("🔴 POSTGRES ERROR HINT: ${e.hint}");
    }

    print("🔴 RETURNING 0.0 DUE TO ERROR");
    return 0.0;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
