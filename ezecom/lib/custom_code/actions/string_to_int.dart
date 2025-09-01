// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//import 'package:flutterflow_helpers/flutterflow_helpers.dart';

// Converts a string to an integer
int? stringToInt(String? inputString) {
  // Handle null input
  if (inputString == null) {
    return null;
  }

  // Try to parse the string to integer
  try {
    return int.tryParse(inputString);
  } catch (e) {
    // Return null if parsing fails
    return null;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
