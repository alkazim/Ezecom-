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
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class BannerManagementWidget extends StatefulWidget {
  const BannerManagementWidget({
    Key? key,
    this.width,
    this.height,
    required this.sellerEmail,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String sellerEmail;

  @override
  State<BannerManagementWidget> createState() => _BannerManagementWidgetState();
}

class _BannerManagementWidgetState extends State<BannerManagementWidget> {
  // Debug tag for logging
  static const String debugTag = '[BannerManagementWidget]';

  // Dropdown and product selection
  String? selectedProductId;
  String? selectedProductName;
  List<Map<String, dynamic>> products = [];
  bool isLoadingProducts = false;

  // Banner state variables
  String? mobileBannerBase64;
  String? desktopBannerBase64;
  String? mobileBannerUrl;
  String? desktopBannerUrl;

  // UI state
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();

  // Form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    debugPrint(
        '$debugTag initState called with sellerEmail: ${widget.sellerEmail}');
    _loadProducts();
  }

  // Load products from Supabase
  Future<void> _loadProducts() async {
    debugPrint('$debugTag _loadProducts started');
    setState(() {
      isLoadingProducts = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('Products_Table')
          .select('Product_id, Product_Name')
          .eq('Seller_Email', widget.sellerEmail);

      debugPrint(
          '$debugTag Products loaded: ${response.length} products found');

      setState(() {
        products = List<Map<String, dynamic>>.from(response);
        isLoadingProducts = false;
        // Optionally pre-select the first product if available
        if (products.isNotEmpty && selectedProductId == null) {
          selectedProductId = products.first['Product_id'].toString();
          selectedProductName = products.first['Product_Name'];
          debugPrint(
              '$debugTag Auto-selected first product: $selectedProductName');
        }
      });
    } catch (e) {
      debugPrint('$debugTag Error loading products: $e');
      setState(() {
        isLoadingProducts = false;
      });
      _showSnackBar('Error loading products: $e', isError: true);
    }
  }

  // Convert image to compressed format and Base64
  Future<String?> _convertToCompressedBase64(XFile imageFile) async {
    debugPrint(
        '$debugTag _convertToCompressedBase64 started for file: ${imageFile.name}');

    try {
      // Read image bytes
      Uint8List imageBytes = await imageFile.readAsBytes();
      debugPrint('$debugTag Original image size: ${imageBytes.length} bytes');

      // Decode image
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        debugPrint('$debugTag Error: Could not decode image');
        return null;
      }

      // Determine max width based on desktop/mobile
      final int maxWidth = imageFile.name.startsWith('desktop')
          ? 1920
          : 1200; // Adjusted max width
      final int quality = 85; // JPEG compression quality

      // Resize image if too large or specific dimensions required
      if (image.width > maxWidth || image.height > maxWidth) {
        // Calculate new dimensions while maintaining aspect ratio
        double aspectRatio = image.width / image.height;
        int newWidth = image.width;
        int newHeight = image.height;

        if (image.width > maxWidth) {
          newWidth = maxWidth;
          newHeight = (newWidth / aspectRatio).round();
        }
        if (newHeight > maxWidth) {
          newHeight = maxWidth;
          newWidth = (newHeight * aspectRatio).round();
        }
        image = img.copyResize(image, width: newWidth, height: newHeight);
        debugPrint(
            '$debugTag Image resized to: ${image.width}x${image.height}');
      }

      // Encode as JPEG with quality compression
      Uint8List compressedBytes = img.encodeJpg(image, quality: quality);
      debugPrint(
          '$debugTag Compressed image size: ${compressedBytes.length} bytes');

      // Convert to Base64
      String base64String = base64Encode(compressedBytes);
      debugPrint('$debugTag Base64 conversion completed');

      return base64String;
    } catch (e) {
      debugPrint('$debugTag Error converting image to compressed Base64: $e');
      return null;
    }
  }

  // Pick and process mobile banner
  Future<void> _pickMobileBanner() async {
    debugPrint('$debugTag _pickMobileBanner started');

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        debugPrint('$debugTag Mobile banner selected: ${image.name}');

        setState(() {
          isUploading = true;
        });

        String? base64String = await _convertToCompressedBase64(image);

        if (base64String != null) {
          setState(() {
            mobileBannerBase64 = base64String;
            isUploading = false;
          });
          debugPrint('$debugTag Mobile banner processed successfully');
          _showSnackBar('Mobile banner added successfully!');
        } else {
          setState(() {
            isUploading = false;
          });
          _showSnackBar('Error processing mobile banner', isError: true);
        }
      } else {
        debugPrint('$debugTag Mobile banner selection cancelled.');
      }
    } catch (e) {
      debugPrint('$debugTag Error picking mobile banner: $e');
      setState(() {
        isUploading = false;
      });
      _showSnackBar('Error selecting mobile banner: $e', isError: true);
    }
  }

  // Pick and process desktop banner
  Future<void> _pickDesktopBanner() async {
    debugPrint('$debugTag _pickDesktopBanner started');

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        debugPrint('$debugTag Desktop banner selected: ${image.name}');

        setState(() {
          isUploading = true;
        });

        String? base64String = await _convertToCompressedBase64(image);

        if (base64String != null) {
          setState(() {
            desktopBannerBase64 = base64String;
            isUploading = false;
          });
          debugPrint('$debugTag Desktop banner processed successfully');
          _showSnackBar('Desktop banner added successfully!');
        } else {
          setState(() {
            isUploading = false;
          });
          _showSnackBar('Error processing desktop banner', isError: true);
        }
      } else {
        debugPrint('$debugTag Desktop banner selection cancelled.');
      }
    } catch (e) {
      debugPrint('$debugTag Error picking desktop banner: $e');
      setState(() {
        isUploading = false;
      });
      _showSnackBar('Error selecting desktop banner: $e', isError: true);
    }
  }

  // Upload Base64 to Supabase Storage
  Future<String?> _uploadToSupabase(
      String base64String, String fileName) async {
    debugPrint('$debugTag _uploadToSupabase started for file: $fileName');

    try {
      // Convert base64 to bytes
      Uint8List bytes = base64Decode(base64String);

      // Upload to Supabase storage
      await Supabase.instance.client.storage.from('bannerstorage').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      debugPrint('$debugTag Upload successful for $fileName');

      // Get public URL
      final publicUrl = Supabase.instance.client.storage
          .from('bannerstorage')
          .getPublicUrl(fileName);

      debugPrint('$debugTag Public URL generated: $publicUrl');
      return publicUrl;
    } catch (e) {
      debugPrint('$debugTag Error uploading to Supabase: $e');
      _showSnackBar('Upload failed for $fileName: $e', isError: true);
      return null;
    }
  }

  // Submit banner data
  Future<void> _submitBanners() async {
    debugPrint('$debugTag _submitBanners started');

    if (!_formKey.currentState!.validate()) {
      debugPrint('$debugTag Form validation failed');
      return;
    }

    if (selectedProductId == null) {
      debugPrint('$debugTag Error: No product selected');
      _showSnackBar('Please select a product', isError: true);
      return;
    }

    if (mobileBannerBase64 == null && desktopBannerBase64 == null) {
      debugPrint('$debugTag Error: No banners selected');
      _showSnackBar('Please select at least one banner image to upload',
          isError: true);
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      String? mobileUrl;
      String? desktopUrl;

      // Upload mobile banner if exists
      if (mobileBannerBase64 != null) {
        debugPrint('$debugTag Attempting to upload mobile banner');
        String fileName =
            'mobile_${selectedProductId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        mobileUrl = await _uploadToSupabase(mobileBannerBase64!, fileName);

        if (mobileUrl == null) {
          throw Exception('Failed to upload mobile banner.');
        }
      }

      // Upload desktop banner if exists
      if (desktopBannerBase64 != null) {
        debugPrint('$debugTag Attempting to upload desktop banner');
        String fileName =
            'desktop_${selectedProductId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        desktopUrl = await _uploadToSupabase(desktopBannerBase64!, fileName);

        if (desktopUrl == null) {
          throw Exception('Failed to upload desktop banner.');
        }
      }

      // Insert into Banner_table only if at least one URL was successfully obtained
      if (mobileUrl != null || desktopUrl != null) {
        await _insertBannerRecord(mobileUrl, desktopUrl);
        _showSnackBar('Banners uploaded and recorded successfully!');

        // Reset form after successful upload
        _resetForm();
      } else {
        _showSnackBar('No banners were successfully uploaded.', isError: true);
      }
    } catch (e) {
      debugPrint('$debugTag Error submitting banners: $e');
      _showSnackBar(
          'Error uploading banners: ${e.toString().contains("Failed to upload") ? e.toString() : "An unexpected error occurred."}',
          isError: true);
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  // Insert banner record into database
  Future<void> _insertBannerRecord(
      String? mobileBannerUrl, String? desktopBannerUrl) async {
    debugPrint('$debugTag _insertBannerRecord started');

    try {
      // Check if a record for this Product_id already exists for the seller
      final existingBanners = await Supabase.instance.client
          .from('Banner_table')
          .select('id')
          .eq('Product_id', int.parse(selectedProductId!))
          .eq('Seller_Email', widget.sellerEmail)
          .limit(1);

      if (existingBanners.isNotEmpty) {
        // If a record exists, update it
        final bannerId = existingBanners.first['id'];
        debugPrint(
            '$debugTag Updating existing banner record with ID: $bannerId');
        await Supabase.instance.client.from('Banner_table').update({
          'Phone_Banner': mobileBannerUrl,
          'Desktop_Banner': desktopBannerUrl,
        }).eq('id', bannerId);
      } else {
        // Otherwise, insert a new record
        debugPrint('$debugTag Inserting new banner record');
        await Supabase.instance.client.from('Banner_table').insert({
          'Phone_Banner': mobileBannerUrl,
          'Desktop_Banner': desktopBannerUrl,
          'Product_id': int.parse(selectedProductId!),
          'Seller_Email': widget.sellerEmail,
          'Active': false,
        });
      }

      debugPrint('$debugTag Banner record operation completed successfully');
    } catch (e) {
      debugPrint('$debugTag Error inserting/updating banner record: $e');
      throw e;
    }
  }

  // Remove mobile banner
  void _removeMobileBanner() {
    debugPrint('$debugTag _removeMobileBanner called');
    setState(() {
      mobileBannerBase64 = null;
      mobileBannerUrl = null;
    });
    _showSnackBar('Mobile banner removed');
  }

  // Remove desktop banner
  void _removeDesktopBanner() {
    debugPrint('$debugTag _removeDesktopBanner called');
    setState(() {
      desktopBannerBase64 = null;
      desktopBannerUrl = null;
    });
    _showSnackBar('Desktop banner removed');
  }

  // Reset form after successful upload
  void _resetForm() {
    debugPrint('$debugTag _resetForm called');
    setState(() {
      selectedProductId = null;
      selectedProductName = null;
      mobileBannerBase64 = null;
      desktopBannerBase64 = null;
      mobileBannerUrl = null;
      desktopBannerUrl = null;
      _loadProducts();
      _formKey.currentState?.reset();
    });
  }

  // Show snackbar
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Build responsive layout
  Widget _buildResponsiveLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

        debugPrint(
            '$debugTag Building responsive layout - Width: ${constraints.maxWidth}, isMobile: $isMobile, isTablet: $isTablet');

        return ConstrainedBox(
          // Ensures the SingleChildScrollView tries to fill available space
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Temporary debug text to ensure anything renders
                  const Text(
                    'Banner Management Widget Loaded!',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  _buildHeader(isMobile),
                  const SizedBox(height: 32),
                  _buildProductDropdown(),
                  const SizedBox(height: 32),
                  if (isMobile)
                    _buildMobileLayout()
                  else if (isTablet)
                    _buildTabletLayout()
                  else
                    _buildDesktopLayout(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build header
  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Banner Management',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload banners for your products',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Build product dropdown
  Widget _buildProductDropdown() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Product',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            isLoadingProducts
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    value: selectedProductId,
                    decoration: const InputDecoration(
                      hintText: 'Choose a product',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<String>(
                        value: product['Product_id'].toString(),
                        child: Text(
                          product['Product_Name'] ?? 'Unknown Product',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProductId = value;
                        selectedProductName = products.firstWhere(
                          (product) =>
                              product['Product_id'].toString() == value,
                          orElse: () => {'Product_Name': 'Unknown'},
                        )['Product_Name'];
                      });
                      debugPrint(
                          '$debugTag Product selected: $selectedProductName (ID: $selectedProductId)');
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a product';
                      }
                      return null;
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // Build mobile layout
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildMobileBannerSection(),
        const SizedBox(height: 24),
        _buildDesktopBannerSection(),
      ],
    );
  }

  // Build tablet layout
  Widget _buildTabletLayout() {
    return Column(
      children: [
        _buildMobileBannerSection(),
        const SizedBox(height: 24),
        _buildDesktopBannerSection(),
      ],
    );
  }

  // Build desktop layout
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildMobileBannerSection()),
        const SizedBox(width: 24),
        Expanded(child: _buildDesktopBannerSection()),
      ],
    );
  }

  // Build mobile banner section
  Widget _buildMobileBannerSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.phone_android, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Mobile Banner',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Recommended aspect ratio: 9:16',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildBannerUploadArea(
              isDesktop: false,
              base64Data: mobileBannerBase64,
              onTap: _pickMobileBanner,
              onRemove: _removeMobileBanner,
            ),
          ],
        ),
      ),
    );
  }

  // Build desktop banner section
  Widget _buildDesktopBannerSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.desktop_windows, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Desktop Banner',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Recommended aspect ratio: 16:9',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildBannerUploadArea(
              isDesktop: true,
              base64Data: desktopBannerBase64,
              onTap: _pickDesktopBanner,
              onRemove: _removeDesktopBanner,
            ),
          ],
        ),
      ),
    );
  }

  // Build banner upload area
  Widget _buildBannerUploadArea({
    required bool isDesktop,
    required String? base64Data,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    double aspectRatio = isDesktop ? 16 / 9 : 9 / 16;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: isDesktop ? 200 : 300,
        maxHeight: isDesktop ? 300 : 400,
      ),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!,
              style: BorderStyle.solid,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: base64Data != null
              ? Stack(
                  children: [
                    // Image preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory(
                        base64Decode(base64Data),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        // Add an error builder for better debugging if image fails to load
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('$debugTag Error loading image: $error');
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 40),
                                SizedBox(height: 8),
                                Text('Image load error',
                                    style: TextStyle(color: Colors.red)),
                                Text('Tap to re-upload',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Remove button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 16,
                        child: IconButton(
                          onPressed: onRemove,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                          padding: EdgeInsets.zero,
                          tooltip: 'Remove banner',
                        ),
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tap to upload ${isDesktop ? 'desktop' : 'mobile'} banner',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click to upload (Recommended aspect ratio: ${isDesktop ? '16:9' : '9:16'})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // Build submit button
  Widget _buildSubmitButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isUploading ? null : _submitBanners,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
        child: isUploading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Uploading...'),
                ],
              )
            : const Text(
                'Submit Banners',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$debugTag build called');

    // Hardcode a fixed size for debugging purposes
    // IMPORTANT: This is for debugging. In a real app, you'd want proper parent constraints or flexible sizing.
    const double debugWidth = 800.0;
    const double debugHeight = 800.0;

    debugPrint(
        '$debugTag Root Container dimensions (Debug Fixed): Width=$debugWidth, Height=$debugHeight');

    return Container(
      width: debugWidth,
      height: debugHeight,
      // Add a distinct background and border for visibility during debugging
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.3),
        border: Border.all(color: Colors.red, width: 4),
      ),
      child: _buildResponsiveLayout(),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
