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

// import 'index.dart'; // Imports other custom widgets

import 'dart:convert';

class OrderTrackingDisplay extends StatefulWidget {
  const OrderTrackingDisplay({
    super.key,
    this.width,
    this.height,
    required this.buyerEmail,
  });

  final double? width;
  final double? height;
  final String buyerEmail;

  @override
  State<OrderTrackingDisplay> createState() => _OrderTrackingDisplayState();
}

class _OrderTrackingDisplayState extends State<OrderTrackingDisplay> {
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
    fetchOrderData(reset: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoadingMore && hasMoreData) {
        fetchOrderData(reset: false);
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'order initiated':
        return Colors.blue;
      case 'order ongoing':
      case 'order ongoing':
        return Colors.orange;
      case 'order confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  int _getCurrentStageIndex(List<Map<String, dynamic>> stages,
      String orderStatus, String shippingStatus) {
    final normalizedOrderStatus = orderStatus.toLowerCase().trim();
    final normalizedShippingStatus = shippingStatus.toLowerCase().trim();

    // Check shipping status first if order is confirmed
    if (normalizedOrderStatus == 'order confirmed') {
      for (int i = stages.length - 1; i >= 0; i--) {
        if (stages[i]['type'] == 'shipping' &&
            stages[i]['value'] == normalizedShippingStatus) {
          return i;
        }
      }
      // If no shipping status found, return "Order Confirmed" stage
      for (int i = 0; i < stages.length; i++) {
        if (stages[i]['value'] == 'order confirmed') {
          return i;
        }
      }
    }

    // Check order status
    for (int i = 0; i < stages.length; i++) {
      if (stages[i]['value'] == normalizedOrderStatus) {
        return i;
      }
    }

    return -1;
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
      final response = await Supabase.instance.client.functions.invoke(
        'AGENT-ORDERS',
        body: {
          'buyer_email': widget.buyerEmail,
          'page': currentPage,
          'page_size': pageSize,
        },
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
          errorMessage = 'No orders found for this email';
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
          processedItems.add({
            'productName':
                item['product_name']?.toString() ?? 'Unknown Product',
            'quantity': (item['quantity'] ?? 0).toInt(),
            'unitPrice': (item['unit_price'] ?? 0.0).toDouble(),
            'totalPrice': (item['total_price'] ?? 0.0).toDouble(),
            'imageUrl': item['image_url']?.toString() ?? '',
            'category': item['category']?.toString() ?? '',
            'enquiryId': enquiryId,
            'shippingStatus':
                orderData['shipping_status']?.toString() ?? 'Pending',
            'shippingMessage': orderData['shipping_message']?.toString() ?? '',
            'createdAt': orderData['created_at']?.toString() ?? '',
            'buyerName': orderData['buyer_name']?.toString() ?? '',
            'sellerName': orderData['seller_name']?.toString() ?? '',
            'status': orderData['status']?.toString() ?? '',
            'showTracking': orderData['show_tracking'] ?? false,
          });
        }

        if (processedItems.isNotEmpty) {
          newGroupedOrders[enquiryId] = processedItems;
        }
      }

      setState(() {
        groupedOrders = newGroupedOrders;
        isLoading = false;
        isLoadingMore = false;
        hasMoreData = hasMore;
        currentPage++;
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
                        onPressed: () => fetchOrderData(reset: true),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ]),
                    )
                  : RefreshIndicator(
                      onRefresh: () => fetchOrderData(reset: true),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(_isMobile ? 12 : 16),
                        itemCount: groupedOrders.length + (hasMoreData ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == groupedOrders.length) {
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

  Widget _buildProgressStep(BuildContext context, Map<String, dynamic> stage,
      bool isCompleted, bool isCurrent, bool hasNext) {
    Color iconColor = isCompleted ? Colors.green : Colors.grey;
    Color textColor = isCompleted
        ? FlutterFlowTheme.of(context).primaryText
        : FlutterFlowTheme.of(context).secondaryText;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Circle with icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              border: Border.all(
                color: iconColor,
                width: 2,
              ),
            ),
            child: Icon(stage['icon'], color: iconColor, size: 20),
          ),
          SizedBox(width: 16),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage['label'],
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: textColor,
                        fontWeight:
                            isCurrent ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
                if (isCurrent)
                  Text(
                    'Current Status',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          color: Colors.green,
                          fontSize: 11,
                        ),
                  ),
              ],
            ),
          ),

          // Green tick mark on right side
          if (isCompleted)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
        ],
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
    double totalEnquiryAmount =
        orderItems.fold(0.0, (sum, item) => sum + item['totalPrice']);
    final firstItem = orderItems.first;
    final createdAt = firstItem['createdAt'];
    final shippingStatus = firstItem['shippingStatus'];
    final status = firstItem['status'] ?? '';
    final showTracking = firstItem['showTracking'] ?? false;

    String formattedDate = 'Unknown Date';
    if (createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {}
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
          // Header with Status
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
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
                    ],
                  ),
                ),
                // Status Display
                if (status.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(status),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

          // Footer with total and button
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${totalEnquiryAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004CFF),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getShippingStatusColor(shippingStatus)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getShippingStatusColor(shippingStatus),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        shippingStatus,
                        style: TextStyle(
                          color: _getShippingStatusColor(shippingStatus),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Conditionally show Track Order button
                if (showTracking)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          _showShippingDetails(context, enquiryId, orderItems),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF004CFF),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Track Order',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> item) {
    final imageUrl = item['imageUrl']?.toString() ?? '';

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
          // Product Image with improved loading
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Image loading error for URL: $imageUrl');
                          print('Error details: $error');
                          return Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade500,
                            size: 30,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.grey.shade500,
                      size: 30,
                    ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['productName'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Qty: ${item['quantity']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 60),
                    Text(
                      'Unit Price: \$${item['unitPrice'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

  void _showShippingDetails(BuildContext context, String enquiryId,
      List<Map<String, dynamic>> orderItems) {
    final firstItem = orderItems.first;
    final shippingStatus = firstItem['shippingStatus'];
    final shippingMessage = firstItem['shippingMessage'] ?? '';
    final buyerName = firstItem['buyerName'] ?? '';
    final sellerName = firstItem['sellerName'] ?? '';
    final overallStatus = firstItem['status'] ?? 'Unknown';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85,
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Tracking',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Order Info
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .info
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #$enquiryId',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Current Status: $overallStatus',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      color: _getStatusColor(overallStatus),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              if (buyerName.isNotEmpty) ...[
                                SizedBox(height: 4),
                                Text(
                                  'Buyer: $buyerName',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                              if (sellerName.isNotEmpty) ...[
                                SizedBox(height: 4),
                                Text(
                                  'Seller: $sellerName',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 24),

                        // Complete Order Tracking Progress
                        Text(
                          'Order Progress',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        _buildCompleteOrderProgress(
                            context, overallStatus, shippingStatus),

                        SizedBox(height: 24),

                        // Shipping Message
                        if (shippingMessage.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .alternate
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Additional Information:',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontWeight: FontWeight.w600,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  shippingMessage,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteOrderProgress(BuildContext context,
      String currentOrderStatus, String currentShippingStatus) {
    // Normalize the status values
    final orderStatus = currentOrderStatus.toLowerCase().trim();
    final shippingStatus = currentShippingStatus.toLowerCase().trim();

    return Column(
      children: [
        // Order Initiated
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Icon(Icons.receipt_long, color: Colors.green, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Order Initiated',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
              if (orderStatus == 'order initiated' ||
                  orderStatus == 'order ongoing' ||
                  orderStatus == 'order confirmed')
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),

        // Order Undergoing
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (orderStatus == 'order ongoing' ||
                          orderStatus == 'order confirmed')
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  border: Border.all(
                      color: (orderStatus == 'order ongoing' ||
                              orderStatus == 'order confirmed')
                          ? Colors.green
                          : Colors.grey,
                      width: 2),
                ),
                child: Icon(Icons.hourglass_empty,
                    color: (orderStatus == 'order ongoing' ||
                            orderStatus == 'order confirmed')
                        ? Colors.green
                        : Colors.grey,
                    size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Order ongoing',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
              if (orderStatus == 'order ongoing' ||
                  orderStatus == 'order confirmed')
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),

        // Order Confirmed
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orderStatus == 'order confirmed'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  border: Border.all(
                      color: orderStatus == 'order confirmed'
                          ? Colors.green
                          : Colors.grey,
                      width: 2),
                ),
                child: Icon(Icons.check_circle,
                    color: orderStatus == 'order confirmed'
                        ? Colors.green
                        : Colors.grey,
                    size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Order Confirmed',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
              if (orderStatus == 'order confirmed')
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),

        SizedBox(height: 16),
        Divider(color: Colors.grey.withOpacity(0.3)),
        SizedBox(height: 8),

        // Ready to Ship
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: shippingStatus == 'ready to ship'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  border: Border.all(
                      color: shippingStatus == 'ready to ship'
                          ? Colors.green
                          : Colors.grey,
                      width: 2),
                ),
                child: Icon(Icons.inventory,
                    color: shippingStatus == 'ready to ship'
                        ? Colors.green
                        : Colors.grey,
                    size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Ready to Ship',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
              if (shippingStatus == 'ready to ship')
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),

        // Shipped
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: shippingStatus == 'shipped'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  border: Border.all(
                      color: shippingStatus == 'shipped'
                          ? Colors.green
                          : Colors.grey,
                      width: 2),
                ),
                child: Icon(Icons.local_shipping,
                    color: shippingStatus == 'shipped'
                        ? Colors.green
                        : Colors.grey,
                    size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Shipped',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
              if (shippingStatus == 'shipped')
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),

        // Out for Delivery
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: shippingStatus == 'out for delivery'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  border: Border.all(
                      color: shippingStatus == 'out for delivery'
                          ? Colors.green
                          : Colors.grey,
                      width: 2),
                ),
                child: Icon(Icons.delivery_dining,
                    color: shippingStatus == 'out for delivery'
                        ? Colors.green
                        : Colors.grey,
                    size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Out for Delivery',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
              if (shippingStatus == 'out for delivery')
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),

        // Delivered
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: shippingStatus == 'delivered'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  border: Border.all(
                      color: shippingStatus == 'delivered'
                          ? Colors.green
                          : Colors.grey,
                      width: 2),
                ),
                child: Icon(Icons.check_circle,
                    color: shippingStatus == 'delivered'
                        ? Colors.green
                        : Colors.grey,
                    size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Delivered',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ),
              if (shippingStatus == 'delivered')
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),
      ],
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
                  width: 20, // Small line between icons
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
}
