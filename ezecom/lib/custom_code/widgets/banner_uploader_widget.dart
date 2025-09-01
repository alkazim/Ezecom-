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
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class BannerUploaderWidget extends StatefulWidget {
  const BannerUploaderWidget({
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
    this.initialImageUrl, // This prop can now be used to pre-fill from an outside source if desired
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
  final String? initialImageUrl; // Can be used to set an initial value

  @override
  State<BannerUploaderWidget> createState() => _BannerUploaderWidgetState();
}

class _BannerUploaderWidgetState extends State<BannerUploaderWidget> {
  bool _isLoading = false;
  String _fileName = '';
  bool _hasImageFile = false;
  String _imageInfo = '';
  String? _errorMessage;
  String?
      _currentImageUrl; // This will now reflect the App State value or initialImageUrl
  bool _isLoadingUrlImage = false;
  Uint8List?
      _selectedImageBytes; // Added to hold selected image bytes for preview

  @override
  void initState() {
    debugPrint('BannerUploaderWidget: initState called');
    super.initState();
    _initializeImageState();
  }

  // This method now prioritizes initialImageUrl, then reads from App State
  void _initializeImageState() {
    // debugPrint('BannerUploaderWidget: _initializeImageState called');
    // debugPrint(
    //      'BannerUploaderWidget: initialImageUrl param received: ${widget.initialImageUrl}'); // <-- NEW DEBUG PRINT

    try {
      bool foundImageToDisplay = false;

      // 1. Prioritize initialImageUrl from widget properties if provided
      // This is for the VERY FIRST load of the widget when a URL might be passed from an action.
      if (widget.initialImageUrl != null &&
          widget.initialImageUrl!.isNotEmpty &&
          widget.initialImageUrl! != 'null') {
        // Ensure it's not the string 'null'
        // debugPrint(
        //      'BannerUploaderWidget: Attempting to use initialImageUrl: ${widget.initialImageUrl}');
        setState(() {
          _currentImageUrl = widget.initialImageUrl;
          _fileName = 'Initial Banner Image'; // Default name
          _hasImageFile = true;
          _selectedImageBytes = null; // Clear local bytes if loading from URL
        });

        // Attempt to load the image from the URL
        if (Uri.tryParse(_currentImageUrl!)?.hasAbsolutePath ?? false) {
          _loadImageFromUrl(_currentImageUrl!);
        } else {
          // Fallback: If initialImageUrl is not a URL, try decoding as base64 (less common for initialImageUrl)
          try {
            _selectedImageBytes = base64Decode(_currentImageUrl!);
            _fileName = 'Initial Banner Image (Base64)';
            _imageInfo =
                _getDimensionsValue() ?? 'Image Loaded (Base64 Initial)';
            _currentImageUrl = null; // Ensure Image.memory is used for display
          } catch (e) {
            // debugPrint(
            //      'BannerUploaderWidget: initialImageUrl is not a valid URL or Base64: $e');
            setState(() {
              _errorMessage = 'Invalid initial image format provided.';
              _hasImageFile = false;
              _currentImageUrl = null;
              _selectedImageBytes = null;
            });
          }
        }
        foundImageToDisplay = true;
      }

      // 2. If no initialImageUrl was provided or it failed, then check App State
      if (!foundImageToDisplay) {
        // debugPrint(
        //      'BannerUploaderWidget: initialImageUrl was not used. Checking App State for image.');
        final currentValue =
            _getAppStateValue(); // This is the URL/Base64 from App State
        final currentDimensions = _getDimensionsValue();

        bool hasExistingImageInAppState = currentValue != null &&
            currentValue.isNotEmpty &&
            currentValue != 'null';

        setState(() {
          _hasImageFile = hasExistingImageInAppState;
          if (hasExistingImageInAppState) {
            _currentImageUrl = currentValue;
            _fileName = 'Current Banner Image';
            if (currentDimensions != null && currentDimensions.isNotEmpty) {
              _imageInfo = currentDimensions;
            } else {
              _imageInfo = 'Image Loaded (Dimensions Unknown)';
            }
            _selectedImageBytes =
                null; // Clear local bytes if loading from App State URL

            // If App State holds a URL, try to load it
            if (Uri.tryParse(_currentImageUrl!)?.hasAbsolutePath ?? false) {
              _loadImageFromUrl(_currentImageUrl!);
            } else {
              // If App State holds Base64, decode it
              try {
                _selectedImageBytes = base64Decode(_currentImageUrl!);
                _imageInfo =
                    currentDimensions ?? 'Image Loaded (Base64 from App State)';
                _currentImageUrl = null; // Ensure Image.memory is used
              } catch (e) {
                // debugPrint(
                //      'BannerUploaderWidget: Not a valid URL or Base64 in app state: $e');
                _hasImageFile = false;
                _currentImageUrl = null;
                _selectedImageBytes = null;
                _imageInfo = '';
              }
            }
          } else {
            // debugPrint('BannerUploaderWidget: No image found in App State.');
            // No image in app state either
            _fileName = '';
            _imageInfo = '';
            _currentImageUrl = null;
            _selectedImageBytes = null;
          }
        });
      }
    } catch (e) {
      // debugPrint('BannerUploaderWidget: Error in _initializeImageState: $e');
      setState(() {
        _hasImageFile = false;
        _errorMessage = null; // Clear previous error messages if any
      });
    }
  }

  // This function is still useful if the App State or initialImageUrl stores a URL and you want to display it
  Future<void> _loadImageFromUrl(String imageUrl) async {
    // debugPrint(
    //      'BannerUploaderWidget: _loadImageFromUrl called with: $imageUrl'); // <-- NEW DEBUG PRINT
    setState(() {
      _isLoadingUrlImage = true;
      _errorMessage = null; // Clear any previous error message
    });

    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;

        if (!_isValidImageFile(imageBytes)) {
          throw Exception('Invalid image format from URL');
        }

        final ui.Image image = await _getImageDimensions(imageBytes);
        final int imageWidth = image.width;
        final int imageHeight = image.height;

        // Validate resolution and aspect ratio (important even for initial URL display)
        if (!_validateImageResolution(imageWidth, imageHeight)) {
          // If validation fails, _showErrorSnackBar is called internally.
          // We set _hasImageFile to false to show the Add button again.
          setState(() {
            _hasImageFile = false;
            _currentImageUrl = null;
            _selectedImageBytes = null;
            _imageInfo = '';
          });
          return; // Stop processing if validation fails
        }

        setState(() {
          _fileName = 'Current Banner Image';
          _imageInfo = '${imageWidth} x ${imageHeight}px';
          _hasImageFile = true;
          _selectedImageBytes = null; // Ensure we display the URL image
          _currentImageUrl = imageUrl; // Confirm URL for display
        });

        // Update the dimension App State variable
        _setDimensionsValue('$imageWidth x $imageHeight');
        // debugPrint(
        //      'Image loaded from URL successfully: ${imageWidth}x${imageHeight}');
      } else {
        throw Exception(
            'Failed to load image from URL (Status: ${response.statusCode})');
      }
    } catch (e) {
      // debugPrint(
      //      'BannerUploaderWidget: Error loading image from URL ($imageUrl): $e'); // <-- NEW DEBUG PRINT
      setState(() {
        _errorMessage = 'Failed to load image from URL: ${e.toString()}';
        _hasImageFile = false;
        _imageInfo = '';
        _currentImageUrl = null; // Clear URL if loading fails
        _selectedImageBytes = null;
      });
    } finally {
      setState(() {
        _isLoadingUrlImage = false;
      });
    }
  }

  // --- App State Getters and Setters (modified to use update block for setters) ---
  String? _getAppStateValue() {
    // debugPrint(
    //      'BannerUploaderWidget: _getAppStateValue called for ${widget.appStateVariableName}');
    try {
      final appState = FFAppState();
      switch (widget.appStateVariableName) {
        case 'MobileBannerImage':
          return (appState as dynamic).MobileBannerImage as String?;
        case 'DesktopBannerImage':
          return (appState as dynamic).DesktopBannerImage as String?;
        default:
          // debugPrint(
          //      'Unknown app state variable: ${widget.appStateVariableName}');
          return null;
      }
    } catch (e) {
      debugPrint('Error accessing app state: $e');
      return null;
    }
  }

  void _setAppStateValue(String value) {
    debugPrint(
        'BannerUploaderWidget: _setAppStateValue called for ${widget.appStateVariableName} with value: $value');
    try {
      final appState = FFAppState();
      appState.update(() {
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
      });
    } catch (e) {
      debugPrint('Error setting app state: $e');
      rethrow;
    }
  }

  String? _getDimensionsValue() {
    // debugPrint(
    //      'BannerUploaderWidget: _getDimensionsValue called for ${widget.dimensionsVariableName}');
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
        'BannerUploaderWidget: _setDimensionsValue called for ${widget.dimensionsVariableName} with value: $value');
    try {
      final appState = FFAppState();
      appState.update(() {
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
      });
    } catch (e) {
      debugPrint('Error setting dimensions: $e');
      rethrow;
    }
  }
  // --- End App State Getters and Setters ---

  bool _isValidImageFile(Uint8List bytes) {
    debugPrint(
        'BannerUploaderWidget: _isValidImageFile called with bytes length: ${bytes.length}');
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
    debugPrint('BannerUploaderWidget: _getImageDimensions called');
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      debugPrint('Image dimensions decoded: ${img.width}x${img.height}');
      completer.complete(img);
    });
    return completer.future;
  }

  bool _validateImageResolution(int width, int height) {
    debugPrint(
        'BannerUploaderWidget: _validateImageResolution called with $width x $height');
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
        'BannerUploaderWidget: _compressImage called with bytes length: ${imageBytes.length}');
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
    debugPrint('BannerUploaderWidget: _pickImage called');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedImageBytes = null; // Clear previous selection
      _currentImageUrl = null; // Clear any previously loaded URL display
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
          // If validation fails, _showErrorSnackBar is called internally,
          // so just return to stop further processing.
          return;
        }

        // Compress the image (even if not uploaded, it's good practice for smaller base64)
        final Uint8List compressedBytes = await _compressImage(fileBytes);

        // Convert to Base64 to store in App State
        final String base64Image = base64Encode(compressedBytes);
        final String dimensionsString = '$imageWidth x $imageHeight';

        // Update local state for immediate preview
        setState(() {
          _selectedImageBytes =
              compressedBytes; // Use compressed bytes for preview
          _fileName = file.name;
          _hasImageFile = true;
          _imageInfo = '${imageWidth} x ${imageHeight}px • Preview';
          _currentImageUrl =
              null; // Ensure no URL is displayed if we have local bytes
        });

        // Update FFAppState variables
        _setAppStateValue(base64Image); // Store Base64 string in App State
        _setDimensionsValue(dimensionsString);

        // --- START OF MODIFIED CODE FOR CHANGED FLAGS ---
        final appState = FFAppState();
        appState.update(() {
          if (widget.appStateVariableName == 'MobileBannerImage') {
            (appState as dynamic).mobileChanged = true;
            debugPrint('App State: MobileChanged set to true');
          } else if (widget.appStateVariableName == 'DesktopBannerImage') {
            (appState as dynamic).desktopChanged = true;
            debugPrint('App State: DesktopChanged set to true');
          }
        });
        // --- END OF MODIFIED CODE ---

        _showSuccessSnackBar(
            'Image selected and ready! Resolution: ${imageWidth} x ${imageHeight}px');
      } else {
        debugPrint('No file selected');
        // This is not an error, so no snackbar for user cancelling
        setState(() {
          _hasImageFile = _getAppStateValue() != null &&
              _getAppStateValue()!
                  .isNotEmpty; // Re-evaluate if an image was already in app state
          _currentImageUrl =
              _getAppStateValue(); // Revert to app state image if any
          if (_hasImageFile) {
            _initializeImageState(); // Re-initialize to show existing app state image properly
          } else {
            _errorMessage = null; // Clear error if user just cancelled
          }
        });
      }
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Error in _pickImage: $errorMessage');
      setState(() {
        _errorMessage = errorMessage;
        _selectedImageBytes = null; // Clear selected bytes on error
        _currentImageUrl = null; // Clear current URL on error
        _hasImageFile = false; // Ensure no image is shown if there's an error
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
    debugPrint('BannerUploaderWidget: _removeImage called');
    try {
      setState(() {
        _fileName = '';
        _hasImageFile = false;
        _imageInfo = '';
        _errorMessage = null;
        _currentImageUrl = null;
        _selectedImageBytes = null; // Clear selected bytes
      });

      // Clear FFAppState variables
      _setAppStateValue('');
      _setDimensionsValue('');

      // --- START OF MODIFIED CODE FOR CHANGED FLAGS ---
      final appState = FFAppState();
      appState.update(() {
        if (widget.appStateVariableName == 'MobileBannerImage') {
          (appState as dynamic).mobileChanged = true;
          debugPrint('App State: MobileChanged set to true on remove');
        } else if (widget.appStateVariableName == 'DesktopBannerImage') {
          (appState as dynamic).desktopChanged = true;
          debugPrint('App State: DesktopChanged set to true on remove');
        }
      });
      // --- END OF MODIFIED CODE ---

      _showSuccessSnackBar('Image removed from App State');
    } catch (e) {
      debugPrint('Error in _removeImage: $e');
      _showErrorSnackBar(
          'Error removing image from App State: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    debugPrint('BannerUploaderWidget: Showing error snackbar: $message');
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
    debugPrint('BannerUploaderWidget: Showing success snackbar: $message');
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
    debugPrint('BannerUploaderWidget: _buildImageDisplay called');
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
          // Display actual image: prioritize selected bytes for immediate preview, then current URL
          if (_selectedImageBytes != null && _selectedImageBytes!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                _selectedImageBytes!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 24),
                        Text('Failed to load local image',
                            style: TextStyle(color: Colors.red, fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            )
          else if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty)
            // Check if _currentImageUrl is a valid URL or Base64
            (Uri.tryParse(_currentImageUrl!)?.hasAbsolutePath ?? false)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _currentImageUrl!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 24),
                              Text('Failed to load image from App State URL',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : // Assume it's base64 if not a URL
                FutureBuilder<Uint8List>(
                    future: Future.value(base64Decode(
                        _currentImageUrl!)), // Decode base64 as a Future
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            snapshot.data!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error,
                                        color: Colors.red, size: 24),
                                    Text('Failed to decode Base64 image',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 24),
                              Text('Error decoding Base64: ${snapshot.error}',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            ],
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),

          // Overlay with info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _fileName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_imageInfo.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      _imageInfo,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Remove button
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _removeImage,
                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    debugPrint('BannerUploaderWidget: _buildAddButton called');
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
        child: _isLoading || _isLoadingUrlImage
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
                    const SizedBox(height: 2),
                    Text(
                      'Size: ${widget.minWidth}×${widget.minHeight} - ${widget.maxWidth}×${widget.maxHeight}px',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BannerUploaderWidget: build called');
    return Container(
      width: widget.width,
      height: widget.height,
      child: _hasImageFile ? _buildImageDisplay() : _buildAddButton(),
    );
  }
}
