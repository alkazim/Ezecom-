// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Function to check if a product is already in the cart
// Returns true if product is in cart, false otherwise
Future<bool> checkProductInCart(
  String email,
  String productId,
) async {
  // Check if the required parameters are provided
  if (email.isEmpty || productId.isEmpty) {
    return false;
  }

  try {
    // Fetch the current user record by email
    final response = await SupaFlow.client
        .from('client_table')
        .select('cart')
        .eq('Email', email)
        .single();

    // Return false if no response or cart is null
    if (response == null ||
        response['cart'] == null ||
        !(response['cart'] is List)) {
      return false;
    }

    // Get the cart as a list
    List<dynamic> cart = response['cart'];

    // Check if the product exists in the cart
    for (var item in cart) {
      if (item.toString() == productId.toString()) {
        return true;
      }
    }

    // Product not found in cart
    return false;
  } catch (e) {
    return false;
  }
}
