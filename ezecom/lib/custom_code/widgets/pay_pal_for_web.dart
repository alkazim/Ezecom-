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

// import '/custom_code/widgets/index.dart';
// import '/custom_code/actions/index.dart';
// import '/flutter_flow/custom_functions.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Modern, Responsive PayPal Payment Widget for Web
class PayPalForWeb extends StatefulWidget {
  const PayPalForWeb({
    Key? key,
    required this.width,
    required this.height,
    required this.enquiryId,
  }) : super(key: key);

  final double width;
  final double height;
  final String enquiryId;

  @override
  _PayPalForWebState createState() => _PayPalForWebState();
}

class _PayPalForWebState extends State<PayPalForWeb> {
  bool _isLoading = false;
  String? _errorMessage;

  final String _createOrderWebUrl =
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/create-paypal-order-web';

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
        body: json.encode({'enquiry_id': widget.enquiryId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['approval_url'] != null) {
          final approvalUrl = data['approval_url'];

          if (await canLaunchUrl(Uri.parse(approvalUrl))) {
            await launchUrl(Uri.parse(approvalUrl),
                mode: LaunchMode.externalApplication);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Redirecting to PayPal...')),
            );
          } else {
            _errorMessage = 'Could not launch PayPal page.';
          }
        } else {
          _errorMessage = data['error'] ?? 'PayPal order creation failed.';
        }
      } else {
        _errorMessage =
            'Server error (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Unexpected error: ${e.toString()}';
    } finally {
      setState(() => _isLoading = false);
    }
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
                    'Complete your order via PayPal.',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
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
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        'Redirecting to PayPal...',
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
