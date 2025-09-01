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

// NEW/UPDATED IMPORTS for InAppWebView approach
import 'dart:async'; // Required for Timer
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // Direct InAppWebView usage

// NOTE: No phone_pe_pg import needed anymore here as we are using InAppWebView directly.

class PhonePeMobileWidget extends StatefulWidget {
  final String enquiryId;
  final double? width;
  final double? height;

  const PhonePeMobileWidget({
    Key? key,
    required this.enquiryId,
    this.width = 400, // Default width
    this.height = 600, // Default height
  }) : super(key: key);

  @override
  State<PhonePeMobileWidget> createState() => _PhonePeMobileWidgetState();
}

class _PhonePeMobileWidgetState extends State<PhonePeMobileWidget> {
  String? _phonePeRedirectUrl;
  String? _merchantTransactionId;
  bool _isLoading = true; // Use _isLoading to manage the initial state
  String?
      _errorMessage; // This will hold the error message for on-screen display
  InAppWebViewController? _webViewController;
  bool _paymentProcessed =
      false; // To prevent multiple verifications/navigations
  Timer? _loadingTimeoutTimer; // Timer for initial WebView load

  // Supabase Edge Function URL for PhonePe order creation
  final String _phonePeBackendInitiateUrl =
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/new-phonpe-initiate';

  // Supabase Edge Function URL for checking payment status securely
  final String _phonePeBackendStatusCheckUrl =
      'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/phonepe-status-check';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initiatePhonePePayment();
      });
    } else {
      // For web, set error directly as this widget is for mobile only
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Error: This widget is for mobile only. Use PhonePeForWeb for web.';
      });
    }
  }

  @override
  void dispose() {
    _loadingTimeoutTimer?.cancel();
    // No explicit dispose for _webViewController needed here, InAppWebView manages it
    super.dispose();
  }

  void _clearLoadingTimeout() {
    _loadingTimeoutTimer?.cancel();
    _loadingTimeoutTimer = null;
  }

  // Helper to update the error message and state to show the error widget
  // Now also triggers navigation to PaymentFailed page
  void _updateErrorAndStopLoading(String message) {
    print('ERROR displayed on screen: $message'); // Log to console as well

    if (!mounted) return; // Ensure widget is still in the tree

    // Only set error state and navigate if a final outcome hasn't been processed yet
    if (!_paymentProcessed) {
      _paymentProcessed =
          true; // Mark as processed to prevent multiple navigations
      _clearLoadingTimeout(); // Cancel any pending timeouts

      setState(() {
        _isLoading = false; // Stop initial loading
        _errorMessage = message;
      });

      // Navigate to PaymentFailed page
      context.pushNamed(
        'PaymentFailed', // Ensure you have a page named 'PaymentFailed' in FlutterFlow
        queryParameters: {
          'errorMessage': message,
          'merchantTransactionId': _merchantTransactionId ?? '',
          'enquiryId': widget.enquiryId,
        }.withoutNulls,
      );

      // Show snackbar for quick feedback (optional, as navigation will occur)
      _showSnackBar(message, isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context)
                .colorScheme
                .error // Fallback if FFTheme not directly accessible
            : Theme.of(context).colorScheme.primary, // Fallback
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _initiatePhonePePayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error
      _phonePeRedirectUrl = null;
      _merchantTransactionId = null;
      _paymentProcessed = false; // Reset for new attempt
    });

    _showSnackBar('Preparing PhonePe payment...', isError: false);

    const String platform = 'mobile'; // Fixed for this mobile widget
    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken ?? '';

    if (accessToken.isEmpty) {
      _updateErrorAndStopLoading(
          'Authentication required. Please log in to proceed with payment.');
      return;
    }

    try {
      print(
          '🚀 Initiating PhonePe payment for enquiry_id: ${widget.enquiryId} via backend...');

      final response = await http.post(
        Uri.parse(_phonePeBackendInitiateUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'platform': platform,
          'enquiryId': widget.enquiryId,
        }),
      );

      print('📡 Backend Initiate Response status: ${response.statusCode}');
      print('📡 Backend Initiate Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true &&
          data['redirectUrl'] != null &&
          data['merchantTransactionId'] != null) {
        // Check for 'merchantTransactionId' now
        print(
            '✅ PhonePe order created successfully. Redirect URL and Transaction ID received.');

        setState(() {
          _phonePeRedirectUrl = data['redirectUrl'];
          _merchantTransactionId =
              data['merchantTransactionId']; // <-- FIXED THIS LINE
          _isLoading =
              false; // Stop loading spinner, now ready to display WebView
        });

        // Start a timeout for the WebView load itself
        _loadingTimeoutTimer = Timer(const Duration(seconds: 45), () {
          print('⏰ WebView loading timed out for PhonePe.');
          if (mounted && !_paymentProcessed) {
            _updateErrorAndStopLoading(
                'Payment page timed out while loading. Please retry.');
          }
        });
      } else {
        final backendError =
            data['error'] ?? data['details'] ?? 'Unknown error from backend.';
        print('❌ PhonePe order creation failed: $backendError');
        _updateErrorAndStopLoading(
            'Payment initiation failed: ${response.statusCode} - $backendError');
      }
    } catch (e) {
      final generalErrorMessage =
          'A general error occurred during payment initiation: ${e.toString()}.';
      print('💥 GENERAL EXCEPTION: $generalErrorMessage');
      _updateErrorAndStopLoading(generalErrorMessage);
    }
  }

  Future<void> _verifyPhonePePaymentStatus() async {
    if (_paymentProcessed)
      return; // Prevent multiple verifications or navigations

    // Only set loading if not already in an error state from initial load
    if (_errorMessage == null) {
      setState(() {
        _isLoading = true; // Show loading for verification
      });
    }
    _showSnackBar(
        'Verifying PhonePe Transaction ID: $_merchantTransactionId...',
        isError: false);

    final session = Supabase.instance.client.auth.currentSession;
    final accessToken = session?.accessToken ?? '';

    if (accessToken.isEmpty) {
      _updateErrorAndStopLoading(
          'Authentication missing for payment verification. Please log in.');
      return;
    }

    if (_merchantTransactionId == null || _merchantTransactionId!.isEmpty) {
      _updateErrorAndStopLoading(
          'Missing transaction ID for verification. Cannot verify payment.');
      return;
    }

    try {
      print(
          '✨ Attempting to VERIFY PhonePe Transaction ID: $_merchantTransactionId');

      final verifyResponse = await http.post(
        Uri.parse(_phonePeBackendStatusCheckUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'merchantTransactionId': _merchantTransactionId,
        }),
      );

      print(
          '📡 Backend Status Check Response status: ${verifyResponse.statusCode}');
      print('📡 Backend Status Check Response body: ${verifyResponse.body}');

      if (verifyResponse.statusCode == 200) {
        final dynamic decodedBody = jsonDecode(verifyResponse.body);

        if (decodedBody is! Map<String, dynamic>) {
          _updateErrorAndStopLoading(
              'Verification response is not a valid JSON object. Raw body: ${verifyResponse.body}');
          return;
        }

        final Map<String, dynamic> verifyData = decodedBody;
        print('✅ PhonePe verification response: $verifyData');

        if (verifyData['success'] == true &&
            verifyData['paymentStatus'] == 'COMPLETED') {
          print('🎉 PhonePe Payment COMPLETED successfully!');
          if (mounted) {
            _paymentProcessed = true; // Set flag before navigating
            context.pushNamed('PaymentSuccessful'); // Navigate on final success
          }
        } else if (verifyData['paymentStatus'] == 'PENDING') {
          print(
              '⚠ PhonePe payment is PENDING. User needs to wait and check again.');
          if (mounted) {
            _paymentProcessed = true; // Set flag before navigating
            context.pushNamed('PaymentPending', queryParameters: {
              'status': 'Payment is still pending verification.',
              'merchantTransactionId': _merchantTransactionId ??
                  '', // Pass ID for potential future checks
            });
          }
        } else {
          final statusDetails = verifyData['paymentStatus'] ??
              verifyData['details'] ??
              'Unknown status from verification.';
          print('⚠ PhonePe payment was not successful. Status: $statusDetails');
          _updateErrorAndStopLoading(
              'Payment verification failed: $statusDetails');
        }
      } else {
        String errorDetails;
        try {
          final decodedErrorBody = jsonDecode(verifyResponse.body);
          errorDetails = decodedErrorBody['error'] ??
              decodedErrorBody['details'] ??
              'Unknown error in response body.';
        } catch (_) {
          errorDetails =
              'Could not parse error response. Raw body: ${verifyResponse.body}';
        }
        _updateErrorAndStopLoading(
            'Verification backend call failed: HTTP ${verifyResponse.statusCode} - $errorDetails');
      }
    } catch (e) {
      final exceptionMessage =
          'An unexpected exception occurred during payment verification: ${e.toString()}.';
      print('💥 EXCEPTION during verification: $exceptionMessage');
      _updateErrorAndStopLoading(exceptionMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If running on web, display a message that this widget is mobile-only
    if (kIsWeb) {
      // Ensure _errorMessage is set for web misuse case. This is a post-frame callback
      // to avoid calling setState during build, which can happen if directly in build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            (_errorMessage == null ||
                !_errorMessage!.contains("This widget is for mobile only"))) {
          _updateErrorAndStopLoading(
              'Error: This widget is for mobile only. Please use the web payment widget for web builds.');
        }
      });
      // Always show the error widget for web misuse, it will handle navigation
      return _buildErrorWidget();
    }

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
        child: _isLoading // Show loading indicator initially
            ? _buildLoadingWidget()
            : _errorMessage !=
                    null // If there's an error, display it locally for a moment before navigation
                ? _buildErrorWidget() // This will show briefly before navigation
                : (_phonePeRedirectUrl !=
                        null // If no error and URL is ready, show WebView
                    ? InAppWebView(
                        initialUrlRequest:
                            URLRequest(url: WebUri(_phonePeRedirectUrl!)),
                        onWebViewCreated: (controller) =>
                            _webViewController = controller,
                        onLoadStop: (controller, url) {
                          print('✅ PhonePe WebView loaded: $url');
                          _clearLoadingTimeout();
                          // Do not set _isLoading to false here if you expect
                          // _updateErrorAndStopLoading to handle all transitions.
                          // It's already handled by _updateErrorAndStopLoading when an error occurs.
                        },
                        onLoadError: (controller, url, code, message) {
                          print(
                              '⚠ PhonePe WebView Load Error: $code - $message');
                          // Directly handle error and navigate
                          _updateErrorAndStopLoading(
                              'WebView failed to load payment page: $message (Code: $code)');
                        },
                        // onReceivedHttpError can be useful for deeper debugging
                        onReceivedHttpError: (controller, request, response) {
                          print(
                              'HTTP Error in WebView: URL=${request.url}, Status=${response.statusCode}, Description=${response.reasonPhrase}');
                          // Only show error for critical HTTP errors (5xx server errors)
                          final statusCode = response.statusCode;
                          if (statusCode != null && statusCode >= 500) {
                            _updateErrorAndStopLoading(
                                'Server error when loading payment page: $statusCode');
                          }
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          final url = navigationAction.request.url.toString();
                          print('🔍 Intercepted PhonePe URL: $url');

                          // IMPORTANT: These URLs must match the redirect paths configured in your PhonePe dashboard
                          // and your Supabase backend environment variables (e.g., APP_DEEPLINK_SCHEME + APP_DEEPLINK_HOST + SUCCESS_REDIRECT_PATH)
                          if (url.contains('payment-success')) {
                            print('Intercepted success URL for PhonePe');
                            await _verifyPhonePePaymentStatus();
                            return NavigationActionPolicy
                                .CANCEL; // Prevent WebView from loading this final URL
                          } else if (url.contains('payment-cancel')) {
                            print('Intercepted cancel URL for PhonePe');
                            _updateErrorAndStopLoading(
                                'Payment cancelled by user or PhonePe.');
                            return NavigationActionPolicy
                                .CANCEL; // Prevent WebView from loading this final URL
                          } else if (url.contains('payment-failed')) {
                            print('Intercepted failed URL for PhonePe');
                            _updateErrorAndStopLoading(
                                'Payment failed during transaction.');
                            return NavigationActionPolicy.CANCEL;
                          }

                          return NavigationActionPolicy
                              .ALLOW; // Allow other URLs to load in the WebView
                        },
                        initialSettings: InAppWebViewSettings(
                          javaScriptEnabled: true,
                          useShouldOverrideUrlLoading: true,
                          clearCache: true,
                          domStorageEnabled: true,
                          supportZoom: false,
                        ),
                      )
                    : _buildLoadingWidget() // Fallback if _phonePeRedirectUrl is null but no error
                ),
      ),
    );
  }

  // The error widget is still here for cases where navigation might not happen immediately,
  // or for the brief moment before navigation takes over.
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              color: Theme.of(context).colorScheme.error, size: 64),
          const SizedBox(height: 24),
          Text(
            _errorMessage ??
                'An unknown error occurred.', // Display the actual error message
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Removed the retry button as all errors now navigate to PaymentFailed.
          // The retry option should be on the PaymentFailed page.
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            // Show _errorMessage if it's set and we are in a loading state
            (_isLoading && _errorMessage != null)
                ? _errorMessage!
                : 'Preparing PhonePe payment...',
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
