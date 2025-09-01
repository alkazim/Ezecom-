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
import 'package:http/http.dart' as http;

Future<bool> assignAuthId(String email) async {
  final url = Uri.parse(
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/auth-enhancing');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      //'Authorization': 'Bearer ${SupaFlow.client.supabaseAnonKey}', // ✅ Use FlutterFlow's Supabase config
    },
    body: jsonEncode({'email': email}),
  );

  if (response.statusCode == 200 &&
      response.body.trim() == 'Updated successfully') {
    return true;
  } else {
    print(
        'Error: ${response.statusCode} - ${response.body}'); // ✅ Add error logging
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
