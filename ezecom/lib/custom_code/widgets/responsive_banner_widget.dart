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

// import '/custom_code/widgets/index.dart';
// import '/custom_code/actions/index.dart';
// import '/flutter_flow/custom_functions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ResponsiveBannerWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final String? mobileWidth;
  final String? mobileHeight;
  final String? desktopWidth1;
  final String? desktopHeight1;
  final String? desktopWidth2;
  final String? desktopHeight2;

  const ResponsiveBannerWidget({
    Key? key,
    this.width,
    this.height = 200,
    this.mobileWidth = "1340",
    this.mobileHeight = "520",
    this.desktopWidth1 = "1500",
    this.desktopHeight1 = "848",
    this.desktopWidth2 = "775",
    this.desktopHeight2 = "416",
  }) : super(key: key);

  @override
  State<ResponsiveBannerWidget> createState() => _ResponsiveBannerWidgetState();
}

class _ResponsiveBannerWidgetState extends State<ResponsiveBannerWidget> {
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

      print("🔄 Fetching banners from Supabase...");

      final response = await Supabase.instance.client
          .from('banner_public_view')
          .select('Phone_Banner, Desktop_Banner, Organization')
          .eq('Approval', 'approved')
          .eq('Active', true);

      print("📦 Total records fetched: ${response.length}");

      // Filter for Organization.WebHome == true
      List<Map<String, dynamic>> filteredRecords = [];
      for (var item in response) {
        final org = item['Organization'];
        print("📄 Checking Organization: $org");
        if (org != null && org['WebHome'] == "true") {
          print("✅ Found WebHome=true ✅");
          filteredRecords.add(item);
        }
      }

      print("🧮 Records with WebHome=true: ${filteredRecords.length}");

      final bool isMobile = MediaQuery.of(context).size.width < 768;
      print("📱 Device Type: ${isMobile ? "Mobile" : "Desktop"}");

      List<String> actualUrls = [];
      for (var item in filteredRecords) {
        String? imageUrl = isMobile
            ? item['Phone_Banner']?.toString()
            : item['Desktop_Banner']?.toString();

        if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'null') {
          String fullUrl = imageUrl;
          if (!imageUrl.startsWith('http')) {
            fullUrl = Supabase.instance.client.storage
                .from(
                    'your-bucket-name') // ⛳ Replace this with your actual bucket name
                .getPublicUrl(imageUrl);
          }
          print("🖼️ Image URL added: $fullUrl");
          actualUrls.add(fullUrl);
        }
      }

      setState(() {
        imageUrls = actualUrls;
        isLoading = false;
      });

      print("🎉 Done loading ${imageUrls.length} images.");
    } catch (e) {
      print("❌ Error fetching banners: $e");
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      print("⏳ Showing loading indicator...");
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }

    if (error != null) {
      print("⚠️ Showing error UI...");
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        color: Colors.white,
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

    if (imageUrls.isEmpty) {
      print("📭 No banners to show...");
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        color: Colors.white,
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

    if (imageUrls.length == 1) {
      print("🖼️ Displaying single banner...");
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        color: Colors.white,
        child: _buildImageContainer(imageUrls[0], 0),
      );
    }

    print("📽️ Displaying PageView with ${imageUrls.length} images...");
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200,
      color: Colors.white,
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
              print("✅ Image $index loaded");
              return child;
            }
            print("🔃 Loading image $index...");
            return Container(
              color: Colors.white,
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
            print("❌ Error loading image $index: $error");
            return Container(
              color: Colors.white,
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
