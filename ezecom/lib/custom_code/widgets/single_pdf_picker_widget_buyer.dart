// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// GENERIC WIDGET FOR PDF PICKING - WORKS WITH MULTIPLE APP STATE VARIABLES
//import '/flutter_flow/flutter_flow_theme.dart';

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
//import '/flutter_flow/custom_functions.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert' show base64Encode;
import 'package:file_picker/file_picker.dart';
import 'dart:io' show File;

class SinglePdfPickerWidgetBuyer extends StatefulWidget {
  const SinglePdfPickerWidgetBuyer({
    Key? key,
    this.width = 85,
    this.height = 60,
    required this.appStateVariableName, // Required parameter for app state variable name
  }) : super(key: key);

  final double width;
  final double height;
  final String
      appStateVariableName; // The name of the app state variable to update

  @override
  _SinglePdfPickerWidgetBuyerState createState() =>
      _SinglePdfPickerWidgetBuyerState();
}

class _SinglePdfPickerWidgetBuyerState
    extends State<SinglePdfPickerWidgetBuyer> {
  bool _isLoading = false;
  String _fileName = '';
  bool _hasPdfFile = false;

  // Maximum file size in bytes (5MB)
  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB

  @override
  void initState() {
    super.initState();
    _initializePdfState();
  }

  void _initializePdfState() {
    try {
      final currentValue = _getAppStateValue();
      bool hasExistingPdf = currentValue != null && currentValue.isNotEmpty;

      setState(() {
        _hasPdfFile = hasExistingPdf;
        if (hasExistingPdf) {
          _fileName = 'Selected PDF'; // Default name for existing PDF
        }
      });

      if (currentValue == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _setAppStateValue('');
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setAppStateValue('');
      });
      setState(() {
        _hasPdfFile = false;
      });
    }
  }

  // Generic method to get app state value based on variable name
  String? _getAppStateValue() {
    print('Debug: Trying to get value for: ${widget.appStateVariableName}');
    switch (widget.appStateVariableName) {
      case 'CompanyLogoorTradeMarkPDF':
        return FFAppState().CompanyLogoorTradeMarkPDF;
      case 'CompanyCertificatePDF':
        return FFAppState().CompanyCertificatePDF;
      case 'TaxCertificatePDF':
        return FFAppState().TaxCertificatePDF;
      case 'TradeMarkRegistrationCertificatesorLogoImagePDF':
        return FFAppState().TradeMarkRegistrationCertificatesorLogoImagePDF;
      case 'ImportExportCertificatenumberPDF':
        return FFAppState().ImportExportCertificatenumberPDF;
      default:
        print('Debug: Unknown variable name: "${widget.appStateVariableName}"');
        print(
            'Debug: Variable name length: ${widget.appStateVariableName.length}');
        throw Exception(
            'Unknown app state variable: ${widget.appStateVariableName}');
    }
  }

  // Generic method to set app state value based on variable name
  void _setAppStateValue(String value) {
    switch (widget.appStateVariableName) {
      case 'CompanyLogoorTradeMarkPDF':
        FFAppState().CompanyLogoorTradeMarkPDF = value;
        break;
      case 'CompanyCertificatePDF':
        FFAppState().CompanyCertificatePDF = value;
        break;
      case 'TaxCertificatePDF':
        FFAppState().TaxCertificatePDF = value;
        break;
      case 'TradeMarkRegistrationCertificatesorLogoImagePDF':
        FFAppState().TradeMarkRegistrationCertificatesorLogoImagePDF = value;
        break;
      case 'ImportExportCertificatenumberPDF':
        FFAppState().ImportExportCertificatenumberPDF = value;
        break;
      default:
        throw Exception(
            'Unknown app state variable: ${widget.appStateVariableName}');
    }
  }

  // Method to format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes} B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  Future<void> _pickPdf() async {
    setState(() {
      _isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        List<int>? fileBytes;

        if (file.bytes != null) {
          fileBytes = file.bytes!;
        } else if (!kIsWeb && file.path != null) {
          try {
            File selectedFile = File(file.path!);
            fileBytes = await selectedFile.readAsBytes();
          } catch (e) {
            throw Exception('Unable to read file from path: $e');
          }
        } else {
          throw Exception('No file data available');
        }

        if (fileBytes == null || fileBytes.isEmpty) {
          throw Exception('File data is empty or null');
        }

        // Check file size limit
        if (fileBytes.length > maxFileSizeBytes) {
          _showErrorSnackBar(
              'File size is ${_formatFileSize(fileBytes.length)}. Maximum file size is 5 MB.');
          return;
        }

        final base64String = base64Encode(fileBytes);

        // Update local state immediately
        setState(() {
          _fileName = file.name;
          _hasPdfFile = true;
        });

        // Update the specific FFAppState variable
        _setAppStateValue(base64String);

        // Show success message
        _showSuccessSnackBar('PDF added successfully');
      } else {
        _showErrorSnackBar('No file selected');
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('path') && kIsWeb) {
        errorMessage = 'Web platform error. Please try again.';
      } else if (errorMessage.contains('bytes')) {
        errorMessage =
            'File reading error. Please ensure the file is accessible.';
      }
      _showErrorSnackBar('Error picking PDF: $errorMessage');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removePdf() {
    try {
      // Update local state immediately
      setState(() {
        _fileName = '';
        _hasPdfFile = false;
      });

      // Update the specific FFAppState variable
      _setAppStateValue('');

      _showSuccessSnackBar('PDF removed successfully');
    } catch (e) {
      _showErrorSnackBar('Error removing PDF: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildPdfDisplay() {
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: Colors.blue,
        //   width: 0.5,
        // ),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _fileName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: _removePdf,
              icon: const Icon(Icons.close),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _pickPdf,
      child: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey[100] : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(
          //   color: Colors.blue,
          //   width: 2,
          // ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Icon(
                  Icons.upload_file,
                  color: Colors.blue[600],
                  size: 30,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _hasPdfFile ? _buildPdfDisplay() : _buildAddButton();
  }
}
