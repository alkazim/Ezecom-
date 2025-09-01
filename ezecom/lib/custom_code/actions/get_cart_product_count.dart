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
import 'dart:convert';

Future<int> getCartProductCount(String emailId) async {
  print(
      "------------------------------------------------------Starting getCartProductCount function");
  print(
      "------------------------------------------------------Input emailId: $emailId");

  try {
    final supabase = Supabase.instance.client;

    // Check if user is authenticated
    final user = supabase.auth.currentUser;
    print(
        "------------------------------------------------------Current user: ${user?.email}");

    if (user == null) {
      print(
          "------------------------------------------------------User is not authenticated, returning 0");
      return 0;
    }

    print(
        "------------------------------------------------------User is authenticated, proceeding with query");
    print(
        "------------------------------------------------------Fetching client data from client_table");

    // Use authenticated query with RLS (Row Level Security) consideration
    final clientResponse = await supabase
        .from('client_table')
        .select('CartList')
        .eq('Email', emailId)
        .maybeSingle();

    print(
        "------------------------------------------------------Query completed, clientResponse: $clientResponse");

    if (clientResponse == null) {
      print(
          "------------------------------------------------------No client found with this email, returning 0");
      return 0;
    }

    final cartRaw = clientResponse['CartList'];
    print(
        '------------------------------------------------------Raw cart data: $cartRaw');
    print(
        '------------------------------------------------------Cart data type: ${cartRaw.runtimeType}');

    List<dynamic> cartList = <dynamic>[];

    if (cartRaw == null) {
      print(
          '------------------------------------------------------CartList is null, returning 0');
      return 0;
    } else {
      try {
        String cartString = '';

        if (cartRaw is String) {
          cartString = cartRaw;
          print(
              "------------------------------------------------------CartRaw is String: $cartString");
        } else {
          cartString = jsonEncode(cartRaw);
          print(
              "------------------------------------------------------CartRaw converted to JSON string: $cartString");
        }

        print(
            '------------------------------------------------------Decoding cart string: $cartString');
        final decoded = jsonDecode(cartString);
        print(
            '------------------------------------------------------Decoded data: $decoded');

        if (decoded is List) {
          cartList = decoded.cast<dynamic>();
          print(
              '------------------------------------------------------Successfully converted to List, length: ${cartList.length}');
        } else {
          print(
              '------------------------------------------------------Decoded data is not a list, returning 0');
          return 0;
        }
      } catch (parseError) {
        print(
            '------------------------------------------------------JSON parsing error: $parseError');
        try {
          print(
              "------------------------------------------------------Trying alternative parsing approach");
          if (cartRaw is Iterable) {
            cartList = cartRaw.toList().cast<dynamic>();
            print(
                "------------------------------------------------------Alternative parsing successful, length: ${cartList.length}");
          } else {
            print(
                "------------------------------------------------------CartRaw is not Iterable, returning 0");
            return 0;
          }
        } catch (e2) {
          print(
              '------------------------------------------------------Alternative parsing also failed: $e2');
          return 0;
        }
      }
    }

    print(
        '------------------------------------------------------Final cart list length: ${cartList.length}');
    return cartList.length;
  } catch (e) {
    print(
        '------------------------------------------------------Error in getCartProductCount: $e');
    // If it's an authentication error, return 0 instead of throwing
    if (e.toString().contains('401') ||
        e.toString().contains('Unauthenticated')) {
      print(
          '------------------------------------------------------Authentication error detected, returning 0');
      return 0;
    }
    return 0;
  }
}

// Alternative version that uses service role key (if you have one configured)
// Future<int> getCartProductCountServiceRole(String emailId) async {
//   print("Starting getCartProductCountServiceRole function");
//   print("Input emailId: $emailId");

//   try {
//     final supabase = Supabase.instance.client;

//     print("Fetching client data from client_table using service role");

//     // This version bypasses RLS if you have service role configured
//     final clientResponse = await supabase
//         .from('client_table')
//         .select('CartList')
//         .eq('Email', emailId)
//         .maybeSingle();

//     print("Query completed, clientResponse: $clientResponse");

//     if (clientResponse == null) {
//       print("No client found with this email, returning 0");
//       return 0;
//     }

//     final cartRaw = clientResponse['CartList'];
//     print('Raw cart data: $cartRaw');

//     if (cartRaw == null) {
//       print('CartList is null, returning 0');
//       return 0;
//     }

//     List<dynamic> cartList = <dynamic>[];

//     try {
//       String cartString = '';

//       if (cartRaw is String) {
//         cartString = cartRaw;
//       } else {
//         cartString = jsonEncode(cartRaw);
//       }

//       final decoded = jsonDecode(cartString);

//       if (decoded is List) {
//         cartList = decoded.cast<dynamic>();
//       } else {
//         return 0;
//       }
//     } catch (parseError) {
//       try {
//         if (cartRaw is Iterable) {
//           cartList = cartRaw.toList().cast<dynamic>();
//         } else {
//           return 0;
//         }
//       } catch (e2) {
//         return 0;
//       }
//     }

//     print('Final cart list length: ${cartList.length}');
//     return cartList.length;

//   } catch (e) {
//     print('Error in getCartProductCountServiceRole: $e');
//     return 0;
//   }
// }
