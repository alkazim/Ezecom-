// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase/supabase.dart';

Future<String?> getUserPlanType(String companyEmail) async {
  // Step 1: Initialize debug
  print('Starting getUserPlanType function');
  print('Received email: $companyEmail');

  try {
    // Step 2: Initialize Supabase client
    print('Initializing Supabase client');
    final supabase = SupabaseClient(
      'https://gticwwxjzuftuvilszmq.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd0aWN3d3hqenVmdHV2aWxzem1xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5ODk4MjYsImV4cCI6MjA1NjU2NTgyNn0.HpSlkpTlelnWRgCXsEwx5y7HELa8t7eY4BrcFJH7img',
    );

    // Step 3: Query the User_Plan_Table
    print('Querying User_Plan_Table for email: $companyEmail');
    final response = await supabase
        .from('User_Plan_Table')
        .select('Plan_Type')
        .eq('Company_Email', companyEmail);

    // Step 4: Check if we got any results
    print('Query completed. Response received');
    if (response.isNotEmpty) {
      final planType = response.first['Plan_Type'] as String?;
      if (planType != null) {
        print('Found plan type: $planType');
        return planType;
      } else {
        print('Plan_Type field is null');
        return null;
      }
    } else {
      print('No plan found for this email');
      return null;
    }
  } catch (e) {
    // Step 5: Handle any errors
    print('Error occurred: $e');
    return null;
  } finally {
    // Step 6: Function complete
    print('getUserPlanType function completed');
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
