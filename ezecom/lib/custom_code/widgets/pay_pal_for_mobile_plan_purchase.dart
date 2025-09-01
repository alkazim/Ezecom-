// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart'
    show kIsWeb; // <--- NEW IMPORT for kIsWeb

import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class PayPalForMobilePlanPurchase extends StatefulWidget {
  final String transactionToken;
  final double? width;
  final double? height;

  const PayPalForMobilePlanPurchase({
    Key? key,
    required this.transactionToken,
    this.width = 400,
    this.height = 600,
  }) : super(key: key);

  @override
  State<PayPalForMobilePlanPurchase> createState() =>
      _PayPalForMobilePlanPurchaseState();
}

// ✅ Fixed class name here:
class _PayPalForMobilePlanPurchaseState
    extends State<PayPalForMobilePlanPurchase> {
  String? _approvalUrl;
  String? _orderId;
  bool _loading = true;
  String? _error;
  InAppWebViewController? _webViewController;
  bool _paymentProcessed = false;
  Timer? _loadingTimeoutTimer;

  final String _createOrderAppUrl =
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/create-paypal-plan-order';
  final String _captureOrderAppUrl =
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/capture-paypal-plan-purchase';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initiatePayment();
    } else {
      setState(() {
        _loading = false;
        _error = 'PayPal payment is not supported on web.';
      });
    }
  }

  @override
  void dispose() {
    _loadingTimeoutTimer?.cancel();
    _webViewController?.dispose();
    super.dispose();
  }

  void _clearLoadingTimeout() {
    _loadingTimeoutTimer?.cancel();
    _loadingTimeoutTimer = null;
  }

  Future<void> _initiatePayment() async {
    setState(() {
      _loading = true;
      _error = null;
      _approvalUrl = null;
      _orderId = null;
      _paymentProcessed = false;
    });

    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken ?? '';

    if (accessToken.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'Authentication required. Please log in.';
      });
      return;
    }

    try {
      print(
          '🚀 Initiating payment for transactionToken: ${widget.transactionToken}');

      final response = await http.post(
        Uri.parse(_createOrderAppUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'transaction_token': widget.transactionToken,
        }),
      );

      print(
          '📡 create-app-paypal-plan-order Response status: ${response.statusCode}');
      print('📡 create-app-paypal-plan-order Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['approval_url'] != null) {
        print('✅ PayPal order created successfully. Approval URL received.');

        setState(() {
          _approvalUrl = data['approval_url'];
          _orderId = data['order_id'];
          _loading = false;
        });

        _loadingTimeoutTimer = Timer(const Duration(seconds: 30), () {
          print('⏰ WebView loading timed out.');
          if (mounted && !_paymentProcessed) {
            _clearLoadingTimeout();
            context.pushNamed('PaymentFailed');
          }
        });
      } else {
        print(
            '❌ PayPal order creation failed: ${data['error'] ?? 'Unknown error'}');
        setState(() {
          _loading = false;
          _error = data['error'] ?? 'Failed to create PayPal order.';
        });
        if (mounted) context.pushNamed('PaymentFailed');
      }
    } catch (e) {
      print('💥 Exception during payment initiation: $e');
      setState(() {
        _loading = false;
        _error = e.toString();
      });
      if (mounted) context.pushNamed('PaymentFailed');
    }
  }

  Future<void> _captureAndVerifyPayment() async {
    if (_paymentProcessed) return;
    _paymentProcessed = true;
    _clearLoadingTimeout();

    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken ?? '';
    if (accessToken.isEmpty) {
      print('🚫 No access token for capture/verification.');
      if (mounted) context.pushNamed('PaymentFailed');
      return;
    }

    if (_orderId == null || widget.transactionToken.isEmpty) {
      print('🚫 Missing orderId or transactionToken for capture/verification.');
      if (mounted) context.pushNamed('PaymentFailed');
      return;
    }

    try {
      print(
          '✨ Attempting to CAPTURE PayPal Order ID: $_orderId for Transaction Token: ${widget.transactionToken}');
      final captureResponse = await http.post(
        Uri.parse(_captureOrderAppUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'order_id': _orderId,
          'transaction_token': widget.transactionToken,
        }),
      );

      print(
          '📡 capture-paypal-order Response status: ${captureResponse.statusCode}');
      print('📡 capture-paypal-order Response body: ${captureResponse.body}');

      if (captureResponse.statusCode == 200) {
        final captureData = jsonDecode(captureResponse.body);
        print('✅ Capture function response: $captureData');

        if (captureData['success'] == true &&
            captureData['status'] == 'COMPLETED') {
          print('🎉 Payment COMPLETED successfully!');
          if (mounted) context.pushNamed('PaymentSuccessful');
        } else {
          print(
              '⚠ Capture was not successful. Status: ${captureData['status']}');
          if (mounted) context.pushNamed('PaymentFailed');
        }
      } else {
        print(
            '❌ Capture function call failed. Status: ${captureResponse.statusCode}');
        if (mounted) context.pushNamed('PaymentFailed');
      }
    } catch (e) {
      print('💥 Exception during capture/verification: $e');
      if (mounted) context.pushNamed('PaymentFailed');
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Text(
        _error ?? 'Something went wrong',
        style: TextStyle(fontSize: 16, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildWebViewContent() {
    if (_approvalUrl == null) {
      return _buildLoadingWidget();
    }
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(_approvalUrl!)),
      onWebViewCreated: (controller) => _webViewController = controller,
      onLoadStop: (controller, url) {
        print('✅ WebView loaded: $url');
        _clearLoadingTimeout();
      },
      onLoadError: (controller, url, code, message) {
        print('⚠ WebView Load Error: $code - $message');
        _clearLoadingTimeout();
        if (mounted && !_paymentProcessed) context.pushNamed('PaymentFailed');
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final url = navigationAction.request.url.toString();
        print('🔍 Intercepted URL: $url');

        if (url.contains('transfer-Successful') && !_paymentProcessed) {
          _clearLoadingTimeout();
          await _captureAndVerifyPayment();
          return NavigationActionPolicy.CANCEL;
        } else if (url.contains('transfer-Failed') && !_paymentProcessed) {
          print('Payment cancelled by user.');
          _clearLoadingTimeout();
          if (mounted) context.pushNamed('transfer-Failed');
          return NavigationActionPolicy.CANCEL;
        }

        return NavigationActionPolicy.ALLOW;
      },
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        clearCache: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: kIsWeb
          ? Center(
              child: Text(
                'PayPal payment is not supported on web.',
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            )
          : _loading
              ? _buildLoadingWidget()
              : _error != null
                  ? _buildErrorWidget()
                  : _buildWebViewContent(),
    );
  }
}
