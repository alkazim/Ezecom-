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
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<bool> singleImageToWebP(
  String inputImageBase64,
  String target, // must be "mobile" or "desktop"
) async {
  try {
    if (inputImageBase64.isEmpty ||
        (target != 'mobile' && target != 'desktop')) {
      print('Error: invalid input');
      return false;
    }

    // Clean base64 string
    String cleanBase64 = inputImageBase64.contains(',')
        ? inputImageBase64.split(',').last
        : inputImageBase64;

    // Decode and compress to WebP
    final bytes = base64Decode(cleanBase64);
    final webpBytes = await FlutterImageCompress.compressWithList(
      bytes,
      quality: 90,
      format: CompressFormat.webp,
    );

    if (webpBytes == null) {
      print('Error: Failed to compress image');
      return false;
    }

    final newBase64 = base64Encode(webpBytes);

    // Update the correct app state variable
    if (target == 'mobile') {
      FFAppState().MobileBannerImage = newBase64;
      print('Updated MobileBannerImage');
    } else if (target == 'desktop') {
      FFAppState().DesktopBannerImage = newBase64;
      print('Updated DesktopBannerImage');
    }

    return true;
  } catch (e) {
    print('Error converting image: $e');
    return false;
  }
}
