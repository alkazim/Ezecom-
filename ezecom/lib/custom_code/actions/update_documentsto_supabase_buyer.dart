// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Fixed version for FlutterFlow Custom Action
import 'dart:convert';
import 'dart:typed_data';

Future<bool> updateDocumentstoSupabaseBuyer() async {
  try {
    // Get current authenticated user ID
    final user = SupaFlow.client.auth.currentUser;
    if (user == null) {
      print('No authenticated user found');
      return false;
    }

    final String authUserId = user.id;
    print('Authenticated user ID: $authUserId');

    // Document mapping for Buyer_User table
    final Map<String, Map<String, String>> buyerDocumentMapping = {
      'CompanyLogoorTradeMark': {
        'pdfVar': 'CompanyLogoorTradeMarkPDF',
        'storagePath': 'buyer-documents/company-logos',
        'tableColumn': 'Company_Logo_or_Trade_Mark'
      },
      'CompanyCertificate': {
        'pdfVar': 'CompanyCertificatePDF',
        'storagePath': 'buyer-documents/company-certificates',
        'tableColumn': 'Company_Certificate'
      },
      'TaxCertificate': {
        'pdfVar': 'TaxCertificatePDF',
        'storagePath': 'buyer-documents/tax-certificates',
        'tableColumn': 'Tax_Certificate'
      },
      'TradeMarkRegistrationCertificatesorLogoImage': {
        'pdfVar': 'TradeMarkRegistrationCertificatesorLogoImagePDF',
        'storagePath': 'buyer-documents/trademark-certificates',
        'tableColumn': 'Trade_Mark_Registration_Certificates_or_Logo_Image'
      },
      'ImportExportCertificatenumber': {
        'pdfVar': 'ImportExportCertificatenumberPDF',
        'storagePath': 'buyer-documents/import-export-certificates',
        'tableColumn': 'Import_Export_Certificate_number'
      },
    };

    final Map<String, String> uploadedUrls = {};
    final List<String> uploadedDocuments = [];

    print('Starting buyer document upload process...');

    // Process each document type
    for (final String booleanVar in buyerDocumentMapping.keys) {
      bool shouldUpload = false;

      // Get boolean value from app state
      switch (booleanVar) {
        case 'CompanyLogoorTradeMark':
          shouldUpload = FFAppState().CompanyLogoorTradeMark;
          break;
        case 'CompanyCertificate':
          shouldUpload = FFAppState().CompanyCertificate;
          break;
        case 'TaxCertificate':
          shouldUpload = FFAppState().TaxCertificate;
          break;
        case 'TradeMarkRegistrationCertificatesorLogoImage':
          shouldUpload =
              FFAppState().TradeMarkRegistrationCertificatesorLogoImage;
          break;
        case 'ImportExportCertificatenumber':
          shouldUpload = FFAppState().ImportExportCertificatenumber;
          break;
        default:
          shouldUpload = false;
      }

      print('Checking buyer document $booleanVar: $shouldUpload');

      if (shouldUpload) {
        final String pdfVarName = buyerDocumentMapping[booleanVar]!['pdfVar']!;
        final String storagePath =
            buyerDocumentMapping[booleanVar]!['storagePath']!;
        final String tableColumn =
            buyerDocumentMapping[booleanVar]!['tableColumn']!;

        // Get PDF base64 value from app state
        String? pdfBase64Value;
        switch (pdfVarName) {
          case 'CompanyLogoorTradeMarkPDF':
            pdfBase64Value = FFAppState().CompanyLogoorTradeMarkPDF;
            break;
          case 'CompanyCertificatePDF':
            pdfBase64Value = FFAppState().CompanyCertificatePDF;
            break;
          case 'TaxCertificatePDF':
            pdfBase64Value = FFAppState().TaxCertificatePDF;
            break;
          case 'TradeMarkRegistrationCertificatesorLogoImagePDF':
            pdfBase64Value =
                FFAppState().TradeMarkRegistrationCertificatesorLogoImagePDF;
            break;
          case 'ImportExportCertificatenumberPDF':
            pdfBase64Value = FFAppState().ImportExportCertificatenumberPDF;
            break;
          default:
            pdfBase64Value = null;
        }

        if (pdfBase64Value != null && pdfBase64Value.isNotEmpty) {
          try {
            print('Uploading buyer document $booleanVar...');

            // Clean base64 string if it has data URL prefix
            String cleanBase64 = pdfBase64Value;
            if (pdfBase64Value.contains(',')) {
              cleanBase64 = pdfBase64Value.split(',')[1];
            }

            // Convert base64 to bytes
            final List<int> bytes = base64.decode(cleanBase64);

            // Generate unique filename with timestamp and auth ID
            final String timestamp =
                DateTime.now().millisecondsSinceEpoch.toString();
            final String fileName =
                'buyer_${authUserId}_${timestamp}_${booleanVar.toLowerCase()}.pdf';

            // Upload to Supabase storage using BuyerPDF bucket
            final response =
                await SupaFlow.client.storage.from('BuyerPDF').uploadBinary(
                      '$storagePath/$fileName',
                      Uint8List.fromList(bytes),
                      fileOptions: const FileOptions(
                        contentType: 'application/pdf',
                        upsert: true,
                      ),
                    );

            if (response.isEmpty) {
              throw Exception(
                  'Upload failed for buyer document $booleanVar - empty response');
            }

            // Get public URL from BuyerPDF bucket
            final String publicUrl = SupaFlow.client.storage
                .from('BuyerPDF')
                .getPublicUrl('$storagePath/$fileName');

            uploadedUrls[tableColumn] = publicUrl;
            uploadedDocuments.add(booleanVar);

            print(
                'Successfully uploaded buyer document $booleanVar: $publicUrl');
          } catch (uploadError) {
            print('Error uploading buyer document $booleanVar: $uploadError');
            continue;
          }
        } else {
          print('No base64 data found for buyer document $booleanVar');
        }
      }
    }

    // Update database if any files were uploaded
    if (uploadedUrls.isNotEmpty) {
      try {
        print(
            'Updating Buyer_User table with ${uploadedUrls.length} URLs for user: $authUserId');
        print('Fields to update: ${uploadedUrls.keys.toList()}');

        // Update only the specific columns that have new URLs
        await SupaFlow.client
            .from('Buyer_User')
            .update(uploadedUrls)
            .eq('Auth_ID', authUserId);

        print(
            'Successfully updated Buyer_User table with ${uploadedUrls.length} document URLs');

        // Reset boolean flags and clear PDF data for successfully uploaded documents
        for (final String docName in uploadedDocuments) {
          switch (docName) {
            case 'CompanyLogoorTradeMark':
              FFAppState().update(() {
                FFAppState().CompanyLogoorTradeMark = false;
                FFAppState().CompanyLogoorTradeMarkPDF = '';
              });
              break;
            case 'CompanyCertificate':
              FFAppState().update(() {
                FFAppState().CompanyCertificate = false;
                FFAppState().CompanyCertificatePDF = '';
              });
              break;
            case 'TaxCertificate':
              FFAppState().update(() {
                FFAppState().TaxCertificate = false;
                FFAppState().TaxCertificatePDF = '';
              });
              break;
            case 'TradeMarkRegistrationCertificatesorLogoImage':
              FFAppState().update(() {
                FFAppState().TradeMarkRegistrationCertificatesorLogoImage =
                    false;
                FFAppState().TradeMarkRegistrationCertificatesorLogoImagePDF =
                    '';
              });
              break;
            case 'ImportExportCertificatenumber':
              FFAppState().update(() {
                FFAppState().ImportExportCertificatenumber = false;
                FFAppState().ImportExportCertificatenumberPDF = '';
              });
              break;
          }
        }

        print(
            'Reset ${uploadedDocuments.length} buyer document flags and cleared PDF data');
        print('Updated fields: ${uploadedUrls.keys.join(', ')}');

        return true;
      } catch (dbError) {
        print('Error updating Buyer_User table: $dbError');
        return false;
      }
    } else {
      print(
          'No buyer documents were uploaded - all boolean flags were false or no base64 data found');
      return false;
    }
  } catch (e) {
    print('Error in updateDocumentstoSupabaseBuyer: $e');
    return false;
  }
}
