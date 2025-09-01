// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart'; // Imports custom actions

Future<String> checkEmailAvailability(String mailId) async {
  print('[checkEmailAvailability] Action started with mailId: $mailId');

  try {
    final response = await Supabase.instance.client
        .from('client_table')
        .select('Email')
        .eq('Email', mailId)
        .limit(1)
        .maybeSingle();

    if (response != null) {
      print('[checkEmailAvailability] Email already exists: $mailId');
      return 'false';
    } else {
      print('[checkEmailAvailability] Email is available: $mailId');
      return 'true';
    }
  } catch (e) {
    print('[checkEmailAvailability] Error: $e');
    return 'false';
  }
}
