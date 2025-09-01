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

import 'dart:convert';

class OrderContainerAgentThrough extends StatefulWidget {
  const OrderContainerAgentThrough({
    super.key,
    this.width,
    this.height,
    required this.buyerEmail,
  });

  final double? width;
  final double? height;
  final String buyerEmail;

  @override
  State<OrderContainerAgentThrough> createState() =>
      _OrderContainerAgentThroughState();
}

class _OrderContainerAgentThroughState
    extends State<OrderContainerAgentThrough> {
  Map<String, List<Map<String, dynamic>>> groupedOrders = {};
  bool isLoading = true;
  String errorMessage = '';

  bool get _isMobile => MediaQuery.of(context).size.width < 600;
  bool get _isTablet =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;
  bool get _isDesktop => MediaQuery.of(context).size.width >= 1024;

  @override
  void initState() {
    super.initState();
    fetchOrderData();
  }

  Future<void> fetchOrderData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      groupedOrders.clear();
    });

    try {
      final orderResponse = await Supabase.instance.client
          .from('Enquiry_Table_AgentThrough')
          .select('*')
          .eq('Buyer_Mail', widget.buyerEmail)
          .order('created_at', ascending: false);

      if (orderResponse == null || orderResponse.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'No orders found for this email';
        });
        return;
      }

      Map<String, List<Map<String, dynamic>>> tempGroupedOrders = {};

      for (var orderItem in orderResponse) {
        try {
          final enquiryId = orderItem['Enquiry_ID']?.toString() ?? 'Unknown';

          String imageUrl = '';
          String category = '';
          double unitPrice = 0.0;

          final productId = orderItem['Product_id'];
          if (productId != null) {
            try {
              final productResponse = await Supabase.instance.client
                  .from('Products_Table')
                  .select('ImageURL, Category_Name, Price, Discounted_Price')
                  .eq('Product_id', productId)
                  .maybeSingle();

              if (productResponse != null) {
                final imageUrlRaw = productResponse['ImageURL'];
                if (imageUrlRaw != null) {
                  if (imageUrlRaw is List && imageUrlRaw.isNotEmpty) {
                    imageUrl = imageUrlRaw[0]?.toString() ?? '';
                  } else if (imageUrlRaw is String) {
                    try {
                      final decoded = jsonDecode(imageUrlRaw);
                      if (decoded is List && decoded.isNotEmpty) {
                        imageUrl = decoded[0]?.toString() ?? '';
                      } else {
                        imageUrl = imageUrlRaw;
                      }
                    } catch (_) {
                      imageUrl = imageUrlRaw;
                    }
                  }
                }

                category = productResponse['Category_Name']?.toString() ?? '';
                unitPrice = (productResponse['Discounted_Price'] ??
                        productResponse['Price'] ??
                        0.0)
                    .toDouble();
              }
            } catch (e) {}
          }

          final quantity = (orderItem['Quantity'] ?? 0).toDouble().toInt();
          final totalPrice = (orderItem['Total_Price'] ?? 0.0).toDouble();
          final createdAt = orderItem['created_at']?.toString() ?? '';
          final shippingStatus =
              orderItem['shipping_status']?.toString() ?? 'Pending';

          final orderItemData = {
            'productName':
                orderItem['Product_Name']?.toString() ?? 'Unknown Product',
            'quantity': quantity,
            'unitPrice': unitPrice,
            'totalPrice': totalPrice,
            'imageUrl': imageUrl,
            'category': category,
            'enquiryId': enquiryId,
            'shippingStatus': shippingStatus,
            'shippingMessage': orderItem['shipping_message']?.toString() ?? '',
            'createdAt': createdAt,
            'buyerName': orderItem['Buyer_Name']?.toString() ?? '',
            'sellerName': orderItem['Seller_Name']?.toString() ?? '',
            'status': orderItem['Status']?.toString() ?? '',
          };

          if (!tempGroupedOrders.containsKey(enquiryId)) {
            tempGroupedOrders[enquiryId] = [];
          }
          tempGroupedOrders[enquiryId]!.add(orderItemData);
        } catch (e) {
          continue;
        }
      }

      setState(() {
        groupedOrders = tempGroupedOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
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
                        onPressed: fetchOrderData,
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
                      onRefresh: fetchOrderData,
                      child: ListView.builder(
                        padding: EdgeInsets.all(_isMobile ? 12 : 16),
                        itemCount: groupedOrders.length,
                        itemBuilder: (context, index) {
                          final enquiryId = groupedOrders.keys.elementAt(index);
                          final orderItems = groupedOrders[enquiryId]!;
                          return _buildOrderContainer(
                              enquiryId, orderItems, context);
                        },
                      ),
                    ),
    );
  }

  Widget _buildOrderContainer(String enquiryId,
      List<Map<String, dynamic>> orderItems, BuildContext context) {
    double totalEnquiryAmount =
        orderItems.fold(0.0, (sum, item) => sum + item['totalPrice']);
    final firstItem = orderItems.first;
    final createdAt = firstItem['createdAt'];
    final shippingStatus = firstItem['shippingStatus'];

    String formattedDate = 'Unknown Date';
    if (createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {}
    }

    return Container(
      margin: EdgeInsets.only(bottom: _isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(_isMobile ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with enquiry details
          Container(
            padding: EdgeInsets.all(_isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_isMobile ? 12 : 16),
                topRight: Radius.circular(_isMobile ? 12 : 16),
              ),
            ),
            child: Column(
              children: [
                // Responsive header
                _isMobile
                    ? _buildMobileHeader(enquiryId, formattedDate,
                        shippingStatus, totalEnquiryAmount, orderItems)
                    : _buildDesktopHeader(enquiryId, formattedDate,
                        shippingStatus, totalEnquiryAmount, orderItems),
              ],
            ),
          ),

          // Product items
          Padding(
            padding: EdgeInsets.all(_isMobile ? 12 : 16),
            child: Column(
              children: orderItems
                  .map((item) => _isMobile
                      ? _buildMobileOrderItem(item, context)
                      : _buildDesktopOrderItem(item, context))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader(
      String enquiryId,
      String formattedDate,
      String shippingStatus,
      double totalEnquiryAmount,
      List<Map<String, dynamic>> orderItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First row: Order ID and Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #$enquiryId',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Date: $formattedDate',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontSize: 10,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      _getShippingStatusColor(shippingStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getShippingStatusColor(shippingStatus),
                    width: 1,
                  ),
                ),
                child: Text(
                  shippingStatus,
                  style: TextStyle(
                    color: _getShippingStatusColor(shippingStatus),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Second row: Total amount and button
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: \$${totalEnquiryAmount.toStringAsFixed(2)}',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    _showShippingDetails(context, enquiryId, orderItems),
                icon: Icon(Icons.local_shipping, size: 14),
                label: Text(
                  'Shipping Details',
                  style: TextStyle(fontSize: 11),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(
      String enquiryId,
      String formattedDate,
      String shippingStatus,
      double totalEnquiryAmount,
      List<Map<String, dynamic>> orderItems) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #$enquiryId',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Date: $formattedDate',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontSize: 12,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getShippingStatusColor(shippingStatus).withOpacity(0.1),
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
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount: \$${totalEnquiryAmount.toStringAsFixed(2)}',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  _showShippingDetails(context, enquiryId, orderItems),
              icon: Icon(Icons.local_shipping, size: 16),
              label: Text(
                'Shipping Details',
                style: TextStyle(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Responsive order item
  Widget _buildMobileOrderItem(
      Map<String, dynamic> item, BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[200],
              ),
              child: item['imageUrl'].toString().isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        item['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    )
                  : const Icon(Icons.shopping_bag,
                      color: Colors.grey, size: 20),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['productName'],
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item['category'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item['category'],
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontSize: 9,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '\$${item['totalPrice'].toStringAsFixed(2)}',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Qty: ${item['quantity']}',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                  ),
            ),
            if (item['unitPrice'] > 0)
              Text(
                'Unit: \$${item['unitPrice'].toStringAsFixed(2)}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontSize: 9,
                    ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopOrderItem(
      Map<String, dynamic> item, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: item['imageUrl'].toString().isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                )
              : const Icon(Icons.shopping_bag, color: Colors.grey),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['productName'],
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (item['category'].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    item['category'],
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontSize: 11,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Qty: ${item['quantity']}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                  ),
                  SizedBox(width: 12),
                  if (item['unitPrice'] > 0)
                    Text(
                      'Unit: \$${item['unitPrice'].toStringAsFixed(2)}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontSize: 11,
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${item['totalPrice'].toStringAsFixed(2)}',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getShippingStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
      case 'in transit':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showShippingDetails(BuildContext context, String enquiryId,
      List<Map<String, dynamic>> orderItems) {
    final firstItem = orderItems.first;
    final shippingStatus = firstItem['shippingStatus'];
    final shippingMessage = firstItem['shippingMessage'] ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.75,
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
                        /// Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping Details',
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

                        /// Order Info
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .info
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
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
                                'Current Status: $shippingStatus',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                              ),
                              if (firstItem['buyerName'].isNotEmpty) ...[
                                SizedBox(height: 4),
                                Text(
                                  'Buyer: ${firstItem['buyerName']}',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                              // 👇 Removed Seller Name
                            ],
                          ),
                        ),
                        SizedBox(height: 24),

                        /// Shipping Progress
                        SizedBox(
                          width: constraints.maxWidth,
                          child:
                              _buildShippingProgress(context, shippingStatus),
                        ),
                        SizedBox(height: 24),

                        /// Shipping Message
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
                                  'Shipping Message:',
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

    if (currentIndex == -1) {
      if (normalizedCurrentStatus.contains('ready') ||
          normalizedCurrentStatus.contains('processing')) {
        currentIndex = 0;
      } else if (normalizedCurrentStatus.contains('ship')) {
        currentIndex = 1;
      } else if (normalizedCurrentStatus.contains('delivery') ||
          normalizedCurrentStatus.contains('transit')) {
        currentIndex = 2;
      } else if (normalizedCurrentStatus.contains('deliver')) {
        currentIndex = 3;
      }
    }

    // Dynamically set label and connector width for small screens
    double screenWidth = MediaQuery.of(context).size.width;
    double labelWidth;
    double connectorWidth;
    double iconSize;
    double circleSize;
    double fontSize;

    if (screenWidth <= 375) {
      labelWidth = 55;
      connectorWidth = 12;
      iconSize = 14;
      circleSize = 24;
      fontSize = 9;
    } else if (screenWidth < 390) {
      labelWidth = 70;
      connectorWidth = 20;
      iconSize = 18;
      circleSize = 32;
      fontSize = 10;
    } else {
      labelWidth = 100;
      connectorWidth = 40;
      iconSize = 18;
      circleSize = 32;
      fontSize = 10;
    }

    return Container(
      padding: EdgeInsets.all(8), // Reduce padding for small screens
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Package arrived at a carrier facility.',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < statuses.length; i++) ...[
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i <= currentIndex
                          ? FlutterFlowTheme.of(context).primary
                          : Colors.grey[300],
                    ),
                    child: Icon(
                      statuses[i]['icon'],
                      size: iconSize,
                      color:
                          i <= currentIndex ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  if (i < statuses.length - 1)
                    Container(
                      width: connectorWidth,
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: i < currentIndex
                            ? FlutterFlowTheme.of(context).primary
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ],
            ),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < statuses.length; i++) ...[
                  Container(
                    width: labelWidth,
                    alignment: Alignment.center,
                    child: Text(
                      statuses[i]['label'],
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontSize: fontSize,
                            fontWeight: i == currentIndex
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: i <= currentIndex
                                ? FlutterFlowTheme.of(context).primaryText
                                : Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
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
}
