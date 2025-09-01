// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> checkNotificationField(String authId) async {
  try {
    // Query Supabase for the row with given Auth_ID
    final response = await SupaFlow.client
        .from('client_table')
        .select('Notification')
        .eq('Auth_ID', authId)
        .maybeSingle();

    if (response == null) {
      // No record found for this Auth_ID
      return false;
    }

    final notification = response['Notification'];

    // Check if Notification is null or empty
    if (notification == null) {
      return false;
    }

    // If Notification JSON has any content, return true
    if (notification is Map && notification.isNotEmpty) {
      return true;
    }

    // If Notification is a List (just in case), check too
    if (notification is List && notification.isNotEmpty) {
      return true;
    }

    return false;
  } catch (e) {
    print('Error checking Notification field: $e');
    return false;
  }
}
