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

class DynamicFeaturedOffers extends StatefulWidget {
  const DynamicFeaturedOffers({
    Key? key,
    this.width,
    this.height,
    this.maxProducts,
  }) : super(key: key);

  final double? width;
  final double? height;
  final int? maxProducts;

  @override
  _DynamicFeaturedOffersState createState() => _DynamicFeaturedOffersState();
}

class _DynamicFeaturedOffersState extends State<DynamicFeaturedOffers> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print(
        '[DynamicFeaturedOffers] STEP 1: initState called - Widget initialization started');
    _fetchFeaturedOffers();
  }

  Future<void> _fetchFeaturedOffers() async {
    print(
        '[DynamicFeaturedOffers] STEP 2: _fetchFeaturedOffers started - Beginning data fetch from Supabase');
    try {
      final response = await supabase.from('public_products_view').select();
      print(
          '[DynamicFeaturedOffers] STEP 3: Supabase response received - ${response.length} total products found');

      List<Map<String, dynamic>> filteredProducts = [];

      for (var product in response) {
        final productId = product['Product_id'];
        print(
            '[DynamicFeaturedOffers] STEP 4: Processing product - ID: $productId, Type: ${productId.runtimeType}');

        if (product['Status'] != null) {
          Map<String, dynamic> status;
          if (product['Status'] is String) {
            try {
              status = json.decode(product['Status']);
              print(
                  '[DynamicFeaturedOffers] STEP 5: Status JSON decoded successfully for product $productId');
            } catch (e) {
              print(
                  '[DynamicFeaturedOffers] ERROR: JSON decode failed for Status on product $productId: $e');
              continue;
            }
          } else {
            status = product['Status'];
            print(
                '[DynamicFeaturedOffers] STEP 5: Status already parsed for product $productId');
          }

          // Check for FeaturedOffer instead of NewArrival
          if (status['FeaturedOffer'] == true) {
            print(
                '[DynamicFeaturedOffers] STEP 6: Product $productId marked as Featured Offer - Adding to filtered list');
            // Ensure Product_id is properly formatted
            if (productId != null) {
              product['Product_id'] = productId.toString();
              print(
                  '[DynamicFeaturedOffers] STEP 7: Product_id normalized to string: ${product['Product_id']}');
            }
            filteredProducts.add(product);
          } else {
            print(
                '[DynamicFeaturedOffers] STEP 6: Product $productId not a Featured Offer - Skipping');
          }
        } else {
          print(
              '[DynamicFeaturedOffers] STEP 5: Product $productId has no Status field - Skipping');
        }
      }

      if (widget.maxProducts != null &&
          filteredProducts.length > widget.maxProducts!) {
        print(
            '[DynamicFeaturedOffers] STEP 8: Trimming products from ${filteredProducts.length} to max: ${widget.maxProducts}');
        filteredProducts = filteredProducts.take(widget.maxProducts!).toList();
      }

      setState(() {
        _products = filteredProducts;
        _isLoading = false;
      });
      print(
          '[DynamicFeaturedOffers] STEP 9: State updated - ${_products.length} Featured Offer products ready for display');

      // Debug: Print all product IDs that will be displayed
      for (var product in _products) {
        print(
            '[DynamicFeaturedOffers] STEP 10: Final product in list - ID: ${product['Product_id']}, Name: ${product['Product_Name']}');
      }
    } catch (e) {
      print(
          '[DynamicFeaturedOffers] ERROR: Exception in _fetchFeaturedOffers: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        '[DynamicFeaturedOffers] STEP 11: build method called - Starting UI construction');
    return _buildContent();
  }

  Widget _buildContent() {
    print(
        '[DynamicFeaturedOffers] STEP 12: _buildContent called - Determining content type');
    if (_isLoading) {
      print('[DynamicFeaturedOffers] STEP 13: Showing loading indicator');
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_products.isEmpty) {
      print(
          '[DynamicFeaturedOffers] STEP 13: No products found - Showing empty state');
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No featured offers found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    } else {
      print(
          '[DynamicFeaturedOffers] STEP 13: Building products UI for ${_products.length} items');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Featured Offers',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          _buildWrapLayout(),
        ],
      );
    }
  }

  Widget _buildWrapLayout() {
    print(
        '[DynamicFeaturedOffers] STEP 14: _buildWrapLayout called - Creating responsive grid');
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth;
        if (constraints.maxWidth > 1200) {
          cardWidth = (constraints.maxWidth - 80) / 5;
        } else if (constraints.maxWidth > 800) {
          cardWidth = (constraints.maxWidth - 64) / 4;
        } else if (constraints.maxWidth > 500) {
          cardWidth = (constraints.maxWidth - 48) / 3;
        } else {
          cardWidth = (constraints.maxWidth - 32) / 2;
        }

        print(
            '[DynamicFeaturedOffers] STEP 15: Calculated card width: $cardWidth for screen width: ${constraints.maxWidth}');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: _products.map((product) {
              final productId = product['Product_id'];
              print(
                  '[DynamicFeaturedOffers] STEP 16: Creating ProductCard for ID: $productId');
              return SizedBox(
                width: cardWidth - 16,
                height: cardWidth * 1.4,
                child: ProductCard(
                  product: product,
                  onTap: () {
                    print(
                        '[DynamicFeaturedOffers] STEP 17: ProductCard onTap triggered for product ID: $productId');
                    print(
                        '[DynamicFeaturedOffers] STEP 18: Navigation parameters - productID: $productId (${productId.runtimeType})');

                    // Ensure the productID is a string for navigation
                    final productIdString = productId?.toString() ?? '';
                    print(
                        '[DynamicFeaturedOffers] STEP 19: Normalized productID for navigation: "$productIdString"');

                    if (productIdString.isNotEmpty) {
                      print(
                          '[DynamicFeaturedOffers] STEP 20: Attempting navigation to ProductDetail page');
                      try {
                        context.pushNamed(
                          'ProductDetail',
                          queryParameters: {
                            'productID': productIdString,
                          },
                        );
                        print(
                            '[DynamicFeaturedOffers] STEP 21: Navigation call completed successfully');
                      } catch (e) {
                        print(
                            '[DynamicFeaturedOffers] ERROR: Navigation failed: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Navigation error: $e')),
                        );
                      }
                    } else {
                      print(
                          '[DynamicFeaturedOffers] ERROR: ProductID is empty or null - Cannot navigate');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product ID not found')),
                      );
                    }
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  String? _getFirstImageUrl() {
    final productId = product['Product_id'];
    print(
        '[ProductCard] STEP 22: _getFirstImageUrl called for product $productId');

    if (product['ImageURL'] == null) {
      print('[ProductCard] STEP 23: No ImageURL found for product $productId');
      return null;
    }

    List<dynamic> imageUrls;
    if (product['ImageURL'] is String) {
      try {
        imageUrls = json.decode(product['ImageURL']);
        print(
            '[ProductCard] STEP 24: ImageURL JSON decoded successfully for product $productId');
      } catch (e) {
        print(
            '[ProductCard] ERROR: Failed to decode ImageURL JSON for product $productId: $e');
        return product['ImageURL'];
      }
    } else if (product['ImageURL'] is List) {
      imageUrls = product['ImageURL'];
      print(
          '[ProductCard] STEP 24: ImageURL already a list for product $productId');
    } else {
      print(
          '[ProductCard] STEP 24: ImageURL format not recognized for product $productId');
      return null;
    }

    final firstImageUrl =
        imageUrls.isNotEmpty ? imageUrls.first.toString() : null;
    print(
        '[ProductCard] STEP 25: First image URL for product $productId: $firstImageUrl');
    return firstImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final productId = product['Product_id'];
    print('[ProductCard] STEP 26: build called for product ID: $productId');

    final price = (product['Price'] != null)
        ? double.tryParse(product['Price'].toString()) ?? 0.0
        : 0.0;
    final discountedPrice = (product['Discounted_Price'] != null)
        ? double.tryParse(product['Discounted_Price'].toString()) ?? price
        : price;
    final hasDiscount = discountedPrice < price && discountedPrice > 0;

    print(
        '[ProductCard] STEP 27: Price calculation for product $productId - Original: \$${price.toStringAsFixed(2)}, Discounted: \$${discountedPrice.toStringAsFixed(2)}, Has Discount: $hasDiscount');

    final imageUrl = _getFirstImageUrl();
    print(
        '[ProductCard] STEP 28: Final image URL for product $productId: $imageUrl');

    bool isFeaturedOffer = false;
    if (product['Status'] != null) {
      try {
        Map<String, dynamic> status = product['Status'] is String
            ? json.decode(product['Status'])
            : product['Status'];
        isFeaturedOffer = status['FeaturedOffer'] == true;
        print(
            '[ProductCard] STEP 29: FeaturedOffer status for product $productId: $isFeaturedOffer');
      } catch (e) {
        print(
            '[ProductCard] ERROR: Error parsing Status JSON for product $productId: $e');
      }
    }

    print('[ProductCard] STEP 30: Building card UI for product $productId');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          print(
              '[ProductCard] STEP 31: InkWell onTap triggered for product $productId');
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  '[ProductCard] ERROR: Image load failed for product $productId: $error');
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child:
                                Icon(Icons.image, size: 48, color: Colors.grey),
                          ),
                  ),
                  if (isFeaturedOffer)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'FEATURED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product['Product_Name']?.toString() ?? 'Unnamed Product',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (product['Category_Name'] != null)
                    Text(
                      product['Category_Name'].toString(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '\$${discountedPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                hasDiscount ? Colors.redAccent : Colors.black87,
                          ),
                        ),
                      ),
                      if (hasDiscount)
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
