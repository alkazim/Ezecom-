// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions

Future<String> getUserRole4() async {
  try {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print("No authenticated user, returning 'noUser'");
      return 'noUser';
    }

    final uid = user.id;
    print("Fetching Role for UID: $uid");

    final response = await Supabase.instance.client
        .from('client_table')
        .select('Role')
        .eq('Auth_ID', uid)
        .maybeSingle();

    print("fetchRole response -------------$response");

    return (response?['Role'] as String?) ?? 'noUser';
  } catch (e) {
    print('Error fetching role: $e');
    return 'noUser';
  }
}
