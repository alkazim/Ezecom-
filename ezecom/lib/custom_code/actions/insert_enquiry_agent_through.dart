// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> insertEnquiryAgentThrough(String productName, String quantity,
    String buyerEmail, String sellerName, String productid) async {
  try {
    print('Step 1: Starting insertEnquiryAgentThrough function');

    // Convert quantity from String to integer
    print('Step 2: Converting quantity to integer');
    final int quantityInt = int.tryParse(quantity) ?? 0;
    print('Converted quantity: $quantityInt');

    // First get buyer company name from Buyer_User table
    print('Step 3: Getting buyer company name');
    final buyerCompanyName = await _getBuyerCompanyName(buyerEmail);
    print('Retrieved buyer company name: $buyerCompanyName');

    // Prepare the data for the new enquiry
    print('Step 4: Preparing enquiry data');
    final enquiryData = {
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'Product_Name': productName,
      'Quantity': quantityInt,
      'Buyer_Name': buyerCompanyName,
      'Seller_Name': sellerName,
      'Product_id': productid,
      'Status': 'open',
    };
    print('Enquiry data prepared: $enquiryData');

    // Insert into Enquiry_Table_AgentThrough
    print('Step 5: Attempting to insert into Enquiry_Table_AgentThrough');
    final response = await SupaFlow.client
        .from('Enquiry_Table_AgentThrough')
        .insert(enquiryData)
        .select() // Add select() to get the inserted record back
        .single();
    print('Step 6: Insert operation completed');
    print('Insert response: $response');

    // If we get here, the insert was successful
    print('Step 7: Insert successful - returning true');
    return true;
  } catch (e, stackTrace) {
    print('ERROR CAUGHT in insertEnquiryAgentThrough');
    print('Error details: $e');
    print('Stack trace: $stackTrace');
    print('Returning false due to error');
    return false;
  }
}

Future<String> _getBuyerCompanyName(String email) async {
  try {
    print('_getBuyerCompanyName Step 1: Starting function');
    print('Looking up buyer with email: $email');

    print('_getBuyerCompanyName Step 2: Executing Supabase query');
    final response = await SupaFlow.client
        .from('Buyer_User')
        .select()
        .eq('Email', email.trim())
        .maybeSingle();
    print('_getBuyerCompanyName Step 3: Query completed');

    if (response == null) {
      print('_getBuyerCompanyName Step 4: No buyer found for email');
      print('Buyer not found for email: $email');
      return 'Unknown Buyer';
    }

    print('_getBuyerCompanyName Step 5: Extracting company name');
    final companyName = response['Company_Name']?.toString();
    print('Found buyer company: $companyName');

    print('_getBuyerCompanyName Step 6: Returning company name');
    return companyName ?? 'Unknown Buyer';
  } catch (e, stackTrace) {
    print('ERROR CAUGHT in _getBuyerCompanyName');
    print('Error details: $e');
    print('Stack trace: $stackTrace');
    print('Returning default "Unknown Buyer"');
    return 'Unknown Buyer';
  }
}
