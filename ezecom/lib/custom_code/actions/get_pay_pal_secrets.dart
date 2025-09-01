// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Custom Action: getPayPalSecrets
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> getPayPalSecrets(String edgeFunctionUrl) async {
  try {
    // Get current user's access token
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      print('Error: User not authenticated');
      return "null";
    }

    // Make request to your edge function with authentication
    final response = await http.get(
      Uri.parse(edgeFunctionUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Console logging - you'll see these in FlutterFlow debug console
      print('=== PAYPAL SECRETS ===');
      print('Client ID: ${data['clientId']}');
      print('Client Secret: ${data['clientSecret']}');
      print('Sandbox Mode: ${data['sandbox']}');
      print('=====================');

      // Update FlutterFlow App State variables
      FFAppState().update(() {
        FFAppState().clientID = data['clientId'] ?? '';
        FFAppState().secretKey = data['clientSecret'] ?? '';
        FFAppState().sandboxMode =
            data['sandbox']?.toString().toLowerCase() == 'true';
      });

      print('=== APP STATE UPDATED ===');
      print('App State Client ID: ${FFAppState().clientID}');
      print('App State Secret Key: ${FFAppState().secretKey}');
      print('App State Sandbox Mode: ${FFAppState().sandboxMode}');
      print('========================');

      // Return success
      return "true";
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return "null";
    }
  } catch (e) {
    print('Exception occurred: $e');
    return "null";
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
