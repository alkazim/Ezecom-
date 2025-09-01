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

class EnquiryContainerAgent extends StatefulWidget {
  const EnquiryContainerAgent({
    super.key,
    this.width,
    this.height,
    required this.enquiryId,
  });

  final double? width;
  final double? height;
  final String enquiryId;

  @override
  State<EnquiryContainerAgent> createState() => _EnquiryContainerAgentState();
}

class _EnquiryContainerAgentState extends State<EnquiryContainerAgent> {
  List<Map<String, dynamic>> enquiryItems = [];
  bool isLoading = true;
  String errorMessage = '';
  double totalOrderAmount = 0.0;

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
      final enquiryResponse = await Supabase.instance.client
          .from('Enquiry_Table_AgentThrough')
          .select('*')
          .eq('Enquiry_ID', widget.enquiryId)
          .order('created_at', ascending: true);

      if (enquiryResponse == null || enquiryResponse.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'No enquiry found';
        });
        return;
      }

      final List<Map<String, dynamic>> items = <Map<String, dynamic>>[];
      double totalAmount = 0.0;

      for (var enquiryItem in enquiryResponse) {
        try {
          String imageUrl = '';
          String category = '';
          double unitPrice = 0.0;

          final productId = enquiryItem['Product_id'];
          if (productId != null) {
            final productResponse = await Supabase.instance.client
                .from('public_products_view')
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
                    final decoded = jsonDecode(imageUrlRaw.toString());
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
          }

          final quantity = (enquiryItem['Quantity'] ?? 0).toInt();
          final totalPrice = (enquiryItem['Total_Price'] ?? 0.0).toDouble();
          totalAmount += totalPrice;

          items.add({
            'productName': enquiryItem['Product_Name']?.toString() ?? '',
            'quantity': quantity,
            'unitPrice': unitPrice,
            'totalPrice': totalPrice,
            'imageUrl': imageUrl,
            'category': category,
          });
        } catch (_) {
          continue;
        }
      }

      setState(() {
        enquiryItems = items;
        totalOrderAmount = totalAmount;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading enquiry: $e';
      });
    }
  }

  bool get _isMobile => MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : enquiryItems.isEmpty
                  ? const Center(child: Text('No enquiry items found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      shrinkWrap: true,
                      //physics: const NeverScrollableScrollPhysics(),
                      itemCount: enquiryItems.length,
                      itemBuilder: (context, index) =>
                          _buildEnquiryItem(enquiryItems[index], context),
                    ),
    );
  }

  Widget _buildEnquiryItem(Map<String, dynamic> item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    if (item['category'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          item['category'],
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit: \$${item['unitPrice'].toStringAsFixed(2)}',
                    style: FlutterFlowTheme.of(context)
                        .bodySmall
                        .override(fontSize: 11),
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
      ),
    );
  }
}
