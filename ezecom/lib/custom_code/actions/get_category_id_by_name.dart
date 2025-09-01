// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String?> getCategoryIdByName(String categoryName) async {
  print("🟢 [1] Action started. Searching for: '$categoryName'");

  try {
    print("🟢 [2] Getting Supabase client instance");
    final supabase = Supabase.instance.client;

    print("🟢 [3] Building query for Categories_Table");
    final query = supabase
        .from('Categories_Table')
        .select('Category_ID')
        .eq('Category_Name', categoryName.trim())
        .limit(1);

    print("🟢 [4] Executing Supabase query...");
    final response = await query;

    print("🟢 [5] Query completed. Response: $response");

    if (response != null && response.isNotEmpty) {
      final categoryId = response[0]['Category_ID'] as String;
      print("🟢 [6] SUCCESS! Found ID: $categoryId");
      return categoryId;
    } else {
      print("🟠 [6] No category found with name: '$categoryName'");
      return null;
    }
  } catch (e) {
    print("🔴 [ERROR] Failed to get category ID: $e");
    print("🔴 [DEBUG] Error details: ${e.toString()}");
    return null;
  }
}
