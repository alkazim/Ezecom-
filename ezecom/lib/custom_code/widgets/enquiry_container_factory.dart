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
import 'dart:convert';

class EnquiryContainerFactory extends StatefulWidget {
  const EnquiryContainerFactory({
    super.key,
    this.width,
    this.height,
    required this.enquiryId,
  });

  final double? width;
  final double? height;
  final String enquiryId;

  @override
  State<EnquiryContainerFactory> createState() =>
      _EnquiryContainerFactoryState();
}

class _EnquiryContainerFactoryState extends State<EnquiryContainerFactory> {
  List<Map<String, dynamic>> enquiryItems = [];
  bool isLoading = true;
  String errorMessage = '';
  double totalOrderAmount = 0.0; // Grand total (Paypalprice)
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
      final enquiryResponse = await Supabase.instance.client
          .from('Enquiry_Table_FactoryThrough')
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

      final List<Map<String, dynamic>> items = [];

      /// Store values from the first row
      final firstItem = enquiryResponse[0];
      print(firstItem);
      buyerName = firstItem['Buyer_Name']?.toString() ?? 'Unknown Buyer';
      enquiryStatus = firstItem['Payment_Status']?.toString() ?? 'Unknown';
      createdAt = DateTime.tryParse(firstItem['created_at'].toString());

      // Paypalprice represents the grand total for the whole cart
      totalOrderAmount = (firstItem['Paypalprice'] ?? 0.0).toDouble();
      print(totalOrderAmount);

      for (var enquiryItem in enquiryResponse) {
        String imageUrl = '';
        String category = '';
        final productId = enquiryItem['Product_Id'];

        // ---------- Fetch product meta (image & category) ----------
        if (productId != null) {
          final productResponse = await Supabase.instance.client
              .from('public_products_view')
              .select('ImageURL, Category_Name')
              .eq('Product_id', productId)
              .maybeSingle();

          if (productResponse != null) {
            final imageUrlRaw = productResponse['ImageURL'];
            if (imageUrlRaw != null) {
              try {
                if (imageUrlRaw is List && imageUrlRaw.isNotEmpty) {
                  imageUrl = imageUrlRaw[0]?.toString() ?? '';
                } else if (imageUrlRaw is String) {
                  imageUrl = imageUrlRaw;
                } else {
                  final decoded = jsonDecode(imageUrlRaw.toString());
                  if (decoded is List && decoded.isNotEmpty) {
                    imageUrl = decoded[0]?.toString() ?? '';
                  }
                }
              } catch (_) {
                imageUrl = '';
              }
            }
            category = productResponse['Category_Name']?.toString() ?? '';
          }
        }

        final quantity = (enquiryItem['Quantity'] ?? 0).toInt();
        final gstTotalPrice =
            (enquiryItem['GST_Total_Price'] ?? 0.0).toDouble();

        items.add({
          'productId': productId ?? 0,
          'productName':
              enquiryItem['Product_Name']?.toString() ?? 'Unknown Product',
          'quantity': quantity,
          'unitPrice': gstTotalPrice, // GST-inclusive unit price
          'imageUrl': imageUrl,
          'category': category,
          'createdAt': enquiryItem['created_at']?.toString() ?? '',
        });
      }

      setState(() {
        enquiryItems = items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading enquiry: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ---------------- Product List ----------------
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: enquiryItems.map((item) {
                          final productName = item['productName'].toString();
                          final category = item['category'].toString();
                          final quantity = item['quantity'];
                          final unitPrice = item['unitPrice'];
                          final imageUrl = item['imageUrl'].toString();

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image_not_supported),
                              title: Text(productName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Category: $category'),
                                  Text(
                                      'Qty: $quantity | Unit Price: \$${unitPrice.toStringAsFixed(2)}'),
                                ],
                              ),
                              // No trailing value here because grand total is displayed below
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // ---------------- Grand Total ----------------
                    Container(
                      padding: const EdgeInsets.all(16),
                      color:
                          FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Grand Total :',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${totalOrderAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
