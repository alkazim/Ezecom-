// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future<String> registerUserWithApproval(
  String email,
  String password,
) async {
  try {
    // ===== 1. VALIDATION =====
    print('DEBUG: Started action');
    print('DEBUG: Email received: $email');
    print('DEBUG: Password length: ${password.length}');

    if (email.isEmpty || password.isEmpty) {
      print('DEBUG: Validation failed - empty email or password');
      return 'Email and password are required';
    }

    print('DEBUG: Basic validation passed');

    if (password.length < 8) {
      print('DEBUG: Password too short');
      return 'Password must be at least 8 characters';
    }

    print('DEBUG: Password length validation passed');

    // ===== 2. HASH PASSWORD AND RETURN =====
    // SHA-256 hashing (one-way encryption)
    print('DEBUG: About to hash password');
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();
    print('DEBUG: Password hashed successfully');
    print('DEBUG: Hashed password: $hashedPassword');

    print('DEBUG: Returning hashed password without database insertion');
    return hashedPassword;
  } catch (e) {
    print('DEBUG: ERROR CAUGHT in registerUserWithApproval');
    print('DEBUG: Error type: ${e.runtimeType}');
    print('DEBUG: Error message: ${e.toString()}');
    print('DEBUG: Full error: $e');
    return 'Error: ${e.toString().replaceAll('Exception: ', '')}';
  }
}
