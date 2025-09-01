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

Future<bool> uploadSingleBannerImage(
  String inputImageBase64,
  String target, // must be 'mobile' or 'desktop'
) async {
  const String actionName = 'uploadSingleBannerImage';

  try {
    print('[$actionName] Start');
    print('[$actionName] Target: $target');
    print('[$actionName] Image length: ${inputImageBase64.length}');

    // Validate inputs
    if (inputImageBase64.isEmpty ||
        (target != 'mobile' && target != 'desktop')) {
      print('[$actionName] ERROR: Invalid input');
      return false;
    }

    // Supabase client
    final supabase = Supabase.instance.client;

    // Clean base64 (remove data URL prefix if present)
    String cleanBase64 = inputImageBase64.contains(',')
        ? inputImageBase64.split(',').last
        : inputImageBase64;

    // Decode to bytes
    Uint8List imageBytes = base64Decode(cleanBase64);
    print('[$actionName] Image decoded, size: ${imageBytes.length} bytes');

    // Generate unique filename
    String fileName =
        '${target}_banner_${DateTime.now().millisecondsSinceEpoch}.webp';
    print('[$actionName] Filename: $fileName');

    // Upload to Supabase storage
    final uploadResponse = await supabase.storage
        .from('bannerstorage') // use your bucket name
        .uploadBinary(
          fileName,
          imageBytes,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );

    print('[$actionName] Upload completed: $uploadResponse');

    // Get public URL
    String imageUrl =
        supabase.storage.from('bannerstorage').getPublicUrl(fileName);
    print('[$actionName] Image public URL: $imageUrl');

    // Update correct app state
    FFAppState().update(() {
      if (target == 'mobile') {
        FFAppState().MobileBannerImage = imageUrl;
        print('[$actionName] Updated MobileBannerImage');
      } else if (target == 'desktop') {
        FFAppState().DesktopBannerImage = imageUrl;
        print('[$actionName] Updated DesktopBannerImage');
      }
    });

    print('[$actionName] Success');
    return true;
  } catch (e) {
    print('[$actionName] ERROR: $e');
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
