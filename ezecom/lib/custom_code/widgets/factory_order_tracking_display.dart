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

import 'dart:convert';

class FactoryOrderTrackingDisplay extends StatefulWidget {
  const FactoryOrderTrackingDisplay({
    super.key,
    this.width,
    this.height,
    this.buyerEmail,
    this.enquiryIds,
  });

  final double? width;
  final double? height;
  final String? buyerEmail;
  final List<String>? enquiryIds;

  @override
  State<FactoryOrderTrackingDisplay> createState() =>
      _FactoryOrderTrackingDisplayState();
}

class _FactoryOrderTrackingDisplayState
    extends State<FactoryOrderTrackingDisplay> {
  Map<String, List<Map<String, dynamic>>> groupedOrders = {};
  bool isLoading = true;
  bool isLoadingMore = false;
  String errorMessage = '';
  int currentPage = 0;
  final int pageSize = 10;
  bool hasMoreData = true;

  final ScrollController _scrollController = ScrollController();

  bool get _isMobile => MediaQuery.of(context).size.width < 600;
  bool get _isTablet =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;
  bool get _isDesktop => MediaQuery.of(context).size.width >= 1024;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Use post-frame callback for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOrderData(reset: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FactoryOrderTrackingDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.buyerEmail != oldWidget.buyerEmail ||
        !listEquals(widget.enquiryIds, oldWidget.enquiryIds)) {
      fetchOrderData(reset: true);
    }
  }

  bool listEquals(List<String>? list1, List<String>? list2) {
    if (list1 == list2) {
      return true;
    }
    if (list1 == null || list2 == null) {
      return false;
    }
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  void _scrollListener() {
    if ((widget.enquiryIds == null || widget.enquiryIds!.isEmpty) &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      if (!isLoadingMore && hasMoreData) {
        fetchOrderData(reset: false);
      }
    }
  }

  String getImageUrl(dynamic imageData) {
    if (imageData == null) return '';

    String url = imageData.toString();

    // Remove brackets and quotes if they exist
    url =
        url.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').trim();

    // Make sure it starts with http
    if (url.isNotEmpty && !url.startsWith('http')) {
      url = 'https://' + url;
    }

    return url;
  }

  IconData _getPaymentStatusIcon(String paymentStatus) {
    switch (paymentStatus.toUpperCase()) {
      case 'COMPLETED':
        return Icons.check_circle;
      case 'FAILED':
        return Icons.error;
      case 'PENDING':
      default:
        return Icons.schedule;
    }
  }

  Future<void> fetchOrderData({bool reset = false}) async {
    if (reset) {
      setState(() {
        isLoading = true;
        errorMessage = '';
        groupedOrders.clear();
        currentPage = 0;
        hasMoreData = true;
      });
    } else {
      setState(() {
        isLoadingMore = true;
      });
    }

    try {
      dynamic requestBody;

      if (widget.enquiryIds != null && widget.enquiryIds!.isNotEmpty) {
        requestBody = {
          'enquiryIds': widget.enquiryIds!.take(5).toList(),
          'limit_fields': true,
        };
      } else if (widget.buyerEmail != null && widget.buyerEmail!.isNotEmpty) {
        requestBody = {
          'auth_id': widget.buyerEmail,
          'page': currentPage,
          'page_size': 5,
          'limit_fields': true,
        };
      } else {
        setState(() {
          isLoading = false;
          isLoadingMore = false;
          errorMessage = 'No buyer email or enquiry IDs provided.';
        });
        return;
      }

      final response = await Supabase.instance.client.functions.invoke(
        'FACTORY-ORDERS',
        body: requestBody,
      );

      if (response.data == null) {
        setState(() {
          isLoading = false;
          isLoadingMore = false;
          errorMessage = 'No response from server';
        });
        return;
      }

      final data = response.data as Map<String, dynamic>;
      final orders = data['orders'] as List<dynamic>? ?? [];
      final hasMore = data['has_more'] as bool? ?? false;

      if (orders.isEmpty && reset) {
        setState(() {
          isLoading = false;
          isLoadingMore = false;
          errorMessage = 'No orders found.';
        });
        return;
      }

      Map<String, List<Map<String, dynamic>>> newGroupedOrders = {};
      if (!reset) {
        newGroupedOrders = Map.from(groupedOrders);
      }

      for (var orderData in orders) {
        final enquiryId = orderData['enquiry_id']?.toString() ?? 'Unknown';
        final orderItems = orderData['items'] as List<dynamic>? ?? [];

        List<Map<String, dynamic>> processedItems = [];
        for (var item in orderItems) {
          String imageUrl = item['imageUrl']?.toString() ?? '';
          final productId = item['Product_Id'];

          if (productId != null) {
            try {
              final productResponse = await Supabase.instance.client
                  .from('Products_Table')
                  .select('ImageURL')
                  .eq('Product_id', productId)
                  .limit(1)
                  .maybeSingle();

              if (productResponse != null) {
                final imageUrlRaw = productResponse['ImageURL'];

                // if (imageUrlRaw != null) {
                //   if (imageUrlRaw is List && imageUrlRaw.isNotEmpty) {
                //     imageUrl = imageUrlRaw[0]?.toString() ?? '';
                //   } else if (imageUrlRaw is String) {
                //     try {
                //       final decoded = jsonDecode(imageUrlRaw);
                //       if (decoded is List && decoded.isNotEmpty) {
                //         imageUrl = decoded[0]?.toString() ?? '';
                //       } else {
                //         imageUrl = imageUrlRaw;
                //       }
                //     } catch (_) {
                //       imageUrl = imageUrlRaw;
                //     }
                //   }
                // }
                String imageUrl = getImageUrl(item['imageUrl']);
              }
            } catch (e) {
              print(
                  '❌ [DEBUG] Error fetching product image for Product_Id $productId: $e');
            }
          }

          // Validate and clean image URL
          if (imageUrl.isNotEmpty) {
            imageUrl = imageUrl.trim().replaceAll('"', '');

            try {
              final uri = Uri.parse(imageUrl);
              if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
                imageUrl = '';
              }
            } catch (e) {
              imageUrl = '';
            }
          }

          final isEmailSent = item['is_email_sent'] ?? false;
          final paymentStatus = item['Payment_Status']?.toString();
          print('📧 [DEBUG] Email sent status: $isEmailSent');
          print('💳 [DEBUG] Payment status: $paymentStatus');

          processedItems.add({
            'productName': item['productName']?.toString() ?? 'Unknown Product',
            'quantity': (item['quantity'] ?? 0).toInt(),
            'unitPrice': (item['unitPrice'] ?? 0.0).toDouble(),
            'totalPrice': (item['totalPrice'] ?? 0.0).toDouble(),
            'imageUrl': imageUrl,
            'category': item['category']?.toString() ?? '',
            'enquiryId': enquiryId,
            'shippingStatus': item['shippingStatus']?.toString() ?? 'Pending',
            'shippingMessage': item['shippingMessage']?.toString() ?? '',
            'createdAt': item['createdAt']?.toString() ?? '',
            'buyerName': item['buyerName']?.toString() ?? '',
            'sellerName': item['sellerName']?.toString() ?? '',
            'status': item['status']?.toString() ?? '',
            'isEmailSent': isEmailSent,
            'paymentStatus': paymentStatus,
          });
        }

        if (processedItems.isNotEmpty) {
          if (newGroupedOrders.containsKey(enquiryId)) {
            newGroupedOrders[enquiryId]!.addAll(processedItems);
          } else {
            newGroupedOrders[enquiryId] = processedItems;
          }
        }
      }

      // Sort orders by date (latest first)
      Map<String, List<Map<String, dynamic>>> sortedGroupedOrders =
          Map.fromEntries(newGroupedOrders.entries.toList()
            ..sort((a, b) {
              final aDate = a.value.first['createdAt'];
              final bDate = b.value.first['createdAt'];

              if (aDate.isEmpty || bDate.isEmpty) return 0;

              try {
                final dateA = DateTime.parse(aDate);
                final dateB = DateTime.parse(bDate);
                return dateB.compareTo(dateA);
              } catch (e) {
                return 0;
              }
            }));

      setState(() {
        groupedOrders = sortedGroupedOrders;
        isLoading = false;
        isLoadingMore = false;
        hasMoreData = hasMore;
        if (widget.enquiryIds == null || widget.enquiryIds!.isEmpty) {
          currentPage++;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
        errorMessage = 'Error loading orders: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          fetchOrderData(reset: true);
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : groupedOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No orders found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () {
                        return fetchOrderData(reset: true);
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(_isMobile ? 12 : 16),
                        itemCount: groupedOrders.length +
                            (hasMoreData &&
                                    (widget.enquiryIds == null ||
                                        widget.enquiryIds!.isEmpty)
                                ? 1
                                : 0),
                        itemBuilder: (context, index) {
                          if (index == groupedOrders.length &&
                              hasMoreData &&
                              (widget.enquiryIds == null ||
                                  widget.enquiryIds!.isEmpty)) {
                            return _buildLoadingIndicator();
                          }

                          final enquiryId = groupedOrders.keys.elementAt(index);
                          final orderItems = groupedOrders[enquiryId]!;

                          return _buildOrderContainer(
                              enquiryId, orderItems, context);
                        },
                      ),
                    ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: isLoadingMore
          ? Column(
              children: [
                CircularProgressIndicator(strokeWidth: 2),
                SizedBox(height: 8),
                Text(
                  'Loading more orders...',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildOrderContainer(String enquiryId,
      List<Map<String, dynamic>> orderItems, BuildContext context) {
    double totalEnquiryAmount = orderItems.fold(
        0.0, (sum, item) => sum + (item['unitPrice'] * item['quantity']));
    final firstItem = orderItems.first;
    final createdAt = firstItem['createdAt'];
    final shippingStatus = firstItem['shippingStatus'];
    final isEmailSent = firstItem['isEmailSent'] ?? false;
    final paymentStatus = firstItem['paymentStatus'] ?? 'PENDING';

    String formattedDate = 'Unknown Date';
    if (createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        // Keep default value
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order # $enquiryId',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFFF065A),
                            ),
                          ),
                          SizedBox(height: 8),
                          // Payment Status
                          Row(
                            children: [
                              Icon(
                                _getPaymentStatusIcon(paymentStatus),
                                color: _getPaymentStatusColor(paymentStatus),
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Payment Status: $paymentStatus',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: _getPaymentStatusColor(paymentStatus),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Products List
          Container(
            color: Colors.grey.shade50,
            child: Column(
              children:
                  orderItems.map((item) => _buildProductItem(item)).toList(),
            ),
          ),

          // Footer with total, tracking, and conditional buttons
          // Footer with total, tracking, and payment/email status
          // Footer with total, tracking, and payment/email status
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      '\$${totalEnquiryAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2868FF),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Conditional UI based on Payment Status
                if (paymentStatus.toUpperCase() == 'FAILED') ...[
                  // Case 1: Payment FAILED - Just show status, no button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red.shade600,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Payment Failed',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (paymentStatus.toUpperCase() == 'COMPLETED') ...[
                  // Case 2: Payment COMPLETED - Show button based on email status
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print(
                            '📧 [DEBUG] Email status button pressed for enquiry: $enquiryId');
                        print('📧 [DEBUG] Email sent status: $isEmailSent');

                        if (isEmailSent) {
                          _showFactoryDetailsSentDialog(context);
                        } else {
                          _showEmailPendingDialog(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEmailSent
                            ? Colors.green.shade600
                            : Colors.amber.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEmailSent ? Icons.check_circle : Icons.schedule,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            isEmailSent
                                ? 'Factory Details Sent'
                                : 'You will receive email shortly',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Case 3: Payment PENDING - Show pending status, no button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.amber.shade600,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Payment Pending',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: _buildImageWidget(item),
          ),
          SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['productName'] ?? 'Unknown Product',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Qty: ${item['quantity']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${item['totalPrice'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF065A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, String enquiryId,
      List<Map<String, dynamic>> orderItems) {
    final firstItem = orderItems.first;
    final shippingStatus = firstItem['shippingStatus'];
    final isEmailSent = firstItem['isEmailSent'] ?? false;
    double totalEnquiryAmount =
        orderItems.fold(0.0, (sum, item) => sum + item['totalPrice']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF065A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #$enquiryId',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Current Status: $shippingStatus',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (firstItem['buyerName'].isNotEmpty) ...[
                            SizedBox(height: 4),
                            Text(
                              'Buyer: ${firstItem['buyerName']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Email Status Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isEmailSent
                            ? Colors.green.shade50
                            : Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isEmailSent
                              ? Colors.green.shade200
                              : Colors.amber.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isEmailSent ? Icons.check_circle : Icons.schedule,
                            color: isEmailSent
                                ? Colors.green.shade600
                                : Colors.amber.shade600,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isEmailSent
                                      ? 'Email Confirmation Sent'
                                      : 'Email Confirmation Pending',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isEmailSent
                                        ? Colors.green.shade700
                                        : Colors.amber.shade700,
                                  ),
                                ),
                                if (!isEmailSent) ...[
                                  SizedBox(height: 2),
                                  Text(
                                    'You will receive confirmation within 24 hours',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.amber.shade600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Shipping Progress
                    Text(
                      'Shipping Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildShippingProgress(context, shippingStatus),

                    SizedBox(height: 24),

                    // Product Details
                    Text(
                      'Product Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),

                    ...orderItems
                        .map((item) => Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: _buildImageWidget(item),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['productName'] ??
                                              'Unknown Product',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Quantity: ${item['quantity']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          'Price: \$${item['totalPrice'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFF065A),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),

                    SizedBox(height: 24),

                    // Total Amount
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF065A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Color(0xFFFF065A).withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '\$${totalEnquiryAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF065A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingProgress(BuildContext context, String currentStatus) {
    final List<Map<String, dynamic>> statuses = [
      {
        'label': 'Ready to ship',
        'value': 'ready to ship',
        'icon': Icons.inventory
      },
      {'label': 'Shipped', 'value': 'shipped', 'icon': Icons.local_shipping},
      {
        'label': 'Out for delivery',
        'value': 'out for delivery',
        'icon': Icons.delivery_dining
      },
      {'label': 'Delivered', 'value': 'delivered', 'icon': Icons.check_circle},
    ];

    final normalizedCurrentStatus = currentStatus.toLowerCase().trim();

    int currentIndex = -1;
    for (int i = 0; i < statuses.length; i++) {
      if (statuses[i]['value'] == normalizedCurrentStatus) {
        currentIndex = i;
        break;
      }
    }

    return Column(
      children: statuses.asMap().entries.map((entry) {
        int idx = entry.key;
        Map<String, dynamic> status = entry.value;
        bool isActive = idx <= currentIndex;
        Color color =
            isActive ? _getShippingStatusColor(status['value']) : Colors.grey;
        Color textColor = isActive
            ? FlutterFlowTheme.of(context).primaryText
            : FlutterFlowTheme.of(context).secondaryText;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(status['icon'], color: color, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  status['label'],
                  style: FlutterFlowTheme.of(context)
                      .bodyMedium
                      .override(color: textColor),
                ),
              ),
              if (idx < statuses.length - 1)
                Container(
                  height: 2,
                  width: 20,
                  color: isActive && idx + 1 <= currentIndex
                      ? color
                      : Colors.grey.withOpacity(0.5),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getShippingStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
      case 'in transit':
      case 'out for delivery':
        return Colors.blue;
      case 'processing':
      case 'ready to ship':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'order confirmed':
        return Colors.purple;
      case 'order initiated':
        return Colors.blueGrey;
      case 'order ongoing':
        return Colors.teal;
      case 'open':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  void _showEmailPendingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: Colors.amber.shade600,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Email Notification',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your order confirmation email is being processed.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber.shade700,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You will receive the confirmation email within 24 hours.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Please check your inbox and spam folder for updates.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Got it',
                style: TextStyle(
                  color: Colors.amber.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFactoryDetailsSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.factory,
                color: Colors.green.shade600,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Factory Details Sent',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The factory details have been successfully sent to your registered email address.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.shade200,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Email delivered successfully with complete factory information.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Please check your inbox for the detailed factory information and contact details.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Understood',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getPaymentStatusColor(String paymentStatus) {
    switch (paymentStatus.toUpperCase()) {
      case 'COMPLETED':
        return Colors.green.shade600;
      case 'FAILED':
        return Colors.red.shade600;
      case 'PENDING':
      default:
        return Colors.amber.shade600;
    }
  }

  Widget _buildImageWidget(Map<String, dynamic> item) {
    String imageUrl = getImageUrl(item['imageUrl']);

    print('Image URL: $imageUrl'); // This helps you debug

    if (imageUrl.isEmpty) {
      return Icon(Icons.image_not_supported, size: 50); // Show when no image
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.broken_image, size: 50); // Show when image fails
      },
    );
  }

  Widget _buildNoImagePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade500,
            size: 24,
          ),
          Text(
            'No Image',
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
