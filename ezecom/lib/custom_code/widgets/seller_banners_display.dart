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

class SellerBannersDisplay extends StatefulWidget {
  const SellerBannersDisplay({
    super.key,
    this.width,
    this.height,
    required this.sellerEmail,
  });

  final double? width;
  final double? height;
  final String sellerEmail;

  @override
  State<SellerBannersDisplay> createState() => _SellerBannersDisplayState();
}

class _SellerBannersDisplayState extends State<SellerBannersDisplay> {
  List<dynamic> mobileBanners = [];
  List<dynamic> desktopBanners = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    print(
        'SellerBannersDisplay: Widget initialized with seller email: ${widget.sellerEmail}');
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    print(
        'SellerBannersDisplay: Starting to fetch banners for seller: ${widget.sellerEmail}');

    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await SupaFlow.client
          .from('Banner_table')
          .select('*')
          .eq('Seller_Email', widget.sellerEmail)
          .eq('Active', true);

      print(
          'SellerBannersDisplay: Supabase response received: ${response.toString()}');

      if (response != null) {
        List<dynamic> allBanners = response as List<dynamic>;
        print(
            'SellerBannersDisplay: Total banners found: ${allBanners.length}');

        mobileBanners = allBanners
            .where((banner) =>
                banner['Phone_Banner'] != null &&
                banner['Phone_Banner'].toString().isNotEmpty)
            .toList();

        desktopBanners = allBanners
            .where((banner) =>
                banner['Desktop_Banner'] != null &&
                banner['Desktop_Banner'].toString().isNotEmpty)
            .toList();

        print(
            'SellerBannersDisplay: Mobile banners count: ${mobileBanners.length}');
        print(
            'SellerBannersDisplay: Desktop banners count: ${desktopBanners.length}');

        for (var banner in allBanners) {
          print(
              'SellerBannersDisplay: Banner ID ${banner['id']} - Approval Status: ${banner['Approval']}');
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print('SellerBannersDisplay: No response received from Supabase');
        setState(() {
          isLoading = false;
          errorMessage = 'No banners found for this seller';
        });
      }
    } catch (e) {
      print('SellerBannersDisplay: Error fetching banners: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading banners: $e';
      });
    }
  }

  Color _getApprovalStatusColor(String? approval) {
    String status = approval?.toLowerCase() ?? 'pending';

    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  Widget _buildBannerCard(dynamic banner, bool isMobile) {
    String imageUrl =
        isMobile ? banner['Phone_Banner'] : banner['Desktop_Banner'];
    String dimensions = isMobile
        ? banner['Mobile_Dimensions'] ?? 'Not specified'
        : banner['Desktop_Dimensions'] ?? 'Not specified';
    String? approvalStatus = banner['Approval'];

    print(
        'SellerBannersDisplay: Building banner card for ${isMobile ? 'mobile' : 'desktop'} with URL: $imageUrl, Approval: $approvalStatus');

    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 2.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image without any overlay
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Container(
                width: double.infinity,
                height: _getResponsiveImageHeight(),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      print(
                          'SellerBannersDisplay: Image loaded successfully: $imageUrl');
                      return child;
                    }
                    print('SellerBannersDisplay: Loading image: $imageUrl');
                    return Center(
                        child: CircularProgressIndicator(strokeWidth: 2));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print(
                        'SellerBannersDisplay: Error loading image $imageUrl: $error');
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 24),
                            SizedBox(height: 4),
                            Text(
                              'Image failed to load',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Content below image
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.straighten, size: 12, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Dimensions: $dimensions',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Simple text approval status without any background or icons
                  Text(
                    'Status: ${approvalStatus ?? 'Pending'}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: _getApprovalStatusColor(approvalStatus),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getResponsiveImageHeight() {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return 120.0;
    } else if (screenWidth < 1200) {
      return 140.0;
    } else {
      return 160.0;
    }
  }

  Map<String, int> _getBannerStatusCounts(List<dynamic> banners) {
    Map<String, int> counts = {'approved': 0, 'pending': 0, 'rejected': 0};

    for (var banner in banners) {
      String status = (banner['Approval']?.toLowerCase() ?? 'pending');
      if (counts.containsKey(status)) {
        counts[status] = counts[status]! + 1;
      } else {
        counts['pending'] = counts['pending']! + 1;
      }
    }

    print('SellerBannersDisplay: Banner status counts: $counts');
    return counts;
  }

  Widget _buildStatusSummary(Map<String, int> statusCounts) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusCount('✓', statusCounts['approved']!, Colors.green),
          SizedBox(width: 6),
          _buildStatusCount('⏳', statusCounts['pending']!, Colors.orange),
          SizedBox(width: 6),
          _buildStatusCount('✗', statusCounts['rejected']!, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatusCount(String icon, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: TextStyle(
            fontSize: 10,
            color: color,
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerSection(
      String title, List<dynamic> banners, bool isMobile) {
    print(
        'SellerBannersDisplay: Building $title section with ${banners.length} banners');
    Map<String, int> statusCounts = _getBannerStatusCounts(banners);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                isMobile ? Icons.phone_android : Icons.desktop_windows,
                color: FlutterFlowTheme.of(context).primary,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${banners.length}',
                  style: TextStyle(
                    fontSize: 11,
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (banners.isNotEmpty) ...[
                SizedBox(width: 6),
                _buildStatusSummary(statusCounts),
              ],
            ],
          ),
        ),
        SizedBox(height: 8),
        banners.isEmpty
            ? Container(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'No $title found',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    return _buildBannerCard(banners[index], isMobile);
                  },
                ),
              ),
        SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        'SellerBannersDisplay: Building widget - isLoading: $isLoading, errorMessage: $errorMessage');

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: Card(
        elevation: 1.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(strokeWidth: 2),
                    SizedBox(height: 8),
                    Text(
                      'Loading banners...',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 8),
                        Text(
                          errorMessage!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _fetchBanners,
                          child: Text('Retry', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .primary
                                .withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Seller Banners',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                              Text(
                                widget.sellerEmail,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildBannerSection(
                            'Mobile Banners', mobileBanners, true),
                        _buildBannerSection(
                            'Desktop Banners', desktopBanners, false),
                      ],
                    ),
                  ),
      ),
    );
  }
}
