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

Future<void> removeFromCart(String productId, String userEmail) async {
  print('[DEBUG] removeFromCart started');
  print('[DEBUG] Product ID: $productId');
  print('[DEBUG] User Email: $userEmail');

  try {
    // Initialize Supabase client
    final supabase = Supabase.instance.client;
    final email = userEmail.trim();
    print('[DEBUG] Trimmed email: $email');

    // 1. Verify the user exists first
    print('[DEBUG] Checking if user exists...');
    final userCheck = await supabase
        .from('client_table')
        .select('id')
        .eq('Email', email)
        .maybeSingle();

    if (userCheck == null) {
      print('[ERROR] User not found with email: $email');
      throw Exception('User with email $email not found');
    }
    print('[DEBUG] User found with ID: ${userCheck['id']}');

    // 2. Get current cart
    print('[DEBUG] Fetching current cart...');
    final response = await supabase
        .from('client_table')
        .select('CartList')
        .eq('Email', email)
        .single();

    // Handle potentially null cart data
    final cartRawData = response['CartList'];
    if (cartRawData == null) {
      print('[DEBUG] Cart is empty or null');
      return; // Nothing to remove
    }

    print('[DEBUG] Current cart data: $cartRawData');

    // 3. Process cart list - ensure it's properly typed
    final cartList = List<Map<String, dynamic>>.from(cartRawData);
    final initialLength = cartList.length;
    print('[DEBUG] Initial cart items count: $initialLength');

    print('[DEBUG] Removing product $productId from cart...');
    cartList.removeWhere((item) {
      // More robust comparison with null checks
      if (item == null) return false;
      var itemProductId = item['productid'];
      // Convert to string for comparison if needed
      return itemProductId != null &&
          itemProductId.toString() == productId.toString();
    });

    final newLength = cartList.length;
    print('[DEBUG] Remaining cart items count: $newLength');

    // 4. Only update if cart changed
    if (newLength != initialLength) {
      print('[DEBUG] Cart changed - updating database...');
      await supabase
          .from('client_table')
          .update({'CartList': cartList}).eq('Email', email);
      print('[DEBUG] Database update successful');
    } else {
      print('[DEBUG] No changes to cart - skipping update');
    }

    print('[DEBUG] removeFromCart completed successfully');
  } catch (e, stackTrace) {
    print('[ERROR] Exception occurred: $e');
    print('[ERROR] Stack trace: $stackTrace');
    throw Exception('Failed to remove product from cart: $e');
  }
}
