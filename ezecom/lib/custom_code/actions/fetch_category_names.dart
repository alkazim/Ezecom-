// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> fetchCategoryNames() async {
  try {
    print("Starting category fetch...");
    final supabase = Supabase.instance.client;

    // Simple direct query - no complex options
    final response =
        await supabase.from('Categories_Table').select('Category_Name');

    print("Raw response data: $response");

    // Handle empty response
    if (response == null || response.isEmpty) {
      print("Received empty response - checking connection...");

      // Test connection with a simple query
      final testResponse =
          await supabase.from('Categories_Table').select('*').limit(1);

      print("Test query results: $testResponse");

      if (testResponse.isEmpty) {
        print("Confirmed empty table or access denied");
        return [];
      }

      print(
          "Main query failed but test succeeded - possible column name issue");
      return [];
    }

    // Simple processing
    final categoryNames = <String>[];
    for (final item in response) {
      final name = item['Category_Name']?.toString() ?? '';
      if (name.isNotEmpty) {
        categoryNames.add(name);
      }
    }

    print("Successfully fetched ${categoryNames.length} categories");
    return categoryNames;
  } catch (e) {
    print("Error fetching categories: ${e.toString()}");
    return [];
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
