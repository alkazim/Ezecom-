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
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> uploadBannerImages(
  String mobileImageBase64,
  String desktopImageBase64,
) async {
  const String actionName = 'uploadBannerImages';

  try {
    // Debug: Action started
    print('[$actionName] Starting image upload process');
    print('[$actionName] Mobile image length: ${mobileImageBase64.length}');
    print('[$actionName] Desktop image length: ${desktopImageBase64.length}');

    // Get Supabase client
    final supabase = Supabase.instance.client;
    print('[$actionName] Supabase client initialized');

    // Validate base64 strings
    if (mobileImageBase64.isEmpty || desktopImageBase64.isEmpty) {
      print('[$actionName] ERROR: One or both base64 strings are empty');
      return false;
    }

    // Process mobile image
    String mobileImageUrl = '';
    try {
      print('[$actionName] Processing mobile banner image...');

      // Remove data URL prefix if present
      String cleanMobileBase64 = mobileImageBase64;
      if (mobileImageBase64.contains(',')) {
        cleanMobileBase64 = mobileImageBase64.split(',').last;
        print('[$actionName] Removed data URL prefix from mobile image');
      }

      // Decode base64 to bytes
      Uint8List mobileImageBytes = base64Decode(cleanMobileBase64);
      print(
          '[$actionName] Mobile image decoded, size: ${mobileImageBytes.length} bytes');

      // Generate unique filename
      String mobileFileName =
          'mobile_banner_${DateTime.now().millisecondsSinceEpoch}.webp';
      print('[$actionName] Mobile filename: $mobileFileName');

      // Upload to Supabase storage - using correct bucket name
      final mobileUploadResponse =
          await supabase.storage.from('bannerstorage').uploadBinary(
                mobileFileName,
                mobileImageBytes,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: true,
                ),
              );

      print(
          '[$actionName] Mobile image uploaded successfully: $mobileFileName');

      // Get public URL - using correct bucket name
      mobileImageUrl =
          supabase.storage.from('bannerstorage').getPublicUrl(mobileFileName);

      print('[$actionName] Mobile image URL: $mobileImageUrl');
    } catch (e) {
      print('[$actionName] ERROR uploading mobile image: $e');
      return false;
    }

    // Process desktop image
    String desktopImageUrl = '';
    try {
      print('[$actionName] Processing desktop banner image...');

      // Remove data URL prefix if present
      String cleanDesktopBase64 = desktopImageBase64;
      if (desktopImageBase64.contains(',')) {
        cleanDesktopBase64 = desktopImageBase64.split(',').last;
        print('[$actionName] Removed data URL prefix from desktop image');
      }

      // Decode base64 to bytes
      Uint8List desktopImageBytes = base64Decode(cleanDesktopBase64);
      print(
          '[$actionName] Desktop image decoded, size: ${desktopImageBytes.length} bytes');

      // Generate unique filename
      String desktopFileName =
          'desktop_banner_${DateTime.now().millisecondsSinceEpoch}.webp';
      print('[$actionName] Desktop filename: $desktopFileName');

      // Upload to Supabase storage - using correct bucket name
      final desktopUploadResponse =
          await supabase.storage.from('bannerstorage').uploadBinary(
                desktopFileName,
                desktopImageBytes,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: true,
                ),
              );

      print(
          '[$actionName] Desktop image uploaded successfully: $desktopFileName');

      // Get public URL - using correct bucket name
      desktopImageUrl =
          supabase.storage.from('bannerstorage').getPublicUrl(desktopFileName);

      print('[$actionName] Desktop image URL: $desktopImageUrl');
    } catch (e) {
      print('[$actionName] ERROR uploading desktop image: $e');
      return false;
    }

    // Update app state variables
    try {
      print('[$actionName] Updating app state variables...');

      // Update mobile banner image app state
      FFAppState().update(() {
        FFAppState().MobileBannerImage = mobileImageUrl;
      });
      print(
          '[$actionName] MobileBannerImage updated: ${FFAppState().MobileBannerImage}');

      // Update desktop banner image app state
      FFAppState().update(() {
        FFAppState().DesktopBannerImage = desktopImageUrl;
      });
      print(
          '[$actionName] DesktopBannerImage updated: ${FFAppState().DesktopBannerImage}');

      print('[$actionName] App state variables updated successfully');
    } catch (e) {
      print('[$actionName] ERROR updating app state: $e');
      return false;
    }

    print('[$actionName] Action completed successfully');
    return true;
  } catch (e) {
    print('[$actionName] FATAL ERROR: $e');
    return false;
  }
}

// Alternative version with error handling and retry logic
Future<bool> uploadBannerImagesWithRetry(
    String mobileImageBase64, String desktopImageBase64,
    {int maxRetries = 3}) async {
  const String actionName = 'uploadBannerImagesWithRetry';

  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    print('[$actionName] Attempt $attempt of $maxRetries');

    bool success =
        await uploadBannerImages(mobileImageBase64, desktopImageBase64);

    if (success) {
      print('[$actionName] Upload successful on attempt $attempt');
      return true;
    } else {
      print('[$actionName] Upload failed on attempt $attempt');
      if (attempt < maxRetries) {
        print('[$actionName] Retrying in 2 seconds...');
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  print('[$actionName] All attempts failed');
  return false;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
