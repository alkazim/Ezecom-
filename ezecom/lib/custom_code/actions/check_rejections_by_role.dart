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

Future<bool> checkRejectionsByRole(String role) async {
  final supabase = Supabase.instance.client;
  final authId = supabase.auth.currentUser?.id;

  if (authId == null) {
    print("Auth ID not found");
    return false;
  }

  try {
    // Pick table name based on role
    final tableName =
        role.toLowerCase() == "seller" ? "Seller_User" : "Buyer_User";

    // Fetch the record
    final response =
        await supabase.from(tableName).select().eq("Auth_ID", authId).single();

    if (response != null) {
      if (role.toLowerCase() == "buyer") {
        // Buyer mappings
        if (response["Company_Logo_or_Trade_Mark"] == "rejected") {
          FFAppState().CompanyLogoorTradeMark = true;
        }
        if (response["Company_Certificate"] == "rejected") {
          FFAppState().CompanyCertificate = true;
        }
        if (response["Tax_Certificate"] == "rejected") {
          FFAppState().TaxCertificate = true;
        }
        if (response["Trade_Mark_Registration_Certificates_or_Logo_Image"] ==
            "rejected") {
          FFAppState().TradeMarkRegistrationCertificatesorLogoImage = true;
        }
        if (response["Import_Export_Certificate_number"] == "rejected") {
          FFAppState().ImportExportCertificatenumber = true;
        }
      } else if (role.toLowerCase() == "seller") {
        // Seller mappings
        if (response["Company_Registration_Certificate"] == "rejected") {
          FFAppState().CompanyRegistrationCertificate = true;
        }
        if (response["Tax_Registration_Certificate"] == "rejected") {
          FFAppState().TaxRegistrationCertificate = true;
        }
        if (response["Owner_Director_ID_Card"] == "rejected") {
          FFAppState().OwnerDirectorIDCard = true;
        }
        if (response["Factory_Company_images"] == "rejected") {
          FFAppState().FactoryCompanyimages = true;
        }
        if (response["Import_Export_Certificates"] == "rejected") {
          FFAppState().ImportExportCertificates = true;
        }
        if (response["Logo_Registration_Certificate"] == "rejected") {
          FFAppState().LogoRegistrationCertificate = true;
        }
        if (response["Trademark_or_Logo_Images"] == "rejected") {
          FFAppState().TrademarkorLogoImages = true;
        }
      }
    }

    return true;
  } catch (e) {
    print("Error: $e");
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
