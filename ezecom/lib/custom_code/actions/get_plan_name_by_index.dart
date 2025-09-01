// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> getPlanNameByIndex(int currentIndex) async {
  const actionName = 'getPlanNameByIndex';
  print('[$actionName] Started with index: $currentIndex');

  final supabase = Supabase.instance.client;

  try {
    final response = await supabase
        .from('Plan_Table')
        .select('Plan_Name')
        .order('id', ascending: true); // Order to maintain consistent index

    if (response.isEmpty) {
      print('[$actionName] No plans found');
      return 'false';
    }

    if (currentIndex < 0 || currentIndex >= response.length) {
      print('[$actionName] Invalid index: $currentIndex');
      return 'false';
    }

    final String? planName = response[currentIndex]['Plan_Name'];

    if (planName == null || planName.trim().isEmpty) {
      print('[$actionName] Plan_Name is null or empty');
      return 'false';
    }

    print('[$actionName] Plan_Name found: $planName');
    return planName;
  } catch (e) {
    print('[$actionName] Error: $e');
    return 'false';
  } finally {
    print('[$actionName] Completed');
  }
}
