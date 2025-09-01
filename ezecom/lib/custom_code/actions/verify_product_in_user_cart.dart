// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert'; // Add this import for json decoding

Future<bool> verifyProductInUserCart(
  String userEmail,
  int productId,
) async {
  const actionName = 'verifyProductInUserCart';
  debugPrint(
      '[$actionName] Action started for user: $userEmail, product: $productId');

  try {
    // Initialize Supabase client
    final supabase = Supabase.instance.client;
    debugPrint('[$actionName] Supabase client initialized successfully');

    // Fetch user's cart data
    debugPrint('[$actionName] Querying client_table for user: $userEmail');
    final response = await supabase
        .from('client_table')
        .select('CartList')
        .eq('Email', userEmail)
        .maybeSingle();

    if (response == null) {
      debugPrint('[$actionName] No user record found for email: $userEmail');
      return false;
    }

    if (response['CartList'] == null) {
      debugPrint('[$actionName] CartList is empty for user: $userEmail');
      return false;
    }

    // Handle CartList - it's likely returned as a JSON string from Supabase
    List<dynamic> cartItems;
    final cartListData = response['CartList'];

    debugPrint('[$actionName] CartList type: ${cartListData.runtimeType}');
    debugPrint('[$actionName] CartList raw data: $cartListData');

    try {
      if (cartListData is String) {
        // Parse JSON string to List
        cartItems = jsonDecode(cartListData) as List<dynamic>;
        debugPrint(
            '[$actionName] Successfully parsed CartList from JSON string');
      } else if (cartListData is List) {
        // Already a List
        cartItems = cartListData;
        debugPrint('[$actionName] CartList is already a List');
      } else {
        debugPrint(
            '[$actionName] CartList is unexpected type: ${cartListData.runtimeType}');
        return false;
      }
    } catch (parseError) {
      debugPrint('[$actionName] Error parsing CartList: $parseError');
      return false;
    }

    debugPrint('[$actionName] Retrieved ${cartItems.length} cart items');

    // Search for product in cart
    for (var item in cartItems) {
      try {
        final cartItem = item as Map<String, dynamic>;
        final itemProductId = cartItem['productid'];

        // Compare product IDs (handle both int and string cases)
        if (itemProductId == productId ||
            (itemProductId is String &&
                int.tryParse(itemProductId) == productId) ||
            (itemProductId is int && itemProductId == productId)) {
          debugPrint(
              '[$actionName] Found product $productId with quantity: ${cartItem['quantity']}');
          return true;
        }
      } catch (e) {
        debugPrint(
            '[$actionName] Error processing cart item: $item. Error: $e');
        continue;
      }
    }

    debugPrint('[$actionName] Product $productId not found in user cart');
    return false;
  } catch (e, stackTrace) {
    debugPrint('[$actionName] Critical error: $e');
    debugPrint('[$actionName] Stack trace: $stackTrace');
    return false; // Return false instead of rethrowing to prevent app crashes
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
