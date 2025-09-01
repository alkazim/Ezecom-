// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Import required packages
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> getAccessToken() async {
  try {
    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken;

    if (accessToken != null && accessToken.isNotEmpty) {
      return accessToken;
    } else {
      return 'false';
    }
  } catch (e) {
    // In case of any unexpected error
    return 'false';
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
