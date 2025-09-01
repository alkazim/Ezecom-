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

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert' show base64Encode;
import 'package:file_picker/file_picker.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:image/image.dart' as img;

class BannerImagePickerWidget extends StatefulWidget {
  const BannerImagePickerWidget({
    Key? key,
    this.width = 85,
    this.height = 60,
    required this.appStateVariableName,
    required this.dimensionsVariableName,
    required this.minWidth,
    required this.minHeight,
    required this.maxWidth,
    required this.maxHeight,
    required this.expectedAspectRatio,
    this.aspectRatioTolerance = 0.2,
  }) : super(key: key);

  final double width;
  final double height;
  final String appStateVariableName;
  final String dimensionsVariableName;
  final int minWidth;
  final int minHeight;
  final int maxWidth;
  final int maxHeight;
  final double expectedAspectRatio;
  final double aspectRatioTolerance;

  @override
  State<BannerImagePickerWidget> createState() =>
      _BannerImagePickerWidgetState();
}

class _BannerImagePickerWidgetState extends State<BannerImagePickerWidget> {
  bool _isLoading = false;
  String _fileName = '';
  bool _hasImageFile = false;
  String _imageInfo = '';
  String? _errorMessage;

  @override
  void initState() {
    debugPrint('BannerImagePickerWidget: initState called');
    super.initState();
    _initializeImageState();
  }

  void _initializeImageState() {
    debugPrint('BannerImagePickerWidget: _initializeImageState called');
    try {
      final currentValue = _getAppStateValue();
      final currentDimensions = _getDimensionsValue();

      bool hasExistingImage = currentValue != null &&
          currentValue.isNotEmpty &&
          currentValue != 'null';

      setState(() {
        _hasImageFile = hasExistingImage;
        if (hasExistingImage) {
          _fileName = 'Selected Image';
          if (currentDimensions != null && currentDimensions.isNotEmpty) {
            final dimensions = currentDimensions.split(' x ');
            if (dimensions.length == 2) {
              _imageInfo = '${dimensions[0]} x ${dimensions[1]}px • Loaded';
            } else {
              _imageInfo = 'Image Loaded';
            }
          } else {
            _imageInfo = 'Image Loaded';
          }
        }
      });
    } catch (e) {
      debugPrint('BannerImagePickerWidget: Error in _initializeImageState: $e');
      setState(() {
        _hasImageFile = false;
        _errorMessage = null;
      });
    }
  }

  String? _getAppStateValue() {
    debugPrint(
        'BannerImagePickerWidget: _getAppStateValue called for ${widget.appStateVariableName}');
    try {
      final appState = FFAppState();

      switch (widget.appStateVariableName) {
        case 'MobileBannerImage':
          return (appState as dynamic).MobileBannerImage as String?;
        case 'DesktopBannerImage':
          return (appState as dynamic).DesktopBannerImage as String?;
        default:
          debugPrint(
              'Unknown app state variable: ${widget.appStateVariableName}');
          return null;
      }
    } catch (e) {
      debugPrint('Error accessing app state: $e');
      return null;
    }
  }

  void _setAppStateValue(String value) {
    debugPrint(
        'BannerImagePickerWidget: _setAppStateValue called for ${widget.appStateVariableName} with value: $value');
    try {
      final appState = FFAppState();

      switch (widget.appStateVariableName) {
        case 'MobileBannerImage':
          (appState as dynamic).MobileBannerImage = value;
          break;
        case 'DesktopBannerImage':
          (appState as dynamic).DesktopBannerImage = value;
          break;
        default:
          throw Exception(
              'Unknown app state variable: ${widget.appStateVariableName}');
      }

      // Trigger state update in FlutterFlow
      appState.update(() {});
    } catch (e) {
      debugPrint('Error setting app state: $e');
      rethrow;
    }
  }

  String? _getDimensionsValue() {
    debugPrint(
        'BannerImagePickerWidget: _getDimensionsValue called for ${widget.dimensionsVariableName}');
    try {
      final appState = FFAppState();

      switch (widget.dimensionsVariableName) {
        case 'MobileDimension':
          return (appState as dynamic).MobileDimension as String?;
        case 'DesktopDimension':
          return (appState as dynamic).DesktopDimension as String?;
        default:
          debugPrint(
              'Unknown dimensions variable: ${widget.dimensionsVariableName}');
          return null;
      }
    } catch (e) {
      debugPrint('Error accessing dimensions: $e');
      return null;
    }
  }

  void _setDimensionsValue(String value) {
    debugPrint(
        'BannerImagePickerWidget: _setDimensionsValue called for ${widget.dimensionsVariableName} with value: $value');
    try {
      final appState = FFAppState();

      switch (widget.dimensionsVariableName) {
        case 'MobileDimension':
          (appState as dynamic).MobileDimension = value;
          break;
        case 'DesktopDimension':
          (appState as dynamic).DesktopDimension = value;
          break;
        default:
          throw Exception(
              'Unknown dimensions variable: ${widget.dimensionsVariableName}');
      }

      // Trigger state update in FlutterFlow
      appState.update(() {});
    } catch (e) {
      debugPrint('Error setting dimensions: $e');
      rethrow;
    }
  }

  bool _isValidImageFile(Uint8List bytes) {
    debugPrint(
        'BannerImagePickerWidget: _isValidImageFile called with bytes length: ${bytes.length}');
    if (bytes.length < 8) return false;

    // PNG: 89 50 4E 47 0D 0A 1A 0A
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      debugPrint('Valid PNG image detected');
      return true;
    }

    // JPEG: FF D8 FF
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      debugPrint('Valid JPEG image detected');
      return true;
    }

    // GIF: GIF87a or GIF89a
    if (bytes.length >= 6) {
      String header = String.fromCharCodes(bytes.sublist(0, 6));
      if (header == 'GIF87a' || header == 'GIF89a') {
        debugPrint('Valid GIF image detected');
        return true;
      }
    }

    // BMP: BM
    if (bytes.length >= 2 && bytes[0] == 0x42 && bytes[1] == 0x4D) {
      debugPrint('Valid BMP image detected');
      return true;
    }

    // WebP: RIFF....WEBP
    if (bytes.length >= 12) {
      String riff = String.fromCharCodes(bytes.sublist(0, 4));
      String webp = String.fromCharCodes(bytes.sublist(8, 12));
      if (riff == 'RIFF' && webp == 'WEBP') {
        debugPrint('Valid WebP image detected');
        return true;
      }
    }

    debugPrint('Invalid image file format');
    return false;
  }

  Future<ui.Image> _getImageDimensions(Uint8List imageBytes) async {
    debugPrint('BannerImagePickerWidget: _getImageDimensions called');
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      debugPrint('Image dimensions decoded: ${img.width}x${img.height}');
      completer.complete(img);
    });
    return completer.future;
  }

  bool _validateImageResolution(int width, int height) {
    debugPrint(
        'BannerImagePickerWidget: _validateImageResolution called with $width x $height');
    // Check minimum resolution
    if (width < widget.minWidth || height < widget.minHeight) {
      debugPrint('Image resolution too low');
      _showErrorSnackBar(
          'Image resolution too low. Minimum required: ${widget.minWidth}×${widget.minHeight}px. Current: ${width}×${height}px');
      return false;
    }

    // Check maximum resolution
    if (width > widget.maxWidth || height > widget.maxHeight) {
      debugPrint('Image resolution too high');
      _showErrorSnackBar(
          'Image resolution too high. Maximum allowed: ${widget.maxWidth}×${widget.maxHeight}px. Current: ${width}×${height}px');
      return false;
    }

    // Check aspect ratio
    double imageAspectRatio = width / height;
    double expectedMin =
        widget.expectedAspectRatio - widget.aspectRatioTolerance;
    double expectedMax =
        widget.expectedAspectRatio + widget.aspectRatioTolerance;

    if (imageAspectRatio < expectedMin || imageAspectRatio > expectedMax) {
      debugPrint('Invalid aspect ratio: $imageAspectRatio');
      _showErrorSnackBar(
          'Image aspect ratio not suitable for banner. Expected: ${widget.expectedAspectRatio}:1 (±${widget.aspectRatioTolerance}). Current: ${imageAspectRatio.toStringAsFixed(2)}:1');
      return false;
    }

    debugPrint('Image resolution and aspect ratio validated successfully');
    return true;
  }

  Future<Uint8List> _compressImage(Uint8List imageBytes) async {
    debugPrint(
        'BannerImagePickerWidget: _compressImage called with bytes length: ${imageBytes.length}');
    try {
      img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        debugPrint('Failed to decode image for compression');
        throw Exception('Failed to decode image for compression');
      }

      // Compress as JPEG with 85% quality for better file size
      List<int> compressedBytes = img.encodeJpg(originalImage, quality: 85);

      if (compressedBytes.isEmpty) {
        debugPrint('Image compression failed - empty result');
        throw Exception('Image compression failed - empty result');
      }

      debugPrint(
          'Image compressed successfully. Original size: ${imageBytes.length}, Compressed size: ${compressedBytes.length}');
      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      debugPrint('Image compression failed: $e. Using original image.');
      // Return original bytes if compression fails
      return imageBytes;
    }
  }

  Future<void> _pickImage() async {
    debugPrint('BannerImagePickerWidget: _pickImage called');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        debugPrint('File selected: ${file.name}');

        // Validate file extension
        String fileName = file.name.toLowerCase();
        List<String> allowedExtensions = [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'bmp',
          'webp'
        ];
        bool isValidExtension =
            allowedExtensions.any((ext) => fileName.endsWith('.$ext'));

        if (!isValidExtension) {
          debugPrint('Invalid file extension: $fileName');
          throw Exception(
              'Please select a valid image file (JPG, PNG, GIF, BMP, WebP)');
        }

        Uint8List? fileBytes = file.bytes;

        if (fileBytes == null || fileBytes.isEmpty) {
          debugPrint('Unable to read file data');
          throw Exception('Unable to read file data');
        }

        // Validate file size (max 10MB)
        if (fileBytes.length > 10 * 1024 * 1024) {
          debugPrint('File size too large: ${fileBytes.length} bytes');
          throw Exception('File size too large. Maximum allowed: 10MB');
        }

        // Validate image file format
        if (!_isValidImageFile(fileBytes)) {
          debugPrint('Invalid image file format');
          throw Exception('Selected file is not a valid image format');
        }

        // Get image dimensions
        final ui.Image image = await _getImageDimensions(fileBytes);
        final int imageWidth = image.width;
        final int imageHeight = image.height;

        // Validate resolution and aspect ratio
        if (!_validateImageResolution(imageWidth, imageHeight)) {
          return;
        }

        // Compress the image
        final Uint8List compressedBytes = await _compressImage(fileBytes);
        final String base64String = base64Encode(compressedBytes);
        final String dimensionsString = '$imageWidth x $imageHeight';

        // Update state
        setState(() {
          _fileName = file.name;
          _hasImageFile = true;
          _imageInfo = '${imageWidth} x ${imageHeight}px • JPEG Format';
        });

        // Update FFAppState variables
        _setAppStateValue(base64String);
        _setDimensionsValue(dimensionsString);

        _showSuccessSnackBar(
            'Image uploaded successfully! Resolution: ${imageWidth} x ${imageHeight}px');
      } else {
        debugPrint('No file selected');
        throw Exception('No file selected');
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Error in _pickImage: $errorMessage');
      setState(() {
        _errorMessage = errorMessage;
      });
      _showErrorSnackBar(errorMessage);
    } finally {
      debugPrint('_pickImage completed');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeImage() {
    debugPrint('BannerImagePickerWidget: _removeImage called');
    try {
      setState(() {
        _fileName = '';
        _hasImageFile = false;
        _imageInfo = '';
        _errorMessage = null;
      });

      _setAppStateValue('');
      _setDimensionsValue('');

      _showSuccessSnackBar('Image removed successfully');
    } catch (e) {
      debugPrint('Error in _removeImage: $e');
      _showErrorSnackBar('Error removing image: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    debugPrint('BannerImagePickerWidget: Showing error snackbar: $message');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    debugPrint('BannerImagePickerWidget: Showing success snackbar: $message');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildImageDisplay() {
    debugPrint('BannerImagePickerWidget: _buildImageDisplay called');
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _fileName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_imageInfo.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      _imageInfo,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: _removeImage,
              icon: const Icon(Icons.close, size: 18),
              color: Colors.red,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    debugPrint('BannerImagePickerWidget: _buildAddButton called');
    return GestureDetector(
      onTap: _isLoading ? null : _pickImage,
      child: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey[100] : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _errorMessage != null ? Colors.red : Colors.blue,
            width: 2,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _errorMessage != null
                        ? Icons.error_outline
                        : Icons.add_photo_alternate,
                    color: _errorMessage != null
                        ? Colors.red[600]
                        : Colors.blue[600],
                    size: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _errorMessage ?? 'Add Banner Image',
                    style: TextStyle(
                      fontSize: 12,
                      color: _errorMessage != null
                          ? Colors.red[600]
                          : Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_errorMessage == null) ...[
                    Text(
                      '${widget.minWidth}×${widget.minHeight} - ${widget.maxWidth}×${widget.maxHeight}px',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Aspect Ratio: ${widget.expectedAspectRatio}:1',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BannerImagePickerWidget: build called');
    return _hasImageFile ? _buildImageDisplay() : _buildAddButton();
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
