// Automatic FlutterFlow imports
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/custom_code/widgets/index.dart' as custom_widgets;

const String returnURL = 'https://empiric.infotech/return';
const String cancelURL = 'https://empiric.infotech/cancel';

Future<bool> paypalPay(
  BuildContext context,
  String clientId,
  String secretKey,
  double totalAmount,
  String? currencyCode,
  String? desc,
  String? payerNote,
  dynamic? amountDetail,
  List<dynamic>? products,
  dynamic? shippingAddress,
  bool? isSandBoxMode,
  Future Function(dynamic data)? onSuccess,
  Future Function(dynamic params)? onCancel,
  Future Function(String message)? onError,
) async {
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
    debugPrint('Paypal pay is only supported on android and iOS.');
    return false;
  }
  final String domain = isSandBoxMode ?? false
      ? 'https://api.sandbox.paypal.com'
      : 'https://api.paypal.com';

  // get token start
  String? accessToken;
  try {
    var res = await http.post(
      Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'),
      headers: {
        'Authorization':
            'Basic ${base64.encode(latin1.encode('$clientId:$secretKey')).trim()}'
      },
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      accessToken = body['access_token'].toString();
    } else {
      (onError ?? debugPrint).call('Your PayPal credentials seems incorrect');
    }
  } catch (e) {
    (onError ?? debugPrint).call('Unable to generate access token. error: $e');
  }
  if (accessToken == null) return false;
  // get token end

  // create payment start
  String? executeUrl, checkoutUrl;
  try {
    final payload = {
      'intent': 'sale',
      'payer': {'payment_method': 'paypal'},
      if (payerNote != null) 'note_to_payer': payerNote,
      'transactions': [
        {
          'amount': {
            'total': totalAmount.toStringAsFixed(2),
            'currency': currencyCode ?? 'USD',
            if (amountDetail != null &&
                amountDetail is Map<String, dynamic> &&
                amountDetail.isNotEmpty)
              'details': amountDetail.map((key, value) => MapEntry(
                  key, value is double ? value.toStringAsFixed(2) : value)),
          },
          if ((products != null && products.isNotEmpty) ||
              shippingAddress != null)
            'item_list': {
              if (products != null && products.isNotEmpty)
                'items': products
                    .map((e) {
                      if (e is Map<String, dynamic>) {
                        return e.map((key, value) => MapEntry(
                            key,
                            value is double
                                ? value.toStringAsFixed(2)
                                : value));
                      }
                      return null;
                    })
                    .nonNulls
                    .toList(),
              if (shippingAddress != null &&
                  shippingAddress is Map<String, String>)
                'shipping_address': shippingAddress,
            },
          'payment_options': {'allowed_payment_method': 'IMMEDIATE_PAY'},
          if (desc != null) 'description': desc,
        },
      ],
      'redirect_urls': {'return_url': returnURL, 'cancel_url': cancelURL}
    };
    var res = await http.post(
      Uri.parse('$domain/v1/payments/payment'),
      body: jsonEncode(payload),
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    final body = jsonDecode(res.body);
    if (res.statusCode == 201 &&
        body['links'] != null &&
        body['links'] is List &&
        body['links'].length > 0) {
      final List links = body['links'] as List;
      executeUrl = links.firstWhere((o) => o['rel'] == 'execute',
              orElse: () => null)?['href'] ??
          '';
      checkoutUrl = links.firstWhere((o) => o['rel'] == 'approval_url',
              orElse: () => null)?['href'] ??
          '';
    } else {
      (onError ?? debugPrint).call('Unable to create payment. data: $body');
    }
  } catch (e) {
    (onError ?? debugPrint).call('Unable to create payment. error: $e');
  }
  if (executeUrl == null || checkoutUrl == null) return false;
  // create payment end

  // Opening webview to capture payment.
  if (context.mounted) {
    final res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => custom_widgets.PaypalWebview(
          checkOutUrl: checkoutUrl!,
          executeUrl: executeUrl!,
          accessToken: accessToken!,
          onSuccess: onSuccess,
          onCancel: onCancel,
          onError: onError,
        ),
      ),
    );
    // returning results.
    if (res is bool) return res;
  }

  return false;
}
