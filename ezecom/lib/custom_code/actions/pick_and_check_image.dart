// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert'; // Required for base64 encoding

Future<String?> pickAndCheckImage(
  BuildContext context,
  bool fromGallery,
) async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await (fromGallery
        ? picker.pickImage(source: ImageSource.gallery)
        : picker.pickImage(source: ImageSource.camera));

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
      return null;
    }

    // PROPER way to convert image to string
    final bytes = await image.readAsBytes();
    return base64Encode(bytes); // Convert bytes to base64 string
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
    return null;
  }
}
