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

import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class QuadImagePickerWidget extends StatefulWidget {
  const QuadImagePickerWidget({
    Key? key,
    this.width,
    this.height,
    this.spacing = 10.0,
    this.imageWidth = 150.0,
    this.imageHeight = 150.0,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double spacing; // Space between image containers
  final double imageWidth; // Width of each image container
  final double imageHeight; // Height of each image container

  @override
  State<QuadImagePickerWidget> createState() => _QuadImagePickerWidgetState();
}

class _QuadImagePickerWidgetState extends State<QuadImagePickerWidget> {
  List<bool> _loadingStates = [false, false, false, false];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize the image list in FlutterFlow state if it doesn't exist
    _initializeImageList();
  }

  void _initializeImageList() {
    try {
      // Ensure we have a list of 4 empty strings in FlutterFlow state
      if (FFAppState().selectedImagesList == null ||
          FFAppState().selectedImagesList.length < 4) {
        FFAppState().update(() {
          FFAppState().selectedImagesList = List<String>.filled(4, '');
        });
      }
    } catch (e) {
      print('DEBUG: Error initializing image list: $e');
    }
  }

  // Check if the selected file is a WebP format
  bool _isWebPFile(String fileName) {
    return fileName.toLowerCase().endsWith('.webp');
  }

  Future<void> _pickImage(int index) async {
    // Validate index
    if (index < 0 || index > 3) {
      print('DEBUG: Invalid index: $index. Must be 0-3.');
      return;
    }

    setState(() {
      _loadingStates[index] = true;
    });

    try {
      // Show source selection dialog
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!kIsWeb) // Only show camera option on mobile
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                    onTap: () => Navigator.of(context).pop(ImageSource.camera),
                  ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      if (source != null) {
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );

        if (image != null) {
          // Check if the selected file is WebP format
          if (!_isWebPFile(image.name)) {
            _showErrorSnackBar(
                'Only WebP files are supported. Please select a .webp file.');
            return;
          }

          final bytes = await image.readAsBytes();
          final base64String = 'data:image/webp;base64,${base64Encode(bytes)}';

          try {
            FFAppState().update(() {
              if (FFAppState().selectedImagesList == null ||
                  FFAppState().selectedImagesList.length < 4) {
                FFAppState().selectedImagesList = List<String>.filled(4, '');
              }
              FFAppState().selectedImagesList[index] = base64String;
            });
            // print(
            //     'DEBUG: WebP image $index loaded and FlutterFlow state updated successfully');
          } catch (e) {
            // print('DEBUG: Error updating FlutterFlow state: $e');
            _showErrorSnackBar('Error updating app state: $e');
          }
        }
      }
    } catch (e) {
      print('DEBUG: Error picking image: $e');
      _showErrorSnackBar('Error picking image: $e');
    } finally {
      setState(() {
        _loadingStates[index] = false;
      });
    }
  }

  void _removeImage(int index) {
    try {
      FFAppState().update(() {
        if (FFAppState().selectedImagesList != null &&
            index < FFAppState().selectedImagesList.length) {
          FFAppState().selectedImagesList[index] = '';
        }
      });
      setState(() {});
      print('DEBUG: Image $index removed successfully');
    } catch (e) {
      print('DEBUG: Error removing image: $e');
    }
  }

  String? _getCurrentImage(int index) {
    try {
      if (FFAppState().selectedImagesList != null &&
          index < FFAppState().selectedImagesList.length) {
        final imageData = FFAppState().selectedImagesList[index];
        return (imageData != null && imageData.isNotEmpty) ? imageData : null;
      }
    } catch (e) {
      print('DEBUG: Error getting current image: $e');
    }
    return null;
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Get responsive dimensions based on screen size
  double _getImageSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // For mobile (portrait)
    if (screenWidth < 600) {
      return (screenWidth - 40) / 2.3; // More compact for mobile
    }
    // For tablet
    else if (screenWidth < 1200) {
      return 120; // Fixed smaller size for tablets
    }
    // For desktop
    else {
      return 140; // Smaller desktop size
    }
  }

  double _getSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return 6;
    } else if (screenWidth < 1200) {
      return 8;
    } else {
      return 10;
    }
  }

  Widget _buildImageContainer(int index, double imageSize) {
    final displayImage = _getCurrentImage(index);
    final isLoading = _loadingStates[index];

    return Expanded(
      child: GestureDetector(
        onTap: () => _pickImage(index),
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Stack(
            children: [
              // Main content
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : displayImage != null && displayImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            base64Decode(displayImage.split(',')[1]),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: imageSize * 0.2,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Error loading',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: imageSize * 0.08,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: imageSize * 0.25,
                              color: Colors.grey[600],
                            ),
                            SizedBox(height: imageSize * 0.05),
                            Text(
                              'Photo ${index + 1}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: imageSize * 0.1,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tap to select',
                              style: TextStyle(
                                color:
                                    kIsWeb ? Colors.orange : Colors.grey[500],
                                fontSize: imageSize * 0.08,
                              ),
                            ),
                          ],
                        ),

              // Remove button - only show when image exists
              if (displayImage != null && displayImage.isNotEmpty && !isLoading)
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),

              // Image number badge
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = _getImageSize(context);
    final spacing = _getSpacing(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 600 ? 8 : 12,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'Select Images',
            style: TextStyle(
              fontSize: screenWidth < 600 ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: screenWidth < 600 ? 8 : 10),

          // Images grid - 2x2 layout
          Center(
            child: Column(
              children: [
                // First row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImageContainer(0, imageSize),
                    SizedBox(width: spacing),
                    _buildImageContainer(1, imageSize),
                  ],
                ),
                SizedBox(height: spacing),

                // Second row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImageContainer(2, imageSize),
                    SizedBox(width: spacing),
                    _buildImageContainer(3, imageSize),
                  ],
                ),
              ],
            ),
          ),

          // Status text - updated to reflect WebP requirement
          SizedBox(height: 6),
          Center(
            child: Text(
              'Upload WebP files only. Max 10 MB',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: screenWidth < 600 ? 10 : 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
