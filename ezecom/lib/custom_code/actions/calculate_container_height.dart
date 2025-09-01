// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<int> calculateContainerHeight(int itemCount) async {
  // Add your function code here!

  // Base calculation: multiply item count by 200
  int totalHeight = itemCount * 180;

  // Return the calculated height
  return totalHeight;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
