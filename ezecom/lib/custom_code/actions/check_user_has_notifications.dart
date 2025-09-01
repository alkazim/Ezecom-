// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> checkUserHasNotifications(String authId) async {
  final supabase = Supabase.instance.client;

  try {
    // Simply check if the user's Notification field has content
    final response = await supabase
        .from('client_table')
        .select('Notification')
        .eq('Auth_ID', authId)
        .maybeSingle();

    // Return false if no user record exists
    if (response == null) {
      return false;
    }

    final notificationData = response['Notification'];

    // Check if Notification field has meaningful content
    return notificationData != null &&
        notificationData is Map &&
        notificationData.isNotEmpty;
  } catch (e) {
    print('Error checking notifications: $e');
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
