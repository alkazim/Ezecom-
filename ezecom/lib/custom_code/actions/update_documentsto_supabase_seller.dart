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

Future<bool> updateDocumentstoSupabaseSeller() async {
  try {
    // Get current authenticated user ID
    final user = SupaFlow.client.auth.currentUser;
    if (user == null) {
      print('No authenticated user found');
      return false;
    }

    final String authUserId = user.id;
    print('Authenticated user ID: $authUserId');

    // Document mapping for Seller_User table
    final Map<String, Map<String, String>> sellerDocumentMapping = {
      'CompanyRegistrationCertificate': {
        'pdfVar': 'CompanyRegistrationCertificatePDF',
        'storagePath': 'seller-documents/company-registration',
        'tableColumn': 'Company_Registration_Certificate'
      },
      'TaxRegistrationCertificate': {
        'pdfVar': 'TaxRegistrationCertificatePDF',
        'storagePath': 'seller-documents/tax-registration',
        'tableColumn': 'Tax_Registration_Certificate'
      },
      'OwnerDirectorIDCard': {
        'pdfVar': 'OwnerDirectorIDCardPDF',
        'storagePath': 'seller-documents/owner-director-id',
        'tableColumn': 'Owner/Director_ID_Card'
      },
      'FactoryCompanyimages': {
        'pdfVar': 'FactoryCompanyimage',
        'storagePath': 'seller-documents/factory-company-images',
        'tableColumn': 'Factory/Company_image'
      },
      'ImportExportCertificates': {
        'pdfVar': 'ImportExportCertificatePDF',
        'storagePath': 'seller-documents/import-export-certificates',
        'tableColumn': 'Import_Export_Certificate'
      },
      'LogoRegistrationCertificate': {
        'pdfVar': 'LogoRegistrationCertificatePDF',
        'storagePath': 'seller-documents/logo-registration',
        'tableColumn': 'Logo_Registration_Certificate'
      },
      'TrademarkorLogoImages': {
        'pdfVar': 'TrademarkorLogoImage',
        'storagePath': 'seller-documents/trademark-logo-images',
        'tableColumn': 'Trademark_or_Logo_Image'
      },
    };

    final Map<String, String> uploadedUrls = {};
    final List<String> uploadedDocuments = [];

    print('Starting seller document upload process...');

    // Process each document type
    for (final String booleanVar in sellerDocumentMapping.keys) {
      bool shouldUpload = false;

      // Get boolean value from app state
      switch (booleanVar) {
        case 'CompanyRegistrationCertificate':
          shouldUpload = FFAppState().CompanyRegistrationCertificate;
          break;
        case 'TaxRegistrationCertificate':
          shouldUpload = FFAppState().TaxRegistrationCertificate;
          break;
        case 'OwnerDirectorIDCard':
          shouldUpload = FFAppState().OwnerDirectorIDCard;
          break;
        case 'FactoryCompanyimages':
          shouldUpload = FFAppState().FactoryCompanyimages;
          break;
        case 'ImportExportCertificates':
          shouldUpload = FFAppState().ImportExportCertificates;
          break;
        case 'LogoRegistrationCertificate':
          shouldUpload = FFAppState().LogoRegistrationCertificate;
          break;
        case 'TrademarkorLogoImages':
          shouldUpload = FFAppState().TrademarkorLogoImages;
          break;
        default:
          shouldUpload = false;
      }

      print('Checking seller document $booleanVar: $shouldUpload');

      if (shouldUpload) {
        final String pdfVarName = sellerDocumentMapping[booleanVar]!['pdfVar']!;
        final String storagePath =
            sellerDocumentMapping[booleanVar]!['storagePath']!;
        final String tableColumn =
            sellerDocumentMapping[booleanVar]!['tableColumn']!;

        // Get PDF base64 value from app state
        String? pdfBase64Value;
        switch (pdfVarName) {
          case 'CompanyRegistrationCertificatePDF':
            pdfBase64Value = FFAppState().CompanyRegistrationCertificatePDF;
            break;
          case 'TaxRegistrationCertificatePDF':
            pdfBase64Value = FFAppState().TaxRegistrationCertificatePDF;
            break;
          case 'OwnerDirectorIDCardPDF':
            pdfBase64Value = FFAppState().OwnerDirectorIDCardPDF;
            break;
          case 'FactoryCompanyimage':
            pdfBase64Value = FFAppState().FactoryCompanyimage;
            break;
          case 'ImportExportCertificatePDF':
            pdfBase64Value = FFAppState().ImportExportCertificatePDF;
            break;
          case 'LogoRegistrationCertificatePDF':
            pdfBase64Value = FFAppState().LogoRegistrationCertificatePDF;
            break;
          case 'TrademarkorLogoImage':
            pdfBase64Value = FFAppState().TrademarkorLogoImage;
            break;
          default:
            pdfBase64Value = null;
        }

        if (pdfBase64Value != null && pdfBase64Value.isNotEmpty) {
          try {
            print('Uploading seller document $booleanVar...');

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
                'seller_${authUserId}_${timestamp}_${booleanVar.toLowerCase()}.pdf';

            // Upload to Supabase storage using SellerPDF bucket
            final response =
                await SupaFlow.client.storage.from('SellerPDF').uploadBinary(
                      '$storagePath/$fileName',
                      Uint8List.fromList(bytes),
                      fileOptions: const FileOptions(
                        contentType: 'application/pdf',
                        upsert: true,
                      ),
                    );

            if (response.isEmpty) {
              throw Exception(
                  'Upload failed for seller document $booleanVar - empty response');
            }

            // Get public URL from SellerPDF bucket
            final String publicUrl = SupaFlow.client.storage
                .from('SellerPDF')
                .getPublicUrl('$storagePath/$fileName');

            uploadedUrls[tableColumn] = publicUrl;
            uploadedDocuments.add(booleanVar);

            print(
                'Successfully uploaded seller document $booleanVar: $publicUrl');
          } catch (uploadError) {
            print('Error uploading seller document $booleanVar: $uploadError');
            continue;
          }
        } else {
          print('No base64 data found for seller document $booleanVar');
        }
      }
    }

    // Update database if any files were uploaded
    if (uploadedUrls.isNotEmpty) {
      try {
        print(
            'Updating Seller_User table with ${uploadedUrls.length} URLs for user: $authUserId');
        print('Fields to update: ${uploadedUrls.keys.toList()}');

        // Update only the specific columns that have new URLs
        await SupaFlow.client
            .from('Seller_User')
            .update(uploadedUrls)
            .eq('Auth_ID', authUserId);

        print(
            'Successfully updated Seller_User table with ${uploadedUrls.length} document URLs');

        // Reset boolean flags and clear PDF data for successfully uploaded documents
        for (final String docName in uploadedDocuments) {
          switch (docName) {
            case 'CompanyRegistrationCertificate':
              FFAppState().update(() {
                FFAppState().CompanyRegistrationCertificate = false;
                FFAppState().CompanyRegistrationCertificatePDF = '';
              });
              break;
            case 'TaxRegistrationCertificate':
              FFAppState().update(() {
                FFAppState().TaxRegistrationCertificate = false;
                FFAppState().TaxRegistrationCertificatePDF = '';
              });
              break;
            case 'OwnerDirectorIDCard':
              FFAppState().update(() {
                FFAppState().OwnerDirectorIDCard = false;
                FFAppState().OwnerDirectorIDCardPDF = '';
              });
              break;
            case 'FactoryCompanyimages':
              FFAppState().update(() {
                FFAppState().FactoryCompanyimages = false;
                FFAppState().FactoryCompanyimage = '';
              });
              break;
            case 'ImportExportCertificates':
              FFAppState().update(() {
                FFAppState().ImportExportCertificates = false;
                FFAppState().ImportExportCertificatePDF = '';
              });
              break;
            case 'LogoRegistrationCertificate':
              FFAppState().update(() {
                FFAppState().LogoRegistrationCertificate = false;
                FFAppState().LogoRegistrationCertificatePDF = '';
              });
              break;
            case 'TrademarkorLogoImages':
              FFAppState().update(() {
                FFAppState().TrademarkorLogoImages = false;
                FFAppState().TrademarkorLogoImage = '';
              });
              break;
          }
        }

        print(
            'Reset ${uploadedDocuments.length} seller document flags and cleared PDF data');
        print('Updated fields: ${uploadedUrls.keys.join(', ')}');

        return true;
      } catch (dbError) {
        print('Error updating Seller_User table: $dbError');
        return false;
      }
    } else {
      print(
          'No seller documents were uploaded - all boolean flags were false or no base64 data found');
      return false;
    }
  } catch (e) {
    print('Error in updateDocumentstoSupabaseSeller: $e');
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
