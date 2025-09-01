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

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Modern, Responsive PayPal Payment Widget for Web
class PayPalForWebPlanPurchase extends StatefulWidget {
  const PayPalForWebPlanPurchase({
    Key? key,
    required this.width,
    required this.height,
    required this.enquiryId,
  }) : super(key: key);

  final double width;
  final double height;
  final String enquiryId;

  @override
  _PayPalForWebPlanPurchaseState createState() =>
      _PayPalForWebPlanPurchaseState();
}

class _PayPalForWebPlanPurchaseState extends State<PayPalForWebPlanPurchase> {
  bool _isLoading = false;
  bool _isPaymentRedirected = false;
  String? _errorMessage;

  final String _createOrderWebUrl =
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/create-paypal-web-plan-order';

  Future<void> _initiatePayPalPayment() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final session = Supabase.instance.client.auth.currentSession;
      final accessToken = session?.accessToken ?? '';

      print('Calling PayPal for Enquiry ID: ${widget.enquiryId}');

      final response = await http.post(
        Uri.parse(_createOrderWebUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'transaction_token': widget.enquiryId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['approval_url'] != null) {
          final approvalUrl = data['approval_url'];

          if (await canLaunchUrl(Uri.parse(approvalUrl))) {
            // Hide the button and show redirect message
            setState(() {
              _isPaymentRedirected = true;
            });

            await launchUrl(Uri.parse(approvalUrl),
                mode: LaunchMode.externalApplication);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Redirecting to PayPal...')),
            );
          } else {
            setState(() {
              _errorMessage = 'Could not launch PayPal page.';
            });
          }
        } else {
          setState(() {
            _errorMessage = data['error'] ?? 'PayPal order creation failed.';
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Server error (${response.statusCode}): ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPaymentButton(double buttonWidth) {
    return SizedBox(
      width: buttonWidth,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _initiatePayPalPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0070BA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        icon: Image.network(
          'https://www.paypalobjects.com/webstatic/icon/pp258.png',
          width: 28,
          height: 28,
        ),
        label: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                'Pay with PayPal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }

  Widget _buildRedirectMessage() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.launch,
                color: Colors.blue.shade600,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                'Redirected to PayPal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete your payment on PayPal.\nOnce payment is completed, you will be redirected to the respective page.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            context.goNamed(
                'HomePage'); // or 'homePage' depending on your route name
          },
          icon: const Icon(Icons.home, color: Colors.white),
          label: const Text('Go to Homepage',
              style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double buttonWidth =
            constraints.maxWidth < 400 ? double.infinity : 280;

        return Center(
          child: Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Secure Payment',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isPaymentRedirected
                        ? 'Payment in progress...'
                        : 'Complete your order via PayPal.',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Show button or redirect message based on state
                  if (!_isPaymentRedirected && _errorMessage == null)
                    _buildPaymentButton(buttonWidth)
                  else if (_isPaymentRedirected)
                    _buildRedirectMessage(),

                  // Error message display
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red.shade600, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentButton(buttonWidth),
                        ],
                      ),
                    ),

                  // Loading state message
                  if (_isLoading && !_isPaymentRedirected)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        'Creating PayPal order...',
                        style: TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
