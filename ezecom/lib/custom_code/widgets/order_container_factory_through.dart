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

import 'dart:convert'; // For JSON decoding if needed

class OrderContainerFactoryThrough extends StatefulWidget {
  const OrderContainerFactoryThrough({
    super.key,
    this.width,
    this.height,
    required this.buyerEmail,
  });

  final double? width;
  final double? height;
  final String buyerEmail;

  @override
  State<OrderContainerFactoryThrough> createState() =>
      _OrderContainerFactoryThroughState();
}

class _OrderContainerFactoryThroughState
    extends State<OrderContainerFactoryThrough> {
  // Map to store grouped orders by Enquiry_ID
  Map<String, List<Map<String, dynamic>>> groupedOrders = {};
  bool isLoading = true;
  String errorMessage = '';

  // Responsive checks for mobile, tablet, and desktop
  bool get _isMobile => MediaQuery.of(context).size.width < 600;
  bool get _isTablet =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;
  bool get _isDesktop => MediaQuery.of(context).size.width >= 1024;

  @override
  void initState() {
    super.initState();
    debugPrint('OrderContainerFactoryThrough: initState called.');
    fetchOrderData(); // Fetch data when the widget initializes
  }

  // Function to fetch order data from Supabase
  Future<void> fetchOrderData() async {
    debugPrint('OrderContainerFactoryThrough: fetchOrderData called.');
    setState(() {
      isLoading = true;
      errorMessage = '';
      groupedOrders.clear(); // Clear previous data
    });

    try {
      // Query the Enquiry_Table_FactoryThrough table
      final orderResponse = await Supabase.instance.client
          .from('Enquiry_Table_FactoryThrough')
          .select('*')
          .eq('Buyer_Email', widget.buyerEmail) // Filter by buyer email
          .order('created_at', ascending: false); // Order by creation date

      if (orderResponse.isEmpty) {
        debugPrint(
            'OrderContainerFactoryThrough: No orders found for ${widget.buyerEmail}.');
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
          final productId = orderItem[
              'Product_Id']; // Get Product_Id from Enquiry_Table_FactoryThrough

          String imageUrl = ''; // Initialize imageUrl
          if (productId != null) {
            try {
              // Fetch product details from Products_Table using Product_Id
              final productResponse = await Supabase.instance.client
                  .from('Products_Table')
                  .select('ImageURL')
                  .eq('Product_id', productId)
                  .maybeSingle();

              if (productResponse != null) {
                final imageUrlRaw = productResponse['ImageURL'];
                if (imageUrlRaw != null) {
                  // Handle ImageURL being a List or a JSON string
                  if (imageUrlRaw is List && imageUrlRaw.isNotEmpty) {
                    imageUrl = imageUrlRaw[0]?.toString() ?? '';
                  } else if (imageUrlRaw is String) {
                    try {
                      final decoded = jsonDecode(imageUrlRaw);
                      if (decoded is List && decoded.isNotEmpty) {
                        imageUrl = decoded[0]?.toString() ?? '';
                      } else {
                        imageUrl = imageUrlRaw; // If it's a single string URL
                      }
                    } catch (_) {
                      imageUrl =
                          imageUrlRaw; // If JSON decoding fails, treat as single string
                    }
                  }
                }
              }
            } catch (e) {
              debugPrint(
                  'OrderContainerFactoryThrough: Error fetching product image for Product_Id $productId: $e');
            }
          }

          // Extract product details and calculate total price for the item
          final productName =
              orderItem['Product_Name']?.toString() ?? 'Unknown Product';
          final quantity = (orderItem['Quantity'] ?? 0).toDouble().toInt();
          final gstTotalPrice =
              (orderItem['GST_Total_Price'] ?? 0.0).toDouble();
          final paymentStatus =
              orderItem['Payment_Status']?.toString() ?? 'PENDING';
          final createdAt = orderItem['created_at']?.toString() ?? '';
          final isEmailSent = orderItem['is_email_sent'] ?? false; // New field

          // Prepare data for this order item
          final orderItemData = {
            'productName': productName,
            'quantity': quantity,
            'gstTotalPrice': gstTotalPrice,
            'enquiryId': enquiryId,
            'paymentStatus': paymentStatus,
            'createdAt': createdAt,
            'isEmailSent': isEmailSent, // Add to item data
            'imageUrl': imageUrl, // Add image URL to item data
          };

          // Group orders by Enquiry_ID
          if (!tempGroupedOrders.containsKey(enquiryId)) {
            tempGroupedOrders[enquiryId] = [];
          }
          tempGroupedOrders[enquiryId]!.add(orderItemData);
        } catch (e) {
          debugPrint(
              'OrderContainerFactoryThrough: Error processing order item: $e');
          continue; // Continue to next item even if one fails
        }
      }

      setState(() {
        groupedOrders = tempGroupedOrders;
        isLoading = false;
      });
      debugPrint(
          'OrderContainerFactoryThrough: Orders fetched and grouped successfully.');
    } catch (e) {
      debugPrint('OrderContainerFactoryThrough: Error fetching orders: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading orders: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'OrderContainerFactoryThrough: build called. isLoading: $isLoading, errorMessage: $errorMessage');
    return Container(
      width: widget.width,
      height: widget.height,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchOrderData, // Retry button
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : groupedOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'No orders found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh:
                          fetchOrderData, // Pull to refresh functionality
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

  // Builds a single container for a grouped enquiry
  Widget _buildOrderContainer(String enquiryId,
      List<Map<String, dynamic>> orderItems, BuildContext context) {
    debugPrint(
        'OrderContainerFactoryThrough: Building order container for Enquiry ID: $enquiryId');
    // Calculate the GrandTotal for this enquiry group
    double grandTotal =
        orderItems.fold(0.0, (sum, item) => sum + item['gstTotalPrice']);
    final firstItem = orderItems.first;
    final createdAt = firstItem['createdAt'];
    final paymentStatus = firstItem['paymentStatus']; // Use payment status

    String formattedDate = 'Unknown Date';
    if (createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        debugPrint('OrderContainerFactoryThrough: Error parsing date: $e');
      }
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
                        paymentStatus, grandTotal, orderItems)
                    : _buildDesktopHeader(enquiryId, formattedDate,
                        paymentStatus, grandTotal, orderItems),
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

  // Builds the mobile header for the order container
  Widget _buildMobileHeader(
      String enquiryId,
      String formattedDate,
      String paymentStatus,
      double grandTotal,
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
                  const SizedBox(height: 2),
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: _getPaymentStatusColor(paymentStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getPaymentStatusColor(paymentStatus),
                    width: 1,
                  ),
                ),
                child: Text(
                  paymentStatus.toUpperCase() == 'COMPLETED'
                      ? 'COMPLETED'
                      : 'FAILED',
                  style: TextStyle(
                    color: _getPaymentStatusColor(paymentStatus),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Second row: Total amount and button
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grand Total: \$${grandTotal.toStringAsFixed(2)}',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showFactoryDetails(
                    context, enquiryId, orderItems), // New function call
                icon: const Icon(Icons.info_outline, size: 14),
                label: const Text(
                  'View Details',
                  style: TextStyle(fontSize: 11),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
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

  // Builds the desktop header for the order container
  Widget _buildDesktopHeader(
      String enquiryId,
      String formattedDate,
      String paymentStatus,
      double grandTotal,
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
                  const SizedBox(height: 4),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getPaymentStatusColor(paymentStatus).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getPaymentStatusColor(paymentStatus),
                  width: 1,
                ),
              ),
              child: Text(
                paymentStatus.toUpperCase() == 'COMPLETED'
                    ? 'COMPLETED'
                    : 'FAILED',
                style: TextStyle(
                  color: _getPaymentStatusColor(paymentStatus),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Grand Total: \$${grandTotal.toStringAsFixed(2)}',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showFactoryDetails(
                  context, enquiryId, orderItems), // New function call
              icon: const Icon(Icons.info_outline, size: 16),
              label: const Text(
                'View Details',
                style: TextStyle(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  // Responsive order item for mobile view
  Widget _buildMobileOrderItem(
      Map<String, dynamic> item, BuildContext context) {
    debugPrint(
        'OrderContainerFactoryThrough: Building mobile order item for ${item['productName']}');
    final String imageUrl = item['imageUrl']?.toString() ?? '';
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product image or placeholder
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[200],
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    )
                  : const Icon(Icons.factory, color: Colors.grey, size: 20),
            ),
            const SizedBox(width: 8),
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
                  const SizedBox(height: 2),
                  Text(
                    'Enquiry ID: ${item['enquiryId']}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontSize: 9,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              'GST: \$${item['gstTotalPrice'].toStringAsFixed(2)}',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
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
          ],
        ),
        const SizedBox(height: 8), // Add some spacing between items
      ],
    );
  }

  // Responsive order item for desktop view
  Widget _buildDesktopOrderItem(
      Map<String, dynamic> item, BuildContext context) {
    debugPrint(
        'OrderContainerFactoryThrough: Building desktop order item for ${item['productName']}');
    final String imageUrl = item['imageUrl']?.toString() ?? '';
    return Column(
      children: [
        Row(
          children: [
            // Display product image or placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : const Icon(Icons.factory, color: Colors.grey),
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 4),
                  Text(
                    'Enquiry ID: ${item['enquiryId']}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontSize: 11,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${item['quantity']}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'GST: \$${item['gstTotalPrice'].toStringAsFixed(2)}',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8), // Add some spacing between items
      ],
    );
  }

  // Determines the color based on payment status
  Color _getPaymentStatusColor(String status) {
    return status.toUpperCase() == 'COMPLETED' ? Colors.green : Colors.red;
  }

  // Shows the new modal bottom sheet for Factory Through details
  void _showFactoryDetails(BuildContext context, String enquiryId,
      List<Map<String, dynamic>> orderItems) {
    debugPrint(
        'OrderContainerFactoryThrough: _showFactoryDetails called for Enquiry ID: $enquiryId');
    final firstItem = orderItems.first;
    final paymentStatus = firstItem['paymentStatus'];
    final isEmailSent =
        firstItem['isEmailSent'] ?? false; // Get is_email_sent status

    // Calculate Grand Total for display in the modal
    double modalGrandTotal =
        orderItems.fold(0.0, (sum, item) => sum + item['gstTotalPrice']);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.75, // Adjust height as needed
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Details (Factory Through)',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            IconButton(
                              onPressed: () {
                                debugPrint(
                                    'OrderContainerFactoryThrough: Closing modal.');
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        /// Order Info
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
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
                                'Enquiry ID: $enquiryId',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Payment Status: ${paymentStatus.toUpperCase() == 'COMPLETED' ? 'COMPLETED' : 'FAILED'}',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      color:
                                          _getPaymentStatusColor(paymentStatus),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Grand Total (Including GST): \$${modalGrandTotal.toStringAsFixed(2)}',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// Individual Product Details
                        Text(
                          'Product Details:',
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: orderItems.asMap().entries.map((entry) {
                            int idx = entry.key;
                            Map<String, dynamic> item = entry.value;
                            final String imageUrl =
                                item['imageUrl']?.toString() ?? '';
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .alternate
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    // Use Row to align image and text
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Display product image or placeholder
                                      Container(
                                        width:
                                            50, // Slightly larger for better visibility in modal
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.grey[200],
                                        ),
                                        child: imageUrl.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                    size: 24,
                                                  ),
                                                ),
                                              )
                                            : const Icon(Icons.factory,
                                                color: Colors.grey, size: 24),
                                      ),
                                      const SizedBox(
                                          width:
                                              10), // Spacing between image and text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Product: ${item['productName']}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                          fontWeight:
                                                              FontWeight.w500),
                                            ),
                                            Text(
                                              'Quantity: ${item['quantity']}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall,
                                            ),
                                            Text(
                                              'Individual GST Total: \$${item['gstTotalPrice'].toStringAsFixed(2)}',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Add a SizedBox only if it's not the last item
                                if (idx < orderItems.length - 1)
                                  const SizedBox(
                                      height:
                                          8.0), // Consistent spacing between product containers
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Conditionally show "View Manufacture Details" button
                        if (paymentStatus.toUpperCase() == 'COMPLETED')
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                debugPrint(
                                    'OrderContainerFactoryThrough: View Manufacture Details button pressed.');
                                if (isEmailSent) {
                                  debugPrint(
                                      'OrderContainerFactoryThrough: Navigating to viewManufacturePDF.');
                                  // Navigate to 'viewManufacturePDF' page
                                  context.pushNamed('viewManufacturePDF');
                                } else {
                                  debugPrint(
                                      'OrderContainerFactoryThrough: Showing "PDF is preparing" message via AlertDialog.');
                                  // Show "Your PDF is preparing" message via AlertDialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Text('PDF Preparation'),
                                        content: const Text(
                                            'Your PDF is preparing, please wait.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(); // Dismiss the dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              icon: const Icon(Icons.description),
                              label: const Text('View Manufacture Details'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    FlutterFlowTheme.of(context).tertiary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                              ),
                            ),
                          ),
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
}
