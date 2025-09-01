// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>?> getSubcategoriesByCategoryId(String categoryId) async {
  try {
    // Initialize Supabase client
    final supabase = Supabase.instance.client;

    // Query Sub_Category_Table for matching records
    final response = await supabase
        .from('Sub_Category_Table')
        .select('SubCategory_Name')
        .eq('Category_ID', categoryId.trim());

    print('🔍 Query executed for Category_ID: ${categoryId.trim()}');
    print('📊 Response received: $response');

    if (response != null && response.isNotEmpty) {
      // Extract all SubCategory_Name values
      final subcategories = response
          .map<String>((item) => item['SubCategory_Name'] as String)
          .toList();

      print('✅ Found ${subcategories.length} subcategories');
      return subcategories;
    } else {
      print('⚠️ No subcategories found for Category_ID: $categoryId');
      return [];
    }
  } catch (e) {
    print('❌ Error fetching subcategories: $e');
    return null;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
