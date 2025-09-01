// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//import 'package:flutterflow_utils/flutterflow_utils.dart';

Future<bool> isProductInWishlist(String productId, String email) async {
  try {
    // Step 1: Get user ID from email
    final clientResponse = await Supabase.instance.client
        .from('client_table')
        .select('user_id')
        .eq('email', email)
        .single();

    final userId = clientResponse['user_id'] as String?;
    if (userId == null) return false;

    // Step 2: Check wishlist
    final wishlistResponse = await Supabase.instance.client
        .from('wishlist')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId);

    return wishlistResponse.isNotEmpty;
  } catch (e) {
    print('Wishlist check error: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
