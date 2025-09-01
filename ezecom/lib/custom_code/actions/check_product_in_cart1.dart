// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//import 'package:flutter_flow/flutter_flow_model.dart';
//import 'package:flutter_flow/supabase_flow.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> checkProductInCart1(
  String productId,
  String mailId,
) async {
  try {
    // Initialize Supabase client (FlutterFlow-approved method)
    final supabase = Supabase.instance.client;
    print('[Debug] Supabase client initialized');

    // Query the cart table
    print('[Debug] Checking cart for product $productId and user $mailId');
    final response = await supabase
        .from('Cart_Table')
        .select()
        .eq('Product_id', productId)
        .eq('Added_by', mailId)
        .maybeSingle()
        .then((res) => res)
        .catchError((err) {
      print('[Error] Supabase query failed: $err');
      return null;
    });

    // Handle response
    if (response == null) {
      return 'error: query failed';
    }

    return response.isEmpty ? 'not exist' : 'exist';
  } catch (e) {
    print('[Error] Action failed: $e');
    return 'error: $e';
  }
}
