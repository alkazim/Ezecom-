// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// File: custom_code/actions/check_phone_pe_payment_status.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

final String _phonePeBackendStatusCheckUrl =
    'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/phonepe-status-check-plan-purchase';

Future<String> checkPhonePePaymentStatusPlan(
  String merchantTransactionId,
) async {
  print(
      'Custom Action: Initiating status check for merchantTransactionId: $merchantTransactionId');

  final session = Supabase.instance.client.auth.currentSession;
  final accessToken = session?.accessToken ?? '';

  if (accessToken.isEmpty) {
    print('ERROR: Authentication token is missing.');
    return 'error';
  }

  if (merchantTransactionId.isEmpty) {
    print('ERROR: merchantTransactionId is empty.');
    return 'error';
  }

  try {
    final response = await http.post(
      Uri.parse(_phonePeBackendStatusCheckUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'merchantTransactionId': merchantTransactionId,
      }),
    );

    final responseData = jsonDecode(response.body);

    print('Status Check Response status: ${response.statusCode}');
    print('Status Check Response body: ${response.body}');

    if (response.statusCode == 200 && responseData['success'] == true) {
      // **FIX IS HERE: Changed 'paymentStatus' to 'paymentState'**
      final String paymentStatus = responseData['paymentState'] ?? 'UNKNOWN';
      print('Payment status: $paymentStatus');

      if (paymentStatus == 'COMPLETED') {
        return 'success';
      } else if (paymentStatus == 'PENDING') {
        return 'error';
      } else {
        return 'failed'; // e.g., FAILED, REFUNDED etc.
      }
    } else {
      final errorMessage = responseData['error'] ??
          responseData['details'] ??
          'Unknown backend error.';
      print('Backend reported failure: $errorMessage');
      return 'error';
    }
  } catch (e) {
    print('EXCEPTION during status check: ${e.toString()}');
    return 'error';
  }
}
