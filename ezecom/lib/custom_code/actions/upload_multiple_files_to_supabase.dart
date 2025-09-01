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

Future<String> uploadMultipleFilesToSupabase(
  String companyRegCertBase64,
  String taxRegCertBase64,
  String ownerIDCardBase64,
  String factoryImageBase64,
  String importExportCertBase64,
  String logoRegistrationCertBase64, // Updated name
  String trademarkImageBase64,
) async {
  const String actionName = 'uploadMultipleFilesToSupabase';
  print('[DEBUG] $actionName: Starting multiple files upload process');

  final supabase = Supabase.instance.client;
  const int maxSize = 10 * 1024 * 1024; // 10MB limit
  List<String> results = [];
  bool allUploadsSuccessful = true;

  // Define upload configurations with correct variable mapping
  final uploadConfigs = [
    {
      'data': companyRegCertBase64,
      'bucket': 'SellerPDF',
      'prefix': 'company_reg',
      'contentType': 'application/pdf',
      'appStateVar': 'CompanyRegistrationCertificatePDF',
    },
    {
      'data': taxRegCertBase64,
      'bucket': 'SellerPDF',
      'prefix': 'tax_reg',
      'contentType': 'application/pdf',
      'appStateVar': 'TaxRegistrationCertificatePDF',
    },
    {
      'data': ownerIDCardBase64,
      'bucket': 'SellerPDF',
      'prefix': 'owner_id',
      'contentType': 'application/pdf',
      'appStateVar': 'OwnerDirectorIDCardPDF',
    },
    {
      'data': factoryImageBase64,
      'bucket': 'SellerPDF',
      'prefix': 'factory',
      'contentType': 'image/jpeg',
      'appStateVar': 'FactoryCompanyimage',
    },
    {
      'data': importExportCertBase64,
      'bucket': 'SellerPDF',
      'prefix': 'import_export',
      'contentType': 'application/pdf',
      'appStateVar': 'ImportExportCertificatePDF',
    },
    {
      'data': logoRegistrationCertBase64, // Updated name
      'bucket': 'SellerPDF',
      'prefix': 'logo_registration',
      'contentType': 'application/pdf',
      'appStateVar': 'LogoRegistrationCertificatePDF',
    },
    {
      'data': trademarkImageBase64,
      'bucket': 'SellerPDF',
      'prefix': 'trademark',
      'contentType': 'image/jpeg',
      'appStateVar': 'TrademarkorLogoImage',
    },
  ];

  print('[DEBUG] $actionName: Processing ${uploadConfigs.length} files');

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
          '${config['prefix']}_${DateTime.now().millisecondsSinceEpoch}${config['contentType'] == 'application/pdf' ? '.pdf' : '.jpg'}';
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
              case 'CompanyRegistrationCertificatePDF':
                FFAppState().CompanyRegistrationCertificatePDF = publicUrl;
                break;
              case 'TaxRegistrationCertificatePDF':
                FFAppState().TaxRegistrationCertificatePDF = publicUrl;
                break;
              case 'OwnerDirectorIDCardPDF':
                FFAppState().OwnerDirectorIDCardPDF = publicUrl;
                break;
              case 'FactoryCompanyimage':
                FFAppState().FactoryCompanyimage = publicUrl;
                break;
              case 'ImportExportCertificatePDF':
                FFAppState().ImportExportCertificatePDF = publicUrl;
                break;
              case 'LogoRegistrationCertificatePDF':
                FFAppState().LogoRegistrationCertificatePDF = publicUrl;
                break;
              case 'TrademarkorLogoImage':
                FFAppState().TrademarkorLogoImage = publicUrl;
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

  // Final result
  if (allUploadsSuccessful) {
    print(
        'CompanyRegistrationCertificatePDF: ${FFAppState().CompanyRegistrationCertificatePDF}');
    print(
        'TaxRegistrationCertificatePDF: ${FFAppState().TaxRegistrationCertificatePDF}');
    print('OwnerDirectorIDCardPDF: ${FFAppState().OwnerDirectorIDCardPDF}');
    print('FactoryCompanyimage: ${FFAppState().FactoryCompanyimage}');
    print(
        'ImportExportCertificatePDF: ${FFAppState().ImportExportCertificatePDF}');
    print(
        'LogoRegistrationCertificatePDF: ${FFAppState().LogoRegistrationCertificatePDF}');
    print('TrademarkorLogoImage: ${FFAppState().TrademarkorLogoImage}');

    print('[SUCCESS] $actionName: All uploads completed successfully');
    return 'Success';
  } else {
    print('[ERROR] $actionName: Some uploads failed');
    return 'Failed';
  }
}
