// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:typed_data';

Future<String> uploadtosupabasebuyer(
  String companyLogoBase64,
  String companyCertificateBase64,
  String taxCertificateBase64,
  String tradeMarkRegistrationBase64,
  String importExportCertificateBase64,
) async {
  const String actionName = 'uploadtosupabasebuyer';
  print('[DEBUG] $actionName: Starting buyer files upload process');

  final supabase = Supabase.instance.client;
  const int maxSize = 10 * 1024 * 1024; // 10MB limit
  List<String> results = [];
  bool allUploadsSuccessful = true;

  // Define upload configurations with correct variable mapping
  final uploadConfigs = [
    {
      'data': companyLogoBase64,
      'bucket': 'BuyerPDF',
      'prefix': 'company_logo',
      'contentType': 'application/pdf',
      'appStateVar': 'CompanyLogoorTradeMarkPDF',
    },
    {
      'data': companyCertificateBase64,
      'bucket': 'BuyerPDF',
      'prefix': 'company_cert',
      'contentType': 'application/pdf',
      'appStateVar': 'CompanyCertificatePDF',
    },
    {
      'data': taxCertificateBase64,
      'bucket': 'BuyerPDF',
      'prefix': 'tax_cert',
      'contentType': 'application/pdf',
      'appStateVar': 'TaxCertificatePDF',
    },
    {
      'data': tradeMarkRegistrationBase64,
      'bucket': 'BuyerPDF',
      'prefix': 'trademark_reg',
      'contentType': 'application/pdf',
      'appStateVar': 'TradeMarkRegistrationCertificatesorLogoImagePDF',
    },
    {
      'data': importExportCertificateBase64,
      'bucket': 'BuyerPDF',
      'prefix': 'import_export_cert',
      'contentType': 'application/pdf',
      'appStateVar': 'ImportExportCertificatenumberPDF',
    },
  ];

  print('[DEBUG] $actionName: Processing ${uploadConfigs.length} buyer files');

  // Process each file
  for (int i = 0; i < uploadConfigs.length; i++) {
    final config = uploadConfigs[i];

    try {
      print(
          '[DEBUG] $actionName: Processing ${config['appStateVar']} (${config['prefix']})');

      if (config['data'].toString().isEmpty) {
        print(
            '[ERROR] $actionName: Empty data for ${config['prefix']} (${config['appStateVar']})');
        results.add('Failed');
        allUploadsSuccessful = false;
        continue;
      }

      // Clean base64 string
      final String cleanBase64 = config['data'].toString().contains(',')
          ? config['data'].toString().split(',').last
          : config['data'].toString();

      // Convert to bytes
      Uint8List fileBytes;
      try {
        fileBytes = base64Decode(cleanBase64);
        print(
            '[INFO] $actionName: ${config['prefix']} decoded, size: ${fileBytes.length} bytes');
      } catch (e) {
        print(
            '[ERROR] $actionName: Base64 decode failed for ${config['prefix']} (${config['appStateVar']}) - ${e.toString()}');
        results.add('Failed');
        allUploadsSuccessful = false;
        continue;
      }

      // Validate file size
      if (fileBytes.length > maxSize) {
        print(
            '[ERROR] $actionName: File too large for ${config['prefix']} (${config['appStateVar']}) - ${fileBytes.length} bytes');
        results.add('Failed');
        allUploadsSuccessful = false;
        continue;
      }

      // Skip files that are too small (likely empty/invalid)
      if (fileBytes.length < 10) {
        print(
            '[WARNING] $actionName: File too small for ${config['prefix']} (${config['appStateVar']}) - ${fileBytes.length} bytes, skipping');
        results.add('Skipped');
        continue;
      }

      // Generate unique filename
      final String fileName =
          '${config['prefix']}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      print(
          '[INFO] $actionName: Generated filename: $fileName for ${config['appStateVar']}');

      // Perform upload
      try {
        print(
            '[INFO] $actionName: Uploading ${config['prefix']} (${config['appStateVar']}) to ${config['bucket']}');

        await supabase.storage.from(config['bucket'].toString()).uploadBinary(
              fileName,
              fileBytes,
              fileOptions: FileOptions(
                contentType: config['contentType'].toString(),
                upsert: true,
              ),
            );

        print(
            '[SUCCESS] $actionName: Upload completed for ${config['prefix']} (${config['appStateVar']})');

        // Get public URL
        final String publicUrl = supabase.storage
            .from(config['bucket'].toString())
            .getPublicUrl(fileName);

        print(
            '[SUCCESS] $actionName: Public URL generated for ${config['appStateVar']}: $publicUrl');

        // Update app state variable
        try {
          FFAppState().update(() {
            switch (config['appStateVar']) {
              case 'CompanyLogoorTradeMarkPDF':
                FFAppState().CompanyLogoorTradeMarkPDF = publicUrl;
                break;
              case 'CompanyCertificatePDF':
                FFAppState().CompanyCertificatePDF = publicUrl;
                break;
              case 'TaxCertificatePDF':
                FFAppState().TaxCertificatePDF = publicUrl;
                break;
              case 'TradeMarkRegistrationCertificatesorLogoImagePDF':
                FFAppState().TradeMarkRegistrationCertificatesorLogoImagePDF =
                    publicUrl;
                break;
              case 'ImportExportCertificatenumberPDF':
                FFAppState().ImportExportCertificatenumberPDF = publicUrl;
                break;
              default:
                print(
                    '[WARNING] $actionName: Unknown app state variable: ${config['appStateVar']}');
            }
          });
          print(
              '[SUCCESS] $actionName: App state updated for ${config['appStateVar']}');
        } catch (e) {
          print(
              '[ERROR] $actionName: Failed to update app state for ${config['appStateVar']}: ${e.toString()}');
          allUploadsSuccessful = false;
        }

        results.add(publicUrl);
      } catch (e) {
        print(
            '[ERROR] $actionName: Upload failed for ${config['prefix']} (${config['appStateVar']}) - ${e.toString()}');
        results.add('Failed');
        allUploadsSuccessful = false;
      }
    } catch (e) {
      print(
          '[ERROR] $actionName: Unexpected error for ${config['prefix']} (${config['appStateVar']}) - ${e.toString()}');
      results.add('Failed');
      allUploadsSuccessful = false;
    }
  }

  // Final result and debug output
  if (allUploadsSuccessful) {
    print('[DEBUG] $actionName: Final app state values:');
    print(
        'CompanyLogoorTradeMarkPDF: ${FFAppState().CompanyLogoorTradeMarkPDF}');
    print('CompanyCertificatePDF: ${FFAppState().CompanyCertificatePDF}');
    print('TaxCertificatePDF: ${FFAppState().TaxCertificatePDF}');
    print(
        'TradeMarkRegistrationCertificatesorLogoImagePDF: ${FFAppState().TradeMarkRegistrationCertificatesorLogoImagePDF}');
    print(
        'ImportExportCertificatenumberPDF: ${FFAppState().ImportExportCertificatenumberPDF}');

    print('[SUCCESS] $actionName: All buyer uploads completed successfully');
    return 'Success';
  } else {
    print('[ERROR] $actionName: Some buyer uploads failed');
    return 'Failed';
  }
}
