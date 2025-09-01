// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart';

// STEP 4: Add this as Custom Action in FlutterFlow
// Action Name: testPayPalPayment

import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

Future<String> testPayPalPayment(
  BuildContext context,
  double testAmount,
  String testProductName,
) async {
  // Check if running on web platform
  if (kIsWeb) {
    print("❌ PayPal payment is not supported on web platform");

    // Show web not supported dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Not Supported'),
        content: Text(
            'PayPal payment is only available on mobile devices. Please use the mobile app to complete your payment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );

    return "PayPal payment not supported on web platform";
  }

  // HARDCODED FOR TESTING - Replace with your actual credentials
  String clientId = FFAppState().clientID;
  String secretKey = FFAppState().secretKey;
  bool sandboxMode = FFAppState().sandboxMode;

  // Log the start
  print("🚀 Starting PayPal Test Payment");
  print("Amount: $testAmount");
  print("Product: $testProductName");

  try {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: sandboxMode,
          clientId: clientId,
          secretKey: secretKey,
          transactions: [
            {
              "amount": {
                "total": testAmount.toStringAsFixed(2),
                "currency": "USD",
                "details": {
                  "subtotal": testAmount.toStringAsFixed(2),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "Test purchase of $testProductName",
              "item_list": {
                "items": [
                  {
                    "name": testProductName,
                    "quantity": 1,
                    "price": testAmount.toStringAsFixed(2),
                    "currency": "USD"
                  }
                ],
              }
            }
          ],
          note: "This is a test payment - FlutterFlow Testing",
          onSuccess: (Map params) async {
            print("✅ PayPal Payment SUCCESS!");
            print("Payment ID: ${params['paymentId']}");
            print("Payer ID: ${params['payerID']}");
            print("Full params: $params");

            // Close PayPal screen first
            Navigator.pop(context);

            // Simple navigation to test2 page - no parameters
            try {
              print("🔍 Attempting to navigate to test2 page...");
              context.pushNamed('test2');
              print("✅ Navigation to test2 successful!");
            } catch (navError) {
              print("❌ pushNamed failed: $navError");

              // Try alternative method
              try {
                print("🔍 Trying goNamed...");
                context.goNamed('test2');
                print("✅ goNamed to test2 successful!");
              } catch (e2) {
                print("❌ goNamed also failed: $e2");

                // Last resort - show dialog to confirm payment worked
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Payment Success!'),
                    content: Text(
                        'Payment completed but navigation failed. Please check FlutterFlow page name.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            }
          },

          // Alternative navigation methods you can try if the above doesn't work:
          // context.goNamed('test2');  // Replaces current page
          // context.pushNamedAndClearStack('test2');  // Clears navigation stack

          onError: (error) {
            print("❌ PayPal Payment ERROR!");
            print("Error: $error");

            Navigator.pop(context);

            // Show error dialog instead of trying to navigate
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Payment Error',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    SizedBox(height: 10),
                    Text('Sorry, there was an issue processing your payment.'),
                    SizedBox(height: 10),
                    Text('Error: $error',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child:
                        Text('Try Again', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onCancel: () {
            print("⚠️ PayPal Payment CANCELLED");

            Navigator.pop(context);

            // Show snackbar for cancellation
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                children: [
                  Icon(Icons.cancel, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Payment was cancelled'),
                ],
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ));

            print("✅ Showed cancellation message");
          },
        ),
      ),
    );
    print("PayPal UI opened successfully");
    return "PayPal UI opened successfully";
  } catch (e) {
    print("Error occured ...................");
    print("❌ CRITICAL ERROR: $e");

    // Show error dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Critical Error'),
        content: Text('Failed to open PayPal: $e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );

    return "Error: $e";
  }
}
