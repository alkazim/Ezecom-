// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import '/flutter_flow/flutter_flow_theme.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

// FlutterFlow Compatible Custom Action - Modified for List Upload
// Return Type: List<String> (publicUrls on success, empty list on failure)
Future<List<String>> uploadSelectedImageToSupabase(
  List<String> selectedImageUrl,
) async {
  // Default values
  String bucketName = "productimages";
  String folderPath = "Seller/";
  List<String> publicUrls = [];

  // DEBUG: Function entry
  print(
      '[DEBUG] uploadSelectedImageToSupabase called with ${selectedImageUrl.length} images');

  try {
    // Validate input - At least 1 image required
    if (selectedImageUrl.isEmpty) {
      print('[DEBUG] No images provided - at least 1 image is required');
      return [];
    }

    // Filter out empty/null images and keep only valid ones
    List<String> validImages = selectedImageUrl
        .where((imageUrl) => imageUrl.isNotEmpty && imageUrl.trim().isNotEmpty)
        .toList();

    print(
        '[DEBUG] Original list had ${selectedImageUrl.length} items, ${validImages.length} are valid images');

    // Check if we have at least 1 valid image after filtering
    if (validImages.isEmpty) {
      print(
          '[DEBUG] No valid images found after filtering - at least 1 valid image is required');
      return [];
    }

    print(
        '[DEBUG] Validation passed - proceeding with ${validImages.length} valid image(s)');

    // Get Supabase client
    final supabase = Supabase.instance.client;

    // Process each valid image in the filtered list
    for (int i = 0; i < validImages.length; i++) {
      String currentImageUrl = validImages[i];

      print('[DEBUG] Processing image ${i + 1}/${validImages.length}');

      // Generate unique filename for this image
      String fileName =
          "ezecom_${DateTime.now().millisecondsSinceEpoch}_$i.jpg";

      // Remove data URL prefix if present
      String cleanBase64 = currentImageUrl;
      String contentType = 'image/jpeg';

      if (currentImageUrl.contains(',')) {
        List<String> parts = currentImageUrl.split(',');
        String mimeInfo = parts[0];
        cleanBase64 = parts[1];

        print('[DEBUG] MIME info detected for image $i: $mimeInfo');

        if (mimeInfo.contains('image/png')) {
          contentType = 'image/png';
          fileName = fileName.replaceAll('.jpg', '.png');
        } else if (mimeInfo.contains('image/webp')) {
          contentType = 'image/webp';
          fileName = fileName.replaceAll('.jpg', '.webp');
        }
      }

      // Decode base64 to bytes
      Uint8List imageBytes;
      try {
        imageBytes = base64Decode(cleanBase64);
      } catch (e) {
        print('[DEBUG] Invalid base64 format for image $i: ${e.toString()}');
        return [];
      }

      print('[DEBUG] Image $i decoded (size: ${imageBytes.length} bytes)');

      // Check file size (5MB limit)
      const int maxSizeBytes = 5 * 1024 * 1024;
      if (imageBytes.length > maxSizeBytes) {
        print('[DEBUG] Image $i too large: ${imageBytes.length} bytes');
        return [];
      }

      // Construct full path
      String prefix = folderPath.isEmpty
          ? ''
          : (folderPath.endsWith('/') ? folderPath : '$folderPath/');
      String fullPath = '$prefix$fileName';

      print('[DEBUG] Full path for image $i: $fullPath');

      // Upload to Supabase Storage
      try {
        print('[DEBUG] Uploading image $i to bucket: $bucketName');
        await supabase.storage.from(bucketName).uploadBinary(
              fullPath,
              imageBytes,
              fileOptions: FileOptions(
                contentType: contentType,
                upsert: true,
              ),
            );
        print('[DEBUG] Upload successful for image $i');
      } catch (e) {
        print('[DEBUG] Upload failed for image $i: ${e.toString()}');
        return [];
      }

      // Get public URL
      String publicUrl;
      try {
        publicUrl = supabase.storage.from(bucketName).getPublicUrl(fullPath);
        print('[DEBUG] Public URL obtained for image $i: $publicUrl');
        publicUrls.add(publicUrl);
      } catch (e) {
        print('[DEBUG] Failed to get public URL for image $i: ${e.toString()}');
        return [];
      }
    }

    // All images processed successfully - return public URLs list
    print(
        '[DEBUG] SUCCESS: All ${validImages.length} valid image(s) uploaded successfully');
    print('[DEBUG] Returning ${publicUrls.length} public URLs: $publicUrls');
    return publicUrls;
  } catch (e) {
    print('[DEBUG] Unexpected error: ${e.toString()}');
    return [];
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
