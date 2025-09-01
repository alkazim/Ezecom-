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

// GENERIC WIDGET FOR IMAGE PICKING - WORKS WITH MULTIPLE APP STATE VARIABLES
//import '/flutter_flow/flutter_flow_theme.dart';

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
//import '/flutter_flow/custom_functions.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert' show base64Encode;
import 'package:file_picker/file_picker.dart';
import 'dart:io' show File;

class SingleImagePickerWidget extends StatefulWidget {
  const SingleImagePickerWidget({
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
  State<SingleImagePickerWidget> createState() =>
      _SingleImagePickerWidgetState();
}

class _SingleImagePickerWidgetState extends State<SingleImagePickerWidget> {
  bool _isLoading = false;
  String _fileName = '';
  bool _hasImageFile = false;

  @override
  void initState() {
    super.initState();
    _initializeImageState();
  }

  void _initializeImageState() {
    try {
      final currentValue = _getAppStateValue();
      bool hasExistingImage = currentValue != null && currentValue.isNotEmpty;

      setState(() {
        _hasImageFile = hasExistingImage;
        if (hasExistingImage) {
          _fileName = 'Selected Image'; // Default name for existing image
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
        _hasImageFile = false;
      });
    }
  }

  // Generic method to get app state value based on variable name
  String? _getAppStateValue() {
    print('Debug: Trying to get value for: ${widget.appStateVariableName}');
    switch (widget.appStateVariableName) {
      case 'FactoryCompanyimage':
        return FFAppState().FactoryCompanyimage;
      case 'TrademarkorLogoImage':
        return FFAppState().TrademarkorLogoImage;
      case 'CompanyLogoorTradeMarkPDF': // Add this case
        return FFAppState().CompanyLogoorTradeMarkPDF;
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
      case 'FactoryCompanyimage':
        FFAppState().FactoryCompanyimage = value;
        break;
      case 'TrademarkorLogoImage':
        FFAppState().TrademarkorLogoImage = value;
        break;
      case 'CompanyLogoorTradeMarkPDF': // Add this case
        FFAppState().CompanyLogoorTradeMarkPDF = value;
        break;
      default:
        throw Exception(
            'Unknown app state variable: ${widget.appStateVariableName}');
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
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

        final base64String = base64Encode(fileBytes);

        // Update local state immediately
        setState(() {
          _fileName = file.name;
          _hasImageFile = true;
        });

        // Update the specific FFAppState variable
        _setAppStateValue(base64String);

        // Show success message
        _showSuccessSnackBar('Image added successfully');
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
      _showErrorSnackBar('Error picking image: $errorMessage');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeImage() {
    try {
      // Update local state immediately
      setState(() {
        _fileName = '';
        _hasImageFile = false;
      });

      // Update the specific FFAppState variable
      _setAppStateValue('');

      _showSuccessSnackBar('Image removed successfully');
    } catch (e) {
      _showErrorSnackBar('Error removing image: $e');
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

  Widget _buildImageDisplay() {
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
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
              onPressed: _removeImage,
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
      onTap: _isLoading ? null : _pickImage,
      child: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey[100] : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Icon(
                  Icons.add_photo_alternate,
                  color: Colors.blue[600],
                  size: 48,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _hasImageFile ? _buildImageDisplay() : _buildAddButton();
  }
}
