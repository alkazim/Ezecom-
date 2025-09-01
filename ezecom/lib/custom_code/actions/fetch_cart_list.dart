// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Function to get the cart product IDs for a user
import 'package:supabase/supabase.dart';

Future<dynamic> fetchCartList(String email) async {
  // Initialize Supabase client with your credentials
  final supabase = SupabaseClient(
    'https://gticwwxjzuftuvilszmq.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd0aWN3d3hqenVmdHV2aWxzem1xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5ODk4MjYsImV4cCI6MjA1NjU2NTgyNn0.HpSlkpTlelnWRgCXsEwx5y7HELa8t7eY4BrcFJH7img',
  );

  try {
    print('🔵 Starting CartList fetch for: $email');

    final user = Supabase.instance.client.auth.currentUser;

    // Check if user exists and has an ID
    if (user?.id == null) {
      print('⚠️ No authenticated user found');
      return null;
    }

    final response = await Supabase.instance.client
        .from('client_table')
        .select('CartList')
        .eq('Auth_ID', user!.id) // Use ! to assert non-null after null check
        .maybeSingle();

    print('🟢 Supabase response:');
    print(response);

    // Check if response is not null before accessing properties
    if (response != null && response['CartList'] != null) {
      print('🛒 CartList content:');
      print(response['CartList']);
      return response['CartList'];
    } else {
      print('⚠️ CartList is null for this user');
      return null;
    }
  } on PostgrestException catch (e) {
    print('🔴 Supabase Error:');
    print('Code: ${e.code}');
    print('Message: ${e.message}');
    print('Details: ${e.details}');
    print('Hint: ${e.hint}');
    throw Exception('Database error: ${e.message}');
  } catch (e) {
    print('🔴 Unexpected Error:');
    print(e);
    throw Exception('Failed to fetch CartList: $e');
  } finally {
    print('🏁 Fetch operation completed');
  }
}
