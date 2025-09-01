// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Supabase Search Custom Action for FlutterFlow
// This function takes a search query, checks for category/subcategory matches,
// product names, and then searches product descriptions

import 'dart:async';

Future<List<int>> searchProducts(
  String searchQuery,
) async {
  print("=== STARTING SEARCH ===");
  print("Search query: $searchQuery");

  List<int> matchingProductIds = [];
  final searchWords = searchQuery
      .toLowerCase()
      .split(' ')
      .where((word) => word.isNotEmpty)
      .toList();

  print("Search words: $searchWords");

  if (searchWords.isEmpty) {
    print("No valid search words - returning empty list");
    return [];
  }

  // Step 1: Try to match with Categories
  bool categoryFound = false;
  print("Starting category search...");

  try {
    for (final word in searchWords) {
      print("Searching categories for word: $word");
      final categoryResponse = await Supabase.instance.client
          .from('Categories_Table')
          .select('category_id')
          .ilike('category_name', '%$word%');

      final categories = categoryResponse as List<dynamic>;
      print("Found ${categories.length} matching categories");

      if (categories.isNotEmpty) {
        categoryFound = true;
        print("Category match found for word: $word");

        for (final category in categories) {
          final categoryId = category['category_id'];
          print("Processing category ID: $categoryId");

          final productsResponse = await Supabase.instance.client
              .from('Products_Table')
              .select('Product_id')
              .eq('category_id', categoryId);

          final products = productsResponse as List<dynamic>;
          print("Found ${products.length} products in this category");

          for (final product in products) {
            final productId = product['Product_id'] as int;
            if (!matchingProductIds.contains(productId)) {
              matchingProductIds.add(productId);
              print("Added product ID: $productId");
            }
          }
        }
      }
    }
  } catch (e) {
    print('Error during category search: $e');
  }

  print("After category search, found ${matchingProductIds.length} products");
  print("Category found: $categoryFound");

  // Step 2: If no categories matched, try subcategories
  if (!categoryFound) {
    print("No categories matched - trying subcategories...");

    try {
      for (final word in searchWords) {
        print("Searching subcategories for word: $word");
        final subcategoryResponse = await Supabase.instance.client
            .from('Sub_Category_Table')
            .select('subcategory_id')
            .ilike('subcategory_name', '%$word%');

        final subcategories = subcategoryResponse as List<dynamic>;
        print("Found ${subcategories.length} matching subcategories");

        if (subcategories.isNotEmpty) {
          for (final subcategory in subcategories) {
            final subcategoryId = subcategory['subcategory_id'];
            print("Processing subcategory ID: $subcategoryId");

            final productsResponse = await Supabase.instance.client
                .from('Products_Table')
                .select('Product_id')
                .eq('subcategory_id', subcategoryId);

            final products = productsResponse as List<dynamic>;
            print("Found ${products.length} products in this subcategory");

            for (final product in products) {
              final productId = product['Product_id'] as int;
              if (!matchingProductIds.contains(productId)) {
                matchingProductIds.add(productId);
                print("Added product ID: $productId");
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error during subcategory search: $e');
    }

    print(
        "After subcategory search, found ${matchingProductIds.length} products");
  }

  // Step 3: If no category/subcategory matches, search Product Names
  if (matchingProductIds.isEmpty) {
    print("No category/subcategory matches - searching product names...");

    try {
      for (final word in searchWords) {
        print("Searching product names for word: $word");
        final productsResponse = await Supabase.instance.client
            .from('Products_Table')
            .select('Product_id')
            .ilike('Product_Name', '%$word%');

        final products = productsResponse as List<dynamic>;
        print("Found ${products.length} products with matching names");

        for (final product in products) {
          final productId = product['Product_id'] as int;
          if (!matchingProductIds.contains(productId)) {
            matchingProductIds.add(productId);
            print("Added product ID: $productId");
          }
        }
      }
    } catch (e) {
      print('Error during product name search: $e');
    }

    print(
        "After product name search, found ${matchingProductIds.length} products");
  }

  // Step 4: If no product name matches, search in product descriptions
  if (matchingProductIds.isEmpty) {
    print("No product name matches - searching descriptions...");

    try {
      for (final word in searchWords) {
        print("Searching descriptions for word: $word");
        final productsResponse = await Supabase.instance.client
            .from('Products_Table')
            .select('Product_id')
            .ilike('Description', '%$word%');

        final products = productsResponse as List<dynamic>;
        print("Found ${products.length} products with matching descriptions");

        for (final product in products) {
          final productId = product['Product_id'] as int;
          if (!matchingProductIds.contains(productId)) {
            matchingProductIds.add(productId);
            print("Added product ID: $productId");
          }
        }
      }
    } catch (e) {
      print('Error during description search: $e');
    }

    print(
        "After description search, found ${matchingProductIds.length} products");
  }

  print("=== SEARCH COMPLETE ===");
  print("Final matching product IDs: $matchingProductIds");
  return matchingProductIds;
}
