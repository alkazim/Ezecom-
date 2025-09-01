// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Custom action to calculate discounted price with 2 decimal places
double calculateDiscountedPrice(
    double originalPrice, double discountPercentage) {
  // Validate inputs
  if (originalPrice <= 0) {
    return 0.0;
  }

  if (discountPercentage <= 0) {
    return double.parse(originalPrice.toStringAsFixed(2));
  }

  if (discountPercentage >= 100) {
    return 0.0;
  }

  // Calculate discount amount
  double discountAmount = originalPrice * (discountPercentage / 100);

  // Calculate final price
  double finalPrice = originalPrice - discountAmount;

  // Round to 2 decimal places and return
  return double.parse(finalPrice.toStringAsFixed(2));
}
