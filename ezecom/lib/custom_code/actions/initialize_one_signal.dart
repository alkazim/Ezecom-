// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart';
//import '/flutter_flow/custom_functions.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

Future initializeOneSignal() async {
  try {
    print('🚀 Initializing OneSignal...');

    // Initialize OneSignal
    OneSignal.initialize("fd96d9ea-97f0-4624-a8a0-a67cb5315be3");

    // Wait for initialization
    await Future.delayed(Duration(milliseconds: 500));

    // Request notification permission
    bool permission = await OneSignal.Notifications.requestPermission(true);
    print('📱 Notification permission: $permission');

    // Handle foreground notifications
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('🔔 Foreground notification: ${event.notification.title}');
      event.notification.display();
    });

    // Handle notification clicks
    OneSignal.Notifications.addClickListener((event) {
      print('👆 Notification clicked: ${event.notification.title}');

      // Handle different notification types
      if (event.notification.additionalData != null) {
        Map<String, dynamic> data = event.notification.additionalData!;

        // Navigate based on notification type
        if (data.containsKey('type')) {
          switch (data['type']) {
            case 'account_approved':
              print('Navigate to profile/dashboard');
              // Add navigation logic here
              break;
            case 'product_approved':
              print('Navigate to products page');
              // Add navigation logic here
              break;
            case 'banner_approved':
              print('Navigate to banners page');
              // Add navigation logic here
              break;
          }
        }
      }
    });

    // Get OneSignal player ID
    OneSignal.User.addObserver((state) {
      if (state.current.onesignalId != null) {
        print('✅ OneSignal Player ID: ${state.current.onesignalId}');
      }
    });

    print('✅ OneSignal initialized successfully');
  } catch (e) {
    print('❌ OneSignal error: $e');
  }
}
