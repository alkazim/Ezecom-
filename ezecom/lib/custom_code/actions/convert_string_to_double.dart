// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:core';

double? convertStringToDouble(String? quantity) {
  if (quantity == null || quantity.isEmpty) {
    return null;
  }

  try {
    // Remove any thousands separators (commas) if present
    String cleanedQuantity = quantity.replaceAll(',', '');
    return double.parse(cleanedQuantity);
  } catch (e) {
    return null;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
