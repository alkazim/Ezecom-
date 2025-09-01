// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//import 'package:flutter_flow/flutter_flow_util.dart';

Future<String> getSubcategoryID(String subcategoryName) async {
  try {
    // Query the Supabase Sub_Category_Table
    final response = await SupaFlow.client
        .from('Sub_Category_Table')
        .select()
        .eq('SubCategory_Name', subcategoryName)
        .single();

    if (response == null) {
      throw Exception('Subcategory not found: $subcategoryName');
    }

    // Extract and return the Sub_Category_ID
    final subcategoryID = response['Sub_Category_ID'] as String;
    return subcategoryID;
  } catch (e) {
    print('Error getting subcategory ID: $e');
    rethrow; // Rethrow to let FlutterFlow handle the error
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
