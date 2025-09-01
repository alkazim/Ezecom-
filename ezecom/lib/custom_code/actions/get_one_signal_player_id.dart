// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/supabase/supabase.dart'; // Ensure this import is present for Supabase

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:supabase_flutter/supabase_flutter.dart'; // Explicitly import supabase_flutter

/// Action Name: getOneSignalPlayerId
///
/// Arguments: - emailId (String): The email address to match in the
/// client_table.
///
/// This will be used to find the correct row to update.
Future<String?> getOneSignalPlayerId(String emailId) async {
  debugPrint('--- Custom Action: getOneSignalPlayerId ---');
  debugPrint('Action called with emailId: $emailId');

  if (emailId.isEmpty) {
    debugPrint('Error: emailId is empty. Cannot save Player ID to Supabase.');
    return null;
  }

  try {
    debugPrint('Step 1: Waiting for 100ms to ensure OneSignal initialization.');
    await Future.delayed(Duration(milliseconds: 100));

    debugPrint('Step 2: Attempting to retrieve OneSignal Player ID.');
    String? playerId = OneSignal.User.pushSubscription.id;
    debugPrint('Step 3: Initial Player ID retrieved: $playerId');

    if (playerId != null && playerId.isNotEmpty) {
      debugPrint('Step 4: Player ID found on first attempt: $playerId');
    } else {
      debugPrint(
          'Step 5: Player ID not found on first attempt or was empty. Waiting another 500ms and retrying.');
      await Future.delayed(Duration(milliseconds: 500));
      playerId = OneSignal.User.pushSubscription.id;
      debugPrint('Step 6: Player ID after second attempt: $playerId');
    }

    if (playerId != null && playerId.isNotEmpty) {
      debugPrint('Step 7: Player ID successfully obtained: $playerId');

      // --- Supabase Update Logic ---
      debugPrint('Step 8: Attempting to update Supabase table "client_table".');
      try {
        final response = await Supabase.instance.client
            .from('client_table')
            .update({
              'OneSignal_PlayerID': playerId, // The field to update
            })
            // IMPORTANT CHANGE HERE: Matching by 'email_column_name' instead of 'user_id'
            .eq('Email',
                emailId) // ** Replace 'email_column_name_in_client_table' with your actual email column name **
            .select(); // Use .select() to get the updated row back (optional, but good for debugging)

        debugPrint(
            'Supabase Update Response: $response'); // Log the entire response

        if (response.isEmpty) {
          debugPrint(
              'Supabase Update Warning: No row found or updated for email: $emailId. Check email column name and RLS.');
        } else {
          debugPrint(
              'Step 9: Successfully updated OneSignal_PlayerID in client_table for email: $emailId');
        }
      } catch (supabaseError) {
        debugPrint(
            'Supabase Update Error in getOneSignalPlayerId action: $supabaseError');
        // You might want to handle this error more specifically, e.g., show a snackbar
      }
      // --- End Supabase Update Logic ---

      return playerId;
    } else {
      debugPrint(
          'Step 10: Player ID still not found after multiple attempts. Cannot save to Supabase.');
      return null;
    }
  } catch (e) {
    // Handle any errors during OneSignal retrieval
    debugPrint(
        'Error getting OneSignal Player ID in getOneSignalPlayerId action: $e');
    return null;
  } finally {
    debugPrint('--- Custom Action: getOneSignalPlayerId Finished ---');
  }
}
