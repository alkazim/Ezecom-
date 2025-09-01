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
import 'package:url_launcher/url_launcher.dart';

Future<void> createPayPalOrder(double amount) async {
  try {
    debugPrint('Starting PayPal order creation...');
    debugPrint('Amount: \$${amount.toStringAsFixed(2)}');

    // Step 1: Get Access Token
    final String clientId = FFAppState().clientID;
    final String clientSecret = FFAppState().secretKey;

    final String credentials =
        base64Encode(utf8.encode('$clientId:$clientSecret'));

    final tokenResponse = await http.post(
      Uri.parse('https://api-m.sandbox.paypal.com/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (tokenResponse.statusCode != 200) {
      debugPrint('Failed to get access token: ${tokenResponse.body}');
      return;
    }

    final tokenData = jsonDecode(tokenResponse.body);
    final String accessToken = tokenData['access_token'];

    // Step 2: Create Order
    final orderPayload = {
      'intent': 'CAPTURE',
      'purchase_units': [
        {
          'amount': {
            'currency_code': 'USD',
            'value': amount.toStringAsFixed(2),
          }
        }
      ],
      'application_context': {
        'return_url': 'https://ezecom.shop/homePage',
        'cancel_url': 'razorpaychecking://razorpaychecking.com/paymentSuccess',
        'user_action': 'PAY_NOW',
      }
    };

    final orderResponse = await http.post(
      Uri.parse('https://api-m.sandbox.paypal.com/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(orderPayload),
    );

    if (orderResponse.statusCode == 201) {
      final orderData = jsonDecode(orderResponse.body);
      print(orderData);
      for (var link in orderData['links']) {
        if (link['rel'] == 'approve') {
          final approvalUrl = link['href'];
          debugPrint('Launching approval URL: $approvalUrl');
          final uri = Uri.parse(approvalUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri,
                mode: LaunchMode.externalApplication); // launches browser
          } else {
            debugPrint('Could not launch approval URL');
          }
          return;
        }
      }
      debugPrint('Approval link not found in response');
    } else {
      debugPrint('Order creation failed: ${orderResponse.body}');
    }
  } catch (e) {
    debugPrint('Exception during PayPal order creation: $e');
  }
}
