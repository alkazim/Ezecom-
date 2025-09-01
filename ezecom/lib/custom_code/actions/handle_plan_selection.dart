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

Future<double> handlePlanSelection(
  int currentViewIndex,
  String companyName,
  String companyEmail,
  String mailId,
) async {
  // Initialize Supabase client
  final supabase = SupabaseClient(
    'https://gticwwxjzuftuvilszmq.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd0aWN3d3hqenVmdHV2aWxzem1xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5ODk4MjYsImV4cCI6MjA1NjU2NTgyNn0.HpSlkpTlelnWRgCXsEwx5y7HELa8t7eY4BrcFJH7img',
  );

  print("🚀 Function started - handlePlanSelection");

  try {
    // 1. Get plan details
    print("🔍 Fetching plan at index: $currentViewIndex");
    final planResponse = await supabase
        .from('Plan_Table')
        .select()
        .order('created_at', ascending: true);

    if (planResponse.isEmpty || planResponse.length <= currentViewIndex) {
      print("❌ Error: No plan found at index $currentViewIndex");
      throw Exception("Plan not found");
    }

    final planData = planResponse[currentViewIndex];
    print("📋 Retrieved plan data: ${planData.toString()}");

    // Extract plan details
    final planType = planData['Plan_Name']?.toString() ?? 'Default Plan';
    final planAmount = (planData['Price'] as num?)?.toDouble() ?? 0.0;
    final timePeriodYears = (planData['Time_Period'] as num?)?.toInt() ?? 1;

    // Calculate expiration date
    final now = DateTime.now().toUtc();
    final expiryDate = DateTime(now.year + timePeriodYears, now.month, now.day);
    print("📅 Plan expires on: ${expiryDate.toIso8601String()}");

    // 2. Create User_Plan_Table entry with CORRECT field name
    print("📝 Creating User_Plan_Table entry");
    await supabase.from('User_Plan_Table').insert({
      'created_at': now.toIso8601String(),
      'Company_Name': companyName,
      'Company_Email': companyEmail,
      'Plan_Type': planType,
      'No_of_Products': 5,
      'Shop_Image_Banner': 1,
      'Plan_Price': planAmount,
      'Time_Period': expiryDate.toIso8601String(), // Using correct column name
    });

    // 3. Update client subscription
    print("🔄 Updating client subscription plan");
    await supabase
        .from('client_table')
        .update({'Subscription_Plan': planType}).eq('Email', mailId);

    print("👍 Client subscription updated to: $planType");

    // 4. Return the plan amount
    print("🏁 Function completed successfully");
    return planAmount;
  } catch (e) {
    print("🔥 Error: ${e.toString()}");
    rethrow;
  } finally {
    await supabase.dispose();
    print("🔌 Disconnected");
  }
}
