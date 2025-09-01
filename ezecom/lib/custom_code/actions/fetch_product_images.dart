// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> fetchProductImages(
  String productId,
) async {
  try {
    final supabase = Supabase.instance.client;

    // Query all records with this product ID
    final response = await supabase
        .from('public_products_view')
        .select('ImageURL')
        .eq('Product_id', productId);

    List<String> imageUrls = [];

    // Process each record
    for (var record in response) {
      final imageData = record['ImageURL'];

      if (imageData is List) {
        // Cast the list to List<String> and add all URLs
        imageUrls.addAll(imageData.cast<String>());
      }
    }

    return imageUrls;
  } catch (e) {
    print('Error fetching product images: $e');
    return [];
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
