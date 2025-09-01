// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> fetchCategoryNames1() async {
  try {
    // Initialize Supabase client
    final supabase = Supabase.instance.client;

    // Query the categories table
    final response =
        await supabase.from('Categories_Table').select('Category_Name');

    // Process response
    if (response != null && response.isNotEmpty) {
      // Extract category names and return as List<String>
      return response
          .map<String>((category) => category['Category_Name'] as String)
          .where((name) => name != null && name.isNotEmpty)
          .toList();
    }

    // Return empty list if no categories found
    return [];
  } catch (e) {
    // Return empty list on error
    return [];
  }
}
// DO NOT REMOVE OR MODIFY THE CODE ABOVE
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
