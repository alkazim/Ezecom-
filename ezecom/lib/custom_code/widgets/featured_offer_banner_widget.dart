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

import 'index.dart'; // Imports other custom widgets

import 'index.dart'; // Imports other custom widgets

import 'package:supabase_flutter/supabase_flutter.dart';

class FeaturedOfferBannerWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final String? mobileWidth;
  final String? mobileHeight;
  final String? desktopWidth1;
  final String? desktopHeight1;
  final String? desktopWidth2;
  final String? desktopHeight2;
  final String?
      pageIdentifier; // New parameter to identify which page this widget is used on

  const FeaturedOfferBannerWidget({
    Key? key,
    this.width,
    this.height = 200,
    this.mobileWidth = "1340",
    this.mobileHeight = "520",
    this.desktopWidth1 = "1500",
    this.desktopHeight1 = "848",
    this.desktopWidth2 = "775",
    this.desktopHeight2 = "416",
    this.pageIdentifier =
        "WebHome", // Default to WebHome for backward compatibility
  }) : super(key: key);

  @override
  State<FeaturedOfferBannerWidget> createState() =>
      _FeaturedOfferBannerWidgetState();
}

class _FeaturedOfferBannerWidgetState extends State<FeaturedOfferBannerWidget> {
  List<String> imageUrls = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
  }

  Future<void> _fetchImageUrls() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Fetch data from Supabase with updated conditions
      final response = await Supabase.instance.client
          .from('banner_public_view')
          .select('Phone_Banner, Desktop_Banner, Organization')
          .eq('Approval', 'approved')
          .eq('Active', true);

      print('Banner Widget: Fetched ${response.length} records from database');

      // Filter records based on Organization field
      List<Map<String, dynamic>> filteredRecords = [];
      for (var item in response) {
        if (item['Organization'] != null) {
          Map<String, dynamic> organization = item['Organization'];
          // Check if 'top deals' is 'true' in the Organization JSON
          if (organization['top deals'] == "true") {
            filteredRecords.add(item);
          }
        }
      }

      print(
          'Banner Widget: Filtered to ${filteredRecords.length} records with top deals="true"');

      // Determine if mobile or desktop
      bool isMobile = MediaQuery.of(context).size.width < 768;

      // Process the filtered data to get actual URLs
      List<String> actualUrls = [];
      for (var item in filteredRecords) {
        String? imageUrl = isMobile
            ? item['Phone_Banner']?.toString()
            : item['Desktop_Banner']?.toString();

        if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'null') {
          // Handle Supabase storage URLs properly
          String fullUrl = imageUrl;
          if (!imageUrl.startsWith('http')) {
            // If it's a relative path, construct the full URL
            fullUrl = Supabase.instance.client.storage
                .from(
                    'your-bucket-name') // Replace with your actual bucket name
                .getPublicUrl(imageUrl);
          }
          print('Banner Widget: Adding image URL - $fullUrl');
          actualUrls.add(fullUrl);
        }
      }

      setState(() {
        imageUrls = actualUrls;
        isLoading = false;
      });

      print(
          'Banner Widget: Successfully loaded ${imageUrls.length} images for ${widget.pageIdentifier}');
    } catch (e) {
      print('Banner Widget: Error fetching images - $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (isLoading) {
      print('Banner Widget: Loading state');
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }

    // Error state
    if (error != null) {
      print('Banner Widget: Error state - $error');
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 12),
              Text(
                'Failed to load images',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                error!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchImageUrls,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (imageUrls.isEmpty) {
      print(
          'Banner Widget: Empty state - no images available for ${widget.pageIdentifier}');
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported,
                  color: Colors.grey[400], size: 48),
              SizedBox(height: 12),
              Text(
                'No images available',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // Display images
    bool isMobile = MediaQuery.of(context).size.width < 768;
    print(
        'Banner Widget: Displaying ${imageUrls.length} images for ${widget.pageIdentifier} - isMobile: $isMobile');

    // If only one image, show it directly without ListView
    if (imageUrls.length == 1) {
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        child: _buildImageContainer(imageUrls[0], 0),
      );
    }

    // Multiple images - use PageView for better UX
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return _buildImageContainer(imageUrls[index], index);
        },
      ),
    );
  }

  Widget _buildImageContainer(String imageUrl, int index) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          headers: {
            'Cache-Control': 'no-cache',
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              print('Banner Widget: Image loaded successfully at index $index');
              return child;
            }
            print('Banner Widget: Loading image at index $index');
            return Container(
              color: Colors.grey[100],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Banner Widget: Image loading error at index $index: $error');
            return Container(
              color: Colors.grey[100],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported,
                        color: Colors.grey[400], size: 48),
                    SizedBox(height: 8),
                    Text(
                      'Image not available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'URL: ${imageUrl.length > 50 ? imageUrl.substring(0, 50) + '...' : imageUrl}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
