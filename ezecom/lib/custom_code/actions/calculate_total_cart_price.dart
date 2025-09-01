// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<double> calculateTotalCartPrice(String email) async {
  try {
    // Step 1: Query client_table to get CartList for the given email
    final clientResponse = await SupaFlow.client
        .from('client_table')
        .select('CartList')
        .eq('Email', email)
        .single();

    if (clientResponse == null) {
      throw Exception('Client not found for email: $email');
    }

    // Step 2: Extract CartList from the response
    final cartListData = clientResponse['CartList'];

    if (cartListData == null) {
      return 0.0; // Return 0 if cart is empty or null
    }

    // Step 3: Parse CartList (it should be a List of Maps)
    List<dynamic> cartList;
    if (cartListData is List) {
      cartList = cartListData;
    } else {
      throw Exception('CartList is not in expected format');
    }

    if (cartList.isEmpty) {
      return 0.0; // Return 0 if cart is empty
    }

    // Step 4: Extract all unique product IDs from cart
    Set<int> productIds = {};
    for (var item in cartList) {
      if (item is Map<String, dynamic> && item.containsKey('productid')) {
        final productId = item['productid'];
        if (productId is int) {
          productIds.add(productId);
        } else if (productId is String) {
          final parsedId = int.tryParse(productId);
          if (parsedId != null) {
            productIds.add(parsedId);
          }
        }
      }
    }

    if (productIds.isEmpty) {
      return 0.0; // No valid product IDs found
    }

    // Step 5: Query Products_Table to get Discounted_Price for all products
    // Fixed: Changed .in_() to .inFilter()
    final productsResponse = await SupaFlow.client
        .from('public_products_view')
        .select('Product_id, Discounted_Price')
        .inFilter('Product_id', productIds.toList());

    if (productsResponse == null || productsResponse.isEmpty) {
      throw Exception('No products found for the given product IDs');
    }

    // Step 6: Create a map of product_id to discounted_price for quick lookup
    Map<int, double> productPrices = {};
    for (var product in productsResponse) {
      final productId = product['Product_id'] as int;
      final discountedPrice = product['Discounted_Price'];

      if (discountedPrice != null) {
        if (discountedPrice is num) {
          productPrices[productId] = discountedPrice.toDouble();
        }
      }
    }

    // Step 7: Calculate total price
    double totalPrice = 0.0;

    for (var item in cartList) {
      if (item is Map<String, dynamic>) {
        final productIdRaw = item['productid'];
        final quantityRaw = item['quantity'];

        // Parse product ID
        int? productId;
        if (productIdRaw is int) {
          productId = productIdRaw;
        } else if (productIdRaw is String) {
          productId = int.tryParse(productIdRaw);
        }

        // Parse quantity
        int? quantity;
        if (quantityRaw is int) {
          quantity = quantityRaw;
        } else if (quantityRaw is String) {
          quantity = int.tryParse(quantityRaw);
        } else if (quantityRaw is double) {
          quantity = quantityRaw.toInt();
        }

        // Calculate price for this item
        if (productId != null &&
            quantity != null &&
            productPrices.containsKey(productId)) {
          final itemPrice = productPrices[productId]! * quantity;
          totalPrice += itemPrice;
        }
      }
    }

    //return totalPrice;
    return (totalPrice * 100).round() / 100;
  } catch (e) {
    // Log error for debugging
    print('Error calculating total cart price: $e');

    // Return 0.0 on error, or you could rethrow the exception
    // depending on how you want to handle errors in your app
    return 0.0;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
