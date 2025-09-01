// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> checkUserApprovalAndDocuments(
  String role,
) async {
  try {
    final supabase = SupaFlow.client;

    // Get current user's auth ID
    final user = supabase.auth.currentUser;
    if (user == null) {
      return false;
    }

    final String authId = user.id;

    // Check client_table for approval status
    final clientResponse = await supabase
        .from('client_table')
        .select('Account_Approval')
        .eq('Auth_ID', authId)
        .single();

    if (clientResponse == null ||
        clientResponse['Account_Approval'] != 'rejected') {
      return false;
    }

    // Check documents based on role
    if (role.toLowerCase() == 'buyer') {
      return await _checkBuyerDocuments(supabase, authId);
    } else if (role.toLowerCase() == 'seller') {
      return await _checkSellerDocuments(supabase, authId);
    }

    return false;
  } catch (e) {
    print('Error in checkUserApprovalAndDocuments: $e');
    return false;
  }
}

Future<bool> _checkBuyerDocuments(dynamic supabase, String authId) async {
  try {
    final buyerResponse = await supabase.from('Buyer_User').select('''
          Company_Logo_or_Trade_Mark,
          Company_Certificate,
          Tax_Certificate,
          Trade_Mark_Registration_Certificates_or_Logo_Image,
          Import_Export_Certificate_number
        ''').eq('Auth_ID', authId).single();

    if (buyerResponse == null) {
      return false;
    }

    // List of required document fields for buyer
    final List<String> requiredFields = [
      'Company_Logo_or_Trade_Mark',
      'Company_Certificate',
      'Tax_Certificate',
      'Trade_Mark_Registration_Certificates_or_Logo_Image',
      'Import_Export_Certificate_number'
    ];

    // Check each required field
    for (String field in requiredFields) {
      final value = buyerResponse[field];

      // Check if field is null, empty, or contains "rejected"
      if (value == null ||
          value.toString().isEmpty ||
          value.toString().toLowerCase().contains('rejected')) {
        return false;
      }

      // Check if it's a valid Supabase storage URL
      if (!_isValidSupabaseStorageUrl(value.toString())) {
        return false;
      }
    }

    return true;
  } catch (e) {
    print('Error checking buyer documents: $e');
    return false;
  }
}

Future<bool> _checkSellerDocuments(dynamic supabase, String authId) async {
  try {
    final sellerResponse = await supabase.from('Seller_User').select('''
          Company_Registration_Certificate,
          Tax_Registration_Certificate,
          Owner/Director_ID_Card,
          Factory/Company_image,
          Import_Export_Certificate,
          Logo_Registration_Certificate,
          Trademark_or_Logo_Image
        ''').eq('Auth_ID', authId).single();

    if (sellerResponse == null) {
      return false;
    }

    // List of required document fields for seller
    final List<String> requiredFields = [
      'Company_Registration_Certificate',
      'Tax_Registration_Certificate',
      'Owner/Director_ID_Card',
      'Factory/Company_image',
      'Import_Export_Certificate',
      'Logo_Registration_Certificate',
      'Trademark_or_Logo_Image'
    ];

    // Check each required field
    for (String field in requiredFields) {
      final value = sellerResponse[field];

      // Check if field is null, empty, or contains "rejected"
      if (value == null ||
          value.toString().isEmpty ||
          value.toString().toLowerCase().contains('rejected')) {
        return false;
      }

      // Check if it's a valid Supabase storage URL
      if (!_isValidSupabaseStorageUrl(value.toString())) {
        return false;
      }
    }

    return true;
  } catch (e) {
    print('Error checking seller documents: $e');
    return false;
  }
}

bool _isValidSupabaseStorageUrl(String url) {
  // Check if URL is valid and contains typical Supabase storage patterns
  if (url.isEmpty) return false;

  // Basic URL validation and Supabase storage URL patterns
  final supabaseStoragePatterns = [
    'supabase.co/storage',
    'supabase.in/storage',
    '/storage/v1/object/public/',
    '/storage/v1/object/sign/'
  ];

  return supabaseStoragePatterns.any((pattern) => url.contains(pattern)) &&
      (url.startsWith('http://') || url.startsWith('https://'));
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
