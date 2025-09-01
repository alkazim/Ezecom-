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

class EnquiryContainer extends StatefulWidget {
  const EnquiryContainer({
    super.key,
    this.width,
    this.height,
    required this.enquiryId,
  });

  final double? width;
  final double? height;
  final String enquiryId;

  @override
  State<EnquiryContainer> createState() => _EnquiryContainerState();
}

class _EnquiryContainerState extends State<EnquiryContainer> {
  List<Map<String, dynamic>> enquiryItems = [];
  bool isLoading = true;
  String errorMessage = '';
  double totalOrderAmount = 0.0;
  String buyerName = '';
  String enquiryStatus = '';
  DateTime? createdAt;

  @override
  void initState() {
    super.initState();
    fetchEnquiryData();
  }

  Future<void> fetchEnquiryData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      totalOrderAmount = 0.0;
    });

    try {
      print(
          "EnquiryContainer - Fetching enquiry data for ID: ${widget.enquiryId}");

      // Fetch all enquiry items with the same Enquiry_ID
      final enquiryResponse = await Supabase.instance.client
          .from('Enquiry_Table_AgentThrough')
          .select('*')
          .eq('Enquiry_ID', widget.enquiryId)
          .order('created_at', ascending: true);

      print("EnquiryContainer - Enquiry response: $enquiryResponse");

      if (enquiryResponse == null || enquiryResponse.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'No enquiry found';
        });
        return;
      }

      // Process enquiry items
      final List<Map<String, dynamic>> items = <Map<String, dynamic>>[];
      double totalAmount = 0.0;

      // Get common details from first item
      final firstItem = enquiryResponse[0];
      buyerName = firstItem['Buyer_Name']?.toString() ?? 'Unknown Buyer';
      enquiryStatus = firstItem['Status']?.toString() ?? 'Unknown';

      // Parse created_at
      try {
        createdAt = DateTime.parse(firstItem['created_at'].toString());
      } catch (e) {
        print("EnquiryContainer - Error parsing created_at: $e");
        createdAt = DateTime.now();
      }

      for (var enquiryItem in enquiryResponse) {
        try {
          print("EnquiryContainer - Processing enquiry item: $enquiryItem");

          // Get product details if Product_id exists
          String imageUrl = '';
          String category = '';
          double originalPrice = 0.0;

          final productId = enquiryItem['Product_id'];
          if (productId != null) {
            print(
                "EnquiryContainer - Fetching product details for ID: $productId");

            final productResponse = await Supabase.instance.client
                .from('public_products_view')
                .select('ImageURL, Category_Name, Price, Discounted_Price')
                .eq('Product_id', productId)
                .maybeSingle();

            if (productResponse != null) {
              // Handle ImageURL array - get first image or empty string
              final imageUrlRaw = productResponse['ImageURL'];
              if (imageUrlRaw != null) {
                if (imageUrlRaw is List && imageUrlRaw.isNotEmpty) {
                  imageUrl = imageUrlRaw[0]?.toString() ?? '';
                } else if (imageUrlRaw is String) {
                  imageUrl = imageUrlRaw;
                } else {
                  try {
                    final decoded = jsonDecode(imageUrlRaw.toString());
                    if (decoded is List && decoded.isNotEmpty) {
                      imageUrl = decoded[0]?.toString() ?? '';
                    }
                  } catch (e) {
                    print('EnquiryContainer - Error parsing ImageURL: $e');
                    imageUrl = '';
                  }
                }
              }

              category = productResponse['Category_Name']?.toString() ?? '';
              originalPrice = (productResponse['Discounted_Price'] ??
                      productResponse['Price'] ??
                      0.0)
                  .toDouble();
            }
          }

          final quantity = (enquiryItem['Quantity'] ?? 0).toInt();
          final totalPrice = (enquiryItem['Total_Price'] ?? 0.0).toDouble();
          totalAmount += totalPrice;

          items.add({
            'id': enquiryItem['id'],
            'productId': productId ?? 0,
            'productName':
                enquiryItem['Product_Name']?.toString() ?? 'Unknown Product',
            'quantity': quantity,
            'unitPrice': originalPrice,
            'totalPrice': totalPrice,
            'sellerName':
                enquiryItem['Seller_Name']?.toString() ?? 'Unknown Seller',
            'imageUrl': imageUrl,
            'category': category,
            'shippingStatus':
                enquiryItem['shipping_status']?.toString() ?? 'Pending',
            'createdAt': enquiryItem['created_at']?.toString() ?? '',
          });

          print("EnquiryContainer - Added enquiry item: ${items.last}");
        } catch (itemError) {
          print('EnquiryContainer - Error processing enquiry item: $itemError');
          continue;
        }
      }

      setState(() {
        enquiryItems = items;
        totalOrderAmount = totalAmount;
        isLoading = false;
      });

      print(
          "EnquiryContainer - Successfully loaded ${items.length} enquiry items, total amount: $totalAmount");
    } catch (e) {
      print('EnquiryContainer - Error fetching enquiry data: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading enquiry: $e';
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool get _isMobile => MediaQuery.of(context).size.width < 600;
  bool get _isTablet =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;
  bool get _isWeb => MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchEnquiryData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : enquiryItems.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No enquiry items found'),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Enquiry Items List - No Header
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(_isMobile ? 8 : 16),
                            itemCount: enquiryItems.length,
                            itemBuilder: (context, index) {
                              return _buildEnquiryItem(
                                  enquiryItems[index], context);
                            },
                          ),
                        ),
                        // Total Amount Footer
                        _buildTotalFooter(context),
                      ],
                    ),
    );
  }

  Widget _buildEnquiryItem(Map<String, dynamic> item, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: _isMobile ? 8 : 16),
      padding: EdgeInsets.all(_isMobile ? 12 : 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mobile layout - Stack items vertically
          if (_isMobile) ...[
            _buildMobileItemLayout(item, context),
          ] else ...[
            // Tablet/Web layout - Keep horizontal
            _buildDesktopItemLayout(item, context),
          ],

          // Seller Information
          SizedBox(height: _isMobile ? 8 : 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(_isMobile ? 6 : 8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).accent4.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  size: _isMobile ? 14 : 16,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Seller: ${item['sellerName']}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontWeight: FontWeight.w500,
                          fontSize: _isMobile ? 11 : 12,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileItemLayout(
      Map<String, dynamic> item, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image and basic info
        Row(
          children: [
            // Product Image
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
                        item['imageUrl'].toString(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 20,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.shopping_bag,
                      color: Colors.grey,
                      size: 20,
                    ),
            ),
            const SizedBox(width: 12),

            // Product name and category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['productName'].toString(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item['category'].toString().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item['category'].toString(),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontSize: 11,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Price and quantity info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unit: \$${item['unitPrice'].toStringAsFixed(2)}',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Qty: ${item['quantity']}',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                ),
              ],
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
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item['shippingStatus'].toString(),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          color: Colors.orange[700],
                          fontSize: 9,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopItemLayout(
      Map<String, dynamic> item, BuildContext context) {
    return Row(
      children: [
        // Product Image
        Container(
          width: _isWeb ? 80 : 70,
          height: _isWeb ? 80 : 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: item['imageUrl'].toString().isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['imageUrl'].toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.shopping_bag,
                  color: Colors.grey,
                ),
        ),
        const SizedBox(width: 16),

        // Product Details
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['productName'].toString(),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (item['category'].toString().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item['category'].toString(),
                  style: FlutterFlowTheme.of(context).bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                children: [
                  Text(
                    'Unit: \$${item['unitPrice'].toStringAsFixed(2)}',
                    style: FlutterFlowTheme.of(context).bodySmall,
                  ),
                  Text(
                    'Qty: ${item['quantity']}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Total Price and Status
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item['totalPrice'].toStringAsFixed(2)}',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['shippingStatus'].toString(),
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        color: Colors.orange[700],
                        fontSize: 10,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
        border: Border(
          top: BorderSide(
            color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Total Order Amount',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontWeight: FontWeight.bold,
                    fontSize: _isMobile ? 14 : 16,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${totalOrderAmount.toStringAsFixed(2)}',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  color: FlutterFlowTheme.of(context).primary,
                  fontWeight: FontWeight.bold,
                  fontSize: _isMobile ? 18 : 20,
                ),
          ),
        ],
      ),
    );
  }
}
