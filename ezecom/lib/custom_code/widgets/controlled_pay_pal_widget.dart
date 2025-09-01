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

import 'package:webview_flutter/webview_flutter.dart';

class ControlledPayPalWidget extends StatefulWidget {
  const ControlledPayPalWidget({
    Key? key,
    this.width,
    this.height,
    required this.enquiryId,
    required this.amount,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String enquiryId;
  final double amount;

  @override
  _ControlledPayPalWidgetState createState() => _ControlledPayPalWidgetState();
}

class _ControlledPayPalWidgetState extends State<ControlledPayPalWidget> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _paymentResult = ''; // 'success', 'failed', 'cancelled', or empty

  static const String clientId =
      "AUVJZpt1lY0eI10OVbKYcjUUhBV8isWUGOyeAv7rqTDeKDz1_eK4Hc0trVA_x96ImFkPFqxFe3x_yqFn";

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            print('Navigation to: $url');

            // Only handle payment result URLs
            if (url.contains('payment-success')) {
              setState(() => _paymentResult = 'success');
              return NavigationDecision.prevent;
            }
            if (url.contains('payment-cancel')) {
              setState(() => _paymentResult = 'cancelled');
              return NavigationDecision.prevent;
            }
            if (url.contains('payment-error') ||
                url.contains('payment-failure')) {
              setState(() => _paymentResult = 'failed');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    _loadPayment();
  }

  // Getter to check payment status - FlutterFlow can use this
  String get paymentStatus => _paymentResult;
  bool get isPaymentCompleted => _paymentResult == 'success';
  bool get isPaymentFailed => _paymentResult == 'failed';
  bool get isPaymentCancelled => _paymentResult == 'cancelled';

  Future<void> _loadPayment() async {
    final paymentHtml = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://www.paypal.com/sdk/js?client-id=$clientId&currency=USD"></script>
        <style>
          body {
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f8f9fa;
          }
          .payment-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
          }
          .amount {
            font-size: 32px;
            font-weight: bold;
            color: #0070ba;
            margin-bottom: 8px;
          }
          .enquiry {
            font-size: 14px;
            color: #666;
            background: #f0f0f0;
            padding: 8px 12px;
            border-radius: 6px;
            display: inline-block;
            margin-bottom: 20px;
          }
          #paypal-button-container {
            margin: 20px 0;
          }
          .secure-text {
            font-size: 12px;
            color: #888;
            margin-top: 15px;
          }
        </style>
      </head>
      <body>
        <div class="payment-container">
          <div class="amount">\$${widget.amount.toStringAsFixed(2)}</div>
          <div class="enquiry">Enquiry: ${widget.enquiryId}</div>
          <div id="paypal-button-container"></div>
          <div class="secure-text">🔒 Secured by PayPal</div>
        </div>
        
        <script>
          paypal.Buttons({
            style: {
              layout: 'vertical',
              color: 'blue',
              shape: 'rect',
              label: 'paypal',
              height: 45
            },
            createOrder: function(data, actions) {
              return actions.order.create({
                purchase_units: [{
                  description: 'Payment for Enquiry: ${widget.enquiryId}',
                  amount: {
                    value: '${widget.amount.toStringAsFixed(2)}',
                    currency_code: 'USD'
                  },
                  custom_id: '${widget.enquiryId}'
                }],
                application_context: {
                  shipping_preference: 'NO_SHIPPING'
                }
              });
            },
            onApprove: function(data, actions) {
              return actions.order.capture().then(function(details) {
                console.log('Payment completed successfully!');
                console.log('Transaction ID:', details.id);
                
                // This will trigger the navigation delegate
                window.location.href = '/payment-success?orderId=' + data.orderID + '&enquiry=${widget.enquiryId}&transactionId=' + details.id;
              }).catch(function(error) {
                console.error('Capture failed:', error);
                window.location.href = '/payment-error?enquiry=${widget.enquiryId}';
              });
            },
            onCancel: function(data) {
              console.log('Payment cancelled by user');
              window.location.href = '/payment-cancel?enquiry=${widget.enquiryId}';
            },
            onError: function(err) {
              console.error('PayPal error:', err);
              window.location.href = '/payment-error?enquiry=${widget.enquiryId}';
            }
          }).render('#paypal-button-container');
        </script>
      </body>
      </html>
    ''';

    await _controller.loadHtmlString(paymentHtml);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),

            // Loading state
            if (_isLoading)
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF0070BA)),
                      ),
                      SizedBox(height: 16),
                      Text('Loading PayPal...',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),

            // Payment result overlay
            if (_paymentResult.isNotEmpty)
              Container(
                color: Colors.white.withOpacity(0.95),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _paymentResult == 'success'
                            ? Icons.check_circle
                            : _paymentResult == 'cancelled'
                                ? Icons.cancel
                                : Icons.error,
                        size: 60,
                        color: _paymentResult == 'success'
                            ? Colors.green
                            : _paymentResult == 'cancelled'
                                ? Colors.orange
                                : Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        _paymentResult == 'success'
                            ? 'Payment Successful!'
                            : _paymentResult == 'cancelled'
                                ? 'Payment Cancelled'
                                : 'Payment Failed',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Enquiry: ${widget.enquiryId}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
