// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

Future<void> testHideSystemUI() async {
  try {
    // Log platform info
    print('Current platform: ${defaultTargetPlatform}');
    print('Attempting to hide system UI...');

    // Try to hide UI using immersive mode
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );

    print('System UI hide command executed successfully');

    // Add a delay to observe results
    await Future.delayed(Duration(seconds: 3));

    // Check current UI mode (if possible)
    print('Current system UI mode: ${SystemUiMode.values}');
  } catch (e) {
    print('Error hiding system UI: $e');
  }
}
