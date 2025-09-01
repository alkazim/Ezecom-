// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// End custom FlutterFlow imports

import 'package:http/http.dart' as http;
import 'dart:convert';

// Changed return type to bool
Future<bool> callCapturePaypalOrderWeb(String orderId, String enquiryId) async {
  final String captureOrderWebUrl =
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/capture-paypal-order-web';

  try {
    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken ?? '';

    print(
        'Attempting to capture PayPal order for Order ID: $orderId, Enquiry ID: $enquiryId');

    final response = await http.post(
      Uri.parse(captureOrderWebUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'order_id': orderId,
        'enquiry_id': enquiryId,
      }),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    // Check for HTTP 200 OK and the 'success' flag in the JSON response
    if (response.statusCode == 200 && responseData['success'] == true) {
      print('PayPal capture successful.');
      return true; // Return true for success
    } else {
      final String errorMessage =
          responseData['error'] ?? 'Unknown capture error.';
      print(
          'PayPal capture failed (Status: ${response.statusCode}): $errorMessage');
      return false; // Return false for failure
    }
  } catch (e) {
    print('Exception calling capture-paypal-order-web: $e');
    return false; // Return false for any exception
  }
}
