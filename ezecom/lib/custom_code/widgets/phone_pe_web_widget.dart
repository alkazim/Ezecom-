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

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PhonePeWebWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final String enquiryId; // The existing Enquiry_ID from your table

  const PhonePeWebWidget({
    Key? key,
    this.width,
    this.height,
    required this.enquiryId,
  }) : super(key: key);

  @override
  State<PhonePeWebWidget> createState() => _PhonePeWebWidgetState();
}

class _PhonePeWebWidgetState extends State<PhonePeWebWidget> {
  bool _isLoading = true;
  String?
      _errorMessage; // This will trigger immediate navigation to PaymentFailed
  String _statusMessage = 'Preparing PhonePe payment...'; // Initial message
  String? _merchantTransactionId; // The UUID from your backend

  // Supabase Edge Function URL for initiating payment
  final String _phonePeBackendInitiateUrl =
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/new-phonpe-initiate';

  // Note: _phonePeBackendStatusCheckUrl and polling logic are REMOVED from here.
  // The dedicated PaymentStatusPage will handle status checks.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initiatePayment();
    });
  }

  @override
  void dispose() {
    // No polling timer to cancel here anymore
    super.dispose();
  }

  // Helper to manage error states and navigate to PaymentFailed IMMEDIATELY
  void _handlePaymentError(String message) {
    print('ERROR in PhonePeWebWidget: $message');
    if (!mounted) return;

    // Immediately navigate away on any error for the web flow after initiation
    context.pushNamed(
      'PaymentFailed', // Ensure this page exists in FlutterFlow
      queryParameters: {
        'errorMessage': message,
        'merchantTransactionId':
            _merchantTransactionId ?? '', // Pass the attempted ID
        'enquiryId': widget.enquiryId,
      }.withoutNulls,
    );

    // Optional: Show snackbar for quick feedback (may be seen briefly before navigation)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
    // No setState here, as navigation is immediate
  }

  Future<void> _initiatePayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _statusMessage = 'Preparing PhonePe payment...';
      _merchantTransactionId = null;
    });

    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken ?? '';

    if (accessToken.isEmpty) {
      _handlePaymentError('Authentication required. Please log in.');
      return;
    }

    try {
      setState(() {
        _statusMessage = 'Requesting payment URL from backend...';
      });

      // Pass 'web' platform to the backend Edge Function
      final response = await http.post(
        Uri.parse(_phonePeBackendInitiateUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'platform': 'web', // Explicitly 'web' for this widget
          'enquiryId': widget.enquiryId,
        }),
      );

      print('📡 Backend Initiate Response status: ${response.statusCode}');
      print('📡 Backend Initiate Response body: ${response.body}');

      if (response.statusCode != 200) {
        final errorResponse = jsonDecode(response.body);
        _handlePaymentError(
            'Payment Initiation Backend Error: ${response.statusCode} - ${errorResponse['error'] ?? 'Unknown'}');
        return;
      }

      final responseData = jsonDecode(response.body);
      if (!responseData['success']) {
        _handlePaymentError(
            'Payment Initiation Failed: ${responseData['details'] ?? 'Unknown Error'}');
        return;
      }

      final String redirectUrl = responseData['redirectUrl'];
      _merchantTransactionId =
          responseData['merchantTransactionId']; // Get the UUID

      if (_merchantTransactionId == null || _merchantTransactionId!.isEmpty) {
        _handlePaymentError(
            'Backend did not provide a valid merchantTransactionId.');
        return;
      }

      if (redirectUrl.isNotEmpty) {
        setState(() {
          _statusMessage = 'Redirecting to PhonePe payment page in new tab...';
          _isLoading =
              false; // Stop loading spinner here as we are about to redirect
        });

        // Launch the URL in a new external browser tab
        if (await canLaunchUrl(Uri.parse(redirectUrl))) {
          await launchUrl(Uri.parse(redirectUrl),
              mode: LaunchMode.externalApplication);
          // After launching, the user will be redirected by PhonePe to your PaymentStatusPage
          // The current widget has done its job.
          // You might navigate away from this widget immediately or show a brief message.
          if (mounted) {
            // You might show a success message or just finish this flow
            // No further polling from this widget.
            // You could optionally navigate to a 'Please complete payment' page here
            // or simply let the user interact with the new tab.
            // For now, let's keep it simple and just show the message below.
          }
        } else {
          _handlePaymentError(
              'Could not launch PhonePe payment URL in a new browser tab.');
        }
      } else {
        _handlePaymentError('PhonePe redirect URL is empty from backend.');
      }
    } catch (e) {
      _handlePaymentError(
          'General Error during payment initiation: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // If an error occurred and was handled, _handlePaymentError already navigated.
    // So this build method will reflect loading or the "redirecting" message.
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _isLoading
            ? _buildLoadingWidget() // Shows initial loading and "Requesting..."
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Redirecting to PhonePe...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 16),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage, // Will be "Redirecting to PhonePe payment page in new tab..."
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please complete payment in the new browser tab that just opened.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You will be redirected back to our app upon completion.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            _statusMessage, // Shows "Preparing PhonePe payment..." or "Requesting..."
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
