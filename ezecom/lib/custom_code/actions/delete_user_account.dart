// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

// Your Supabase configuration
//
// https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/clever-responder
// https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/delete-user
const String SUPABASE_URL = 'https://gticwwxjzuftuvilszmq.supabase.co';
const String SUPABASE_ANON_KEY =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd0aWN3d3hqenVmdHV2aWxzem1xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5ODk4MjYsImV4cCI6MjA1NjU2NTgyNn0.HpSlkpTlelnWRgCXsEwx5y7HELa8t7eY4BrcFJH7img';

Future<bool> deleteUserAccount() async {
  try {
    // Get the current user's access token
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print('No user logged in');
      return false;
    }
    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken ?? '';
    //final accessToken = user.accessToken;
    print('Attempting to delete user: ${user.id}');

    // Call the Edge Function
    final response = await http.post(
      Uri.parse('$SUPABASE_URL/functions/v1/delete-user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'apikey': SUPABASE_ANON_KEY,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Sign out the user locally after successful deletion
      await Supabase.instance.client.auth.signOut();
      print('User deleted and signed out successfully');
      return true;
    } else {
      print('Error deleting user: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Exception during user deletion: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
