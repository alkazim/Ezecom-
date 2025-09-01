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

bool isQuantityAboveMinimum(String quantity, double minimumQuantity) {
  print('[isQuantityAboveMinimum] Action started');
  print(
      '[isQuantityAboveMinimum] Input quantity: "$quantity" (Type: ${quantity.runtimeType})');
  print(
      '[isQuantityAboveMinimum] Minimum quantity: $minimumQuantity (Type: ${minimumQuantity.runtimeType})');

  try {
    // Parse the quantity string to a double
    double qty = double.parse(quantity);
    print('[isQuantityAboveMinimum] Parsed quantity: $qty');

    // Greater-than-or-equal comparison with double precision
    bool result = qty >= minimumQuantity;
    print(
        '[isQuantityAboveMinimum] Comparison result: $qty >= $minimumQuantity is $result');

    return result;
  } catch (e) {
    print(
        '[isQuantityAboveMinimum] ERROR: Failed to parse quantity. Details: $e');
    // Return false for any parsing errors or invalid input
    return false;
  } finally {
    print('[isQuantityAboveMinimum] Action completed');
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
