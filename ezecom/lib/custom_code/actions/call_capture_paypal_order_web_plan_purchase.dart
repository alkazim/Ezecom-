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

Future<bool> callCapturePaypalOrderWebPlanPurchase(
  BuildContext context,
  String transactionToken, // ✅ PayPal token (leave as-is)
  String orderId, // ✅ Internal transaction_token (used for lookup)
) async {
  final String captureOrderWebUrl =
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/capture-paypal-plan-purchase';

  try {
    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken ?? '';

    print('[DEBUG] Step 1: Fetching session and access token');
    if (accessToken.isEmpty) {
      print('[ERROR] Access token is missing. User may not be logged in.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in. Please sign in again.')),
      );
      return false;
    }

    print(
        '[DEBUG] Step 2: Looking up Gateway_Order_ID for transaction_token (orderId): $orderId');

    final record = await Supabase.instance.client
        .from('Payment_Transactions_Plan')
        .select('Gateway_Order_ID')
        .eq('transaction_token', orderId)
        .maybeSingle();

    if (record == null || record['Gateway_Order_ID'] == null) {
      print(
          '[ERROR] No Gateway_Order_ID found for transaction_token: $orderId');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Order not found or invalid transaction token.')),
      );
      return false;
    }

    final String gatewayOrderId = record['Gateway_Order_ID'];
    print('[DEBUG] Step 3: Found Gateway_Order_ID: $gatewayOrderId');

    print('[DEBUG] Step 4: Sending capture request');

    final response = await http.post(
      Uri.parse(captureOrderWebUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'transaction_token': orderId, // ✅ Internal token (unchanged)
        'order_id': gatewayOrderId, // ✅ Real PayPal Order ID from DB
      }),
    );

    print('[DEBUG] Step 5: HTTP status code: ${response.statusCode}');
    print('[DEBUG] Step 6: Response body: ${response.body}');

    Map<String, dynamic> responseData = {};
    try {
      responseData = json.decode(response.body);
    } catch (decodeError) {
      print('[ERROR] Failed to decode JSON response: $decodeError');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid server response.')),
      );
      return false;
    }

    if (response.statusCode == 200 && responseData['success'] == true) {
      print('[SUCCESS] PayPal capture successful.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful!')),
      );
      return true;
    } else {
      final String errorMessage =
          responseData['error'] ?? 'Unknown capture error.';
      print('[ERROR] Capture failed: $errorMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capture failed: $errorMessage')),
      );
      return false;
    }
  } catch (e) {
    print('[EXCEPTION] Exception occurred during capture: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unexpected error occurred.')),
    );
    return false;
  }
}
