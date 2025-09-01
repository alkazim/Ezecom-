// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Action Name: getRelatedProducts
/// Description: Fetches related products for a given product ID from Supabase Edge Function
/// Parameters: int productId - The ID of the product to find related products for
/// Returns: List<int> - List of related product IDs
///
/// NOTE: This function calls the 'products-match-finder' Edge Function.
/// Make sure that Edge Function uses 'public_products_view' instead of 'Products_Table'
/// Also updates the 'variation1' app state variable with the result
Future<List<int>> getRelatedProducts(int productId) async {
  print('🚀 [getRelatedProducts] Action started');
  print('📥 [getRelatedProducts] Input productId: $productId');
  print(
      '⚠️ [getRelatedProducts] IMPORTANT: Ensure Edge Function uses "public_products_view" not "Products_Table"');

  final url = Uri.parse(
    'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/products-match-finder',
  );
  print('🌐 [getRelatedProducts] API URL: $url');

  // Get current session and access token
  final session = Supabase.instance.client.auth.currentSession;
  final accessToken = session?.accessToken ?? '';

  print('🔐 [getRelatedProducts] Session exists: ${session != null}');
  print(
      '🔑 [getRelatedProducts] Access token exists: ${accessToken.isNotEmpty}');
  print('🔑 [getRelatedProducts] Access token length: ${accessToken.length}');

  try {
    print('📤 [getRelatedProducts] Sending POST request...');
    print('📤 [getRelatedProducts] Request body: ${json.encode({
          'product_id': productId
        })}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({'product_id': productId}),
    );

    print(
        '📨 [getRelatedProducts] Response status code: ${response.statusCode}');
    print('📨 [getRelatedProducts] Response headers: ${response.headers}');
    print('📨 [getRelatedProducts] Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ [getRelatedProducts] Request successful');

      final decoded = json.decode(response.body);
      print(
          '🔍 [getRelatedProducts] Decoded response type: ${decoded.runtimeType}');
      print('🔍 [getRelatedProducts] Decoded response: $decoded');

      final relatedProducts = decoded['relatedProducts'] ?? [];
      print('🔍 [getRelatedProducts] Related products raw: $relatedProducts');
      print(
          '🔍 [getRelatedProducts] Related products type: ${relatedProducts.runtimeType}');
      print(
          '🔍 [getRelatedProducts] Related products length: ${relatedProducts.length}');

      // Extract product IDs and convert to List<int>
      List<int> productIds = [];

      for (int i = 0; i < relatedProducts.length; i++) {
        var product = relatedProducts[i];
        print(
            '🔄 [getRelatedProducts] Processing item $i: $product (type: ${product.runtimeType})');

        if (product is Map<String, dynamic>) {
          // Check for both 'Product_id' and 'id' keys
          dynamic id;

          if (product.containsKey('Product_id')) {
            id = product['Product_id'];
            print(
                '🆔 [getRelatedProducts] Found Product_id: $id (type: ${id.runtimeType})');
          } else if (product.containsKey('id')) {
            id = product['id'];
            print(
                '🆔 [getRelatedProducts] Found id: $id (type: ${id.runtimeType})');
          } else {
            print(
                '⚠️ [getRelatedProducts] No Product_id or id field found in product object');
            print(
                '🔍 [getRelatedProducts] Available keys: ${product.keys.toList()}');
            continue;
          }

          // Convert the ID to int
          if (id is int) {
            productIds.add(id);
            print('✅ [getRelatedProducts] Added int ID: $id');
          } else if (id is double) {
            productIds.add(id.toInt());
            print(
                '✅ [getRelatedProducts] Converted double to int ID: $id -> ${id.toInt()}');
          } else if (id is String) {
            try {
              final parsedId = int.parse(id);
              productIds.add(parsedId);
              print(
                  '✅ [getRelatedProducts] Parsed and added string ID: $id -> $parsedId');
            } catch (e) {
              print(
                  '❌ [getRelatedProducts] Error parsing string ID: $id, error: $e');
            }
          } else {
            print(
                '⚠️ [getRelatedProducts] Unknown ID type: ${id.runtimeType}, value: $id');
          }
        } else if (product is int) {
          // If the response already contains just product IDs
          productIds.add(product);
          print('✅ [getRelatedProducts] Added direct int ID: $product');
        } else if (product is String) {
          // If product IDs are returned as strings, parse them
          try {
            final parsedId = int.parse(product);
            productIds.add(parsedId);
            print(
                '✅ [getRelatedProducts] Parsed and added string ID: $product -> $parsedId');
          } catch (e) {
            print(
                '❌ [getRelatedProducts] Error parsing product ID string: $product, error: $e');
          }
        } else {
          print(
              '⚠️ [getRelatedProducts] Unknown product type: ${product.runtimeType}, value: $product');
        }
      }

      print('🎯 [getRelatedProducts] Final product IDs list: $productIds');
      print('🎯 [getRelatedProducts] Final list length: ${productIds.length}');
      print(
          '🎯 [getRelatedProducts] Final list type: ${productIds.runtimeType}');

      // Update app state with the product IDs list
      try {
        FFAppState().update(() {
          FFAppState().variation1 = productIds;
        });
        print(
            '🔄 [getRelatedProducts] Successfully updated variation1 app state with: $productIds');
        print(
            '🔄 [getRelatedProducts] App state variation1 now contains: ${FFAppState().variation1}');
      } catch (e) {
        print('❌ [getRelatedProducts] Error updating app state: $e');
      }

      print('✅ [getRelatedProducts] Action completed successfully');

      return productIds;
    } else {
      print('❌ [getRelatedProducts] HTTP Error: ${response.statusCode}');
      print('❌ [getRelatedProducts] Error body: ${response.body}');

      // Update app state with empty list on error
      try {
        FFAppState().update(() {
          FFAppState().variation1 = <int>[];
        });
        print(
            '🔄 [getRelatedProducts] Updated variation1 app state with empty list due to HTTP error');
      } catch (e) {
        print(
            '❌ [getRelatedProducts] Error updating app state on HTTP error: $e');
      }

      print('❌ [getRelatedProducts] Returning empty list due to HTTP error');
      return [];
    }
  } catch (e, stackTrace) {
    print('💥 [getRelatedProducts] Exception occurred: $e');
    print('💥 [getRelatedProducts] Stack trace: $stackTrace');

    // Update app state with empty list on exception
    try {
      FFAppState().update(() {
        FFAppState().variation1 = <int>[];
      });
      print(
          '🔄 [getRelatedProducts] Updated variation1 app state with empty list due to exception');
    } catch (appStateError) {
      print(
          '❌ [getRelatedProducts] Error updating app state on exception: $appStateError');
    }

    print('❌ [getRelatedProducts] Returning empty list due to exception');
    return [];
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
