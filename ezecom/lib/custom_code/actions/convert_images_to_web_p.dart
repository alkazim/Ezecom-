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
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<bool> convertImagesToWebP(
  String mobileImageBase64,
  String desktopImageBase64,
) async {
  try {
    // Validate input parameters
    if (mobileImageBase64.isEmpty || desktopImageBase64.isEmpty) {
      print('Error: Empty base64 strings provided');
      return false;
    }

    // Clean mobile base64 string
    String cleanMobileBase64 = mobileImageBase64.contains(',')
        ? mobileImageBase64.split(',').last
        : mobileImageBase64;

    // Clean desktop base64 string
    String cleanDesktopBase64 = desktopImageBase64.contains(',')
        ? desktopImageBase64.split(',').last
        : desktopImageBase64;

    // Convert mobile image to WebP
    final mobileBytes = base64Decode(cleanMobileBase64);
    final mobileWebP = await FlutterImageCompress.compressWithList(
      mobileBytes,
      quality: 90,
      format: CompressFormat.webp,
    );

    if (mobileWebP == null) {
      print('Error: Failed to compress mobile image');
      return false;
    }

    // Convert desktop image to WebP
    final desktopBytes = base64Decode(cleanDesktopBase64);
    final desktopWebP = await FlutterImageCompress.compressWithList(
      desktopBytes,
      quality: 90,
      format: CompressFormat.webp,
    );

    if (desktopWebP == null) {
      print('Error: Failed to compress desktop image');
      return false;
    }

    // Convert back to base64 and update app state
    FFAppState().MobileBannerImage = base64Encode(mobileWebP);
    FFAppState().DesktopBannerImage = base64Encode(desktopWebP);

    print('Images successfully converted to WebP format');
    return true;
  } catch (e) {
    print('Error converting images: $e');
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
