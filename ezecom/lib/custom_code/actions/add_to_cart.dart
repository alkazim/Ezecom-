// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String> addToCart(
  String email,
  String productId,
  String quantity, // Changed from int to String
) async {
  print("DEBUG: addToCart function started");
  print(
      "DEBUG: Input parameters - email: $email, productId: $productId, quantity: $quantity");

  // 1. Input validation
  if (email.isEmpty) {
    print('DEBUG: Validation failed - Email is empty');
    return "failed";
  }
  if (productId.isEmpty) {
    print('DEBUG: Validation failed - Product ID is empty');
    return "failed";
  }

  print("DEBUG: Starting to parse quantity");
  // Convert string quantity to int with validation
  final quantityInt = int.tryParse(quantity) ?? 0;
  print("DEBUG: Parsed quantity: $quantityInt");
  if (quantityInt <= 0) {
    print('DEBUG: Validation failed - Quantity must be a positive number');
    return "failed";
  }

  print("DEBUG: Starting to parse productId");
  // Convert productId to int with validation
  final productIdInt = int.tryParse(productId) ?? 0;
  print("DEBUG: Parsed productId: $productIdInt");
  if (productIdInt <= 0) {
    print('DEBUG: Validation failed - Product ID must be a valid number');
    return "failed";
  }

  print(
      'DEBUG: Starting addToCart for $email, product $productIdInt, quantity $quantityInt');

  try {
    print("DEBUG: Entering try block");
    // 2. Initialize Supabase
    print("DEBUG: Initializing Supabase client");
    final supabase = Supabase.instance.client;
    print('DEBUG: Supabase client initialized successfully');

    // 3. Fetch user data
    print('DEBUG: Attempting to fetch user data from database');
    final userData = await supabase
        .from('client_table')
        .select('id, CartList')
        .eq('Email', email)
        .single();
    print("DEBUG: User data fetched successfully");
    print("DEBUG: Raw userData: $userData");

    // 4. Process cart data
    final userId = userData['id'] as int;
    print("DEBUG: User ID: $userId");
    List<dynamic> cart = userData['CartList'] ?? [];
    print('DEBUG: User $userId has ${cart.length} cart items');
    print("DEBUG: Current cart contents: $cart");

    // 5. Check if product already exists in cart
    print("DEBUG: Checking if product already exists in cart");
    bool exists = false;

    for (int i = 0; i < cart.length; i++) {
      print("DEBUG: Checking cart item at index $i: ${cart[i]}");

      // Check different possible formats of cart items
      if (cart[i] is Map) {
        // Handle if cart item is already in object format
        if (cart[i]['productid'] == productIdInt) {
          print("DEBUG: Found matching product at index $i (map format)");
          print('DEBUG: Product $productIdInt already exists in cart');

          // Return "exist" immediately if product already exists
          // Don't update the cart - just exit the function
          print("DEBUG: Function completed, returning 'exist'");
          return "exist";
        }
      } else if (cart[i] is List &&
          cart[i].length >= 2 &&
          cart[i][0] == productIdInt) {
        // Handle if cart item is in array format
        print("DEBUG: Found matching product at index $i (array format)");
        print('DEBUG: Product $productIdInt already exists in cart');

        // Return "exist" immediately if product already exists
        // Don't update the cart - just exit the function
        print("DEBUG: Function completed, returning 'exist'");
        return "exist";
      }
    }

    // If we get here, the product doesn't exist in cart
    print("DEBUG: Product doesn't exist in cart, adding new entry");
    // Add new product as an object with productid and quantity
    cart.add({
      'productid': productIdInt,
      'quantity': quantityInt,
    });
    print('DEBUG: Added new product $productIdInt to cart');
    print("DEBUG: New cart contents: $cart");

    // 6. Update database
    print('DEBUG: Preparing to save cart updates to database');
    await supabase
        .from('client_table')
        .update({'CartList': cart}).eq('id', userId);
    print('DEBUG: Database update successful');

    print("DEBUG: Function completed successfully, returning 'success'");
    return "success";
  } catch (e) {
    print('DEBUG: Error occurred in addToCart: $e');
    print('DEBUG: Stack trace: ${StackTrace.current}');
    return "failed";
  }
}
