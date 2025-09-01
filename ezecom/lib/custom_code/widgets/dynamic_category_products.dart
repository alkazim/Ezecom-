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

class DynamicCategoryProducts extends StatefulWidget {
  const DynamicCategoryProducts({
    Key? key,
    this.width,
    this.height,
    this.maxProducts,
    required this.categoryName,
  }) : super(key: key);

  final double? width;
  final double? height; // This will be ignored for auto-expansion
  final int? maxProducts;
  final String categoryName;

  @override
  _DynamicCategoryProductsState createState() =>
      _DynamicCategoryProductsState();
}

class _DynamicCategoryProductsState extends State<DynamicCategoryProducts> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print(
        '[DynamicCategoryProducts] STEP 1: initState called - Widget initialization started for category: ${widget.categoryName}');
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    print(
        '[DynamicCategoryProducts] STEP 2: _fetchCategoryProducts started - Beginning data fetch from Supabase for category: ${widget.categoryName}');
    try {
      final response = await supabase
          .from('public_products_view')
          .select()
          .eq('Category_Name', widget.categoryName);
      //.eq('Approval', 'approved');

      print(
          '[DynamicCategoryProducts] STEP 3: Supabase response received - ${response.length} products found for category: ${widget.categoryName}');

      List<Map<String, dynamic>> filteredProducts = [];

      for (var product in response) {
        final productId = product['Product_id'];
        print(
            '[DynamicCategoryProducts] STEP 4: Processing product - ID: $productId, Type: ${productId.runtimeType}');

        // Ensure Product_id is properly formatted
        if (productId != null) {
          product['Product_id'] = productId.toString();
          print(
              '[DynamicCategoryProducts] STEP 5: Product_id normalized to string: ${product['Product_id']}');
        }
        filteredProducts.add(product);
      }

      if (widget.maxProducts != null &&
          filteredProducts.length > widget.maxProducts!) {
        print(
            '[DynamicCategoryProducts] STEP 6: Trimming products from ${filteredProducts.length} to max: ${widget.maxProducts}');
        filteredProducts = filteredProducts.take(widget.maxProducts!).toList();
      }

      setState(() {
        _products = filteredProducts;
        _isLoading = false;
      });
      print(
          '[DynamicCategoryProducts] STEP 7: State updated - ${_products.length} products ready for display');

      // Debug: Print all product IDs that will be displayed
      for (var product in _products) {
        print(
            '[DynamicCategoryProducts] STEP 8: Final product in list - ID: ${product['Product_id']}, Name: ${product['Product_Name']}');
      }
    } catch (e) {
      print(
          '[DynamicCategoryProducts] ERROR: Exception in _fetchCategoryProducts: $e');
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
        '[DynamicCategoryProducts] STEP 9: build method called - Starting UI construction');
    return _buildContent();
  }

  Widget _buildContent() {
    print(
        '[DynamicCategoryProducts] STEP 10: _buildContent called - Determining content type');
    if (_isLoading) {
      print('[DynamicCategoryProducts] STEP 11: Showing loading indicator');
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_products.isEmpty) {
      print(
          '[DynamicCategoryProducts] STEP 11: No products found - Showing empty state');
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No products found in ${widget.categoryName}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    } else {
      print(
          '[DynamicCategoryProducts] STEP 11: Building products UI for ${_products.length} items');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // This makes the column auto-expand
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.categoryName,
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
        '[DynamicCategoryProducts] STEP 12: _buildWrapLayout called - Creating responsive grid');
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
            '[DynamicCategoryProducts] STEP 13: Calculated card width: $cardWidth for screen width: ${constraints.maxWidth}');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: _products.map((product) {
              final productId = product['Product_id'];
              print(
                  '[DynamicCategoryProducts] STEP 14: Creating ProductCard for ID: $productId');
              return SizedBox(
                width: cardWidth - 16,
                child: ProductCard(
                  // Removed fixed height - now auto-expandable
                  product: product,
                  onTap: () {
                    print(
                        '[DynamicCategoryProducts] STEP 15: ProductCard onTap triggered for product ID: $productId');
                    print(
                        '[DynamicCategoryProducts] STEP 16: Navigation parameters - productID: $productId (${productId.runtimeType})');

                    // Ensure the productID is a string for navigation
                    final productIdString = productId?.toString().trim() ?? '';
                    print(
                        '[DynamicCategoryProducts] STEP 17: Normalized productID for navigation: "$productIdString"');

                    if (productIdString.isNotEmpty) {
                      print(
                          '[DynamicCategoryProducts] STEP 18: Attempting navigation to ProductDetail page');
                      try {
                        // Try multiple navigation approaches for FlutterFlow compatibility

                        // Approach 1: Using queryParameters (most common in FlutterFlow)
                        context.pushNamed(
                          'ProductDetail',
                          queryParameters: {
                            'productID': productIdString,
                          },
                        );

                        // Alternative approach if the above doesn't work:
                        // context.pushNamed(
                        //   'ProductDetail',
                        //   pathParameters: {
                        //     'productID': productIdString,
                        //   },
                        // );

                        // Alternative approach with extra parameter:
                        // context.pushNamed(
                        //   'ProductDetail',
                        //   extra: {
                        //     'productID': productIdString,
                        //     'product': product,
                        //   },
                        // );

                        print(
                            '[DynamicCategoryProducts] STEP 19: Navigation call completed successfully');
                      } catch (e) {
                        print(
                            '[DynamicCategoryProducts] ERROR: Navigation failed: $e');

                        // Fallback: Try alternative navigation method
                        try {
                          context.pushNamed(
                            'ProductDetail',
                            pathParameters: {
                              'productID': productIdString,
                            },
                          );
                          print(
                              '[DynamicCategoryProducts] STEP 19: Fallback navigation successful');
                        } catch (e2) {
                          print(
                              '[DynamicCategoryProducts] ERROR: Fallback navigation also failed: $e2');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Navigation error: $e2')),
                          );
                        }
                      }
                    } else {
                      print(
                          '[DynamicCategoryProducts] ERROR: ProductID is empty or null - Cannot navigate');
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
        '[ProductCard] STEP 20: _getFirstImageUrl called for product $productId');

    if (product['ImageURL'] == null) {
      print('[ProductCard] STEP 21: No ImageURL found for product $productId');
      return null;
    }

    // Handle array of strings from Supabase
    if (product['ImageURL'] is List) {
      final imageUrls = product['ImageURL'] as List;
      print('[ProductCard] STEP 22: ImageURL is a list for product $productId');
      final firstImageUrl =
          imageUrls.isNotEmpty ? imageUrls.first.toString() : null;
      print(
          '[ProductCard] STEP 23: First image URL for product $productId: $firstImageUrl');
      return firstImageUrl;
    } else if (product['ImageURL'] is String) {
      // Handle case where it might be a JSON string
      try {
        final imageUrls = json.decode(product['ImageURL']);
        if (imageUrls is List) {
          print(
              '[ProductCard] STEP 22: ImageURL JSON decoded successfully for product $productId');
          final firstImageUrl =
              imageUrls.isNotEmpty ? imageUrls.first.toString() : null;
          print(
              '[ProductCard] STEP 23: First image URL for product $productId: $firstImageUrl');
          return firstImageUrl;
        }
      } catch (e) {
        print(
            '[ProductCard] STEP 22: ImageURL is a simple string for product $productId');
        return product['ImageURL'];
      }
    }

    print(
        '[ProductCard] STEP 22: ImageURL format not recognized for product $productId');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final productId = product['Product_id'];
    print('[ProductCard] STEP 24: build called for product ID: $productId');

    final price = (product['Price'] != null)
        ? double.tryParse(product['Price'].toString()) ?? 0.0
        : 0.0;
    final discountedPrice = (product['Discounted_Price'] != null)
        ? double.tryParse(product['Discounted_Price'].toString()) ?? price
        : price;
    final hasDiscount = discountedPrice < price && discountedPrice > 0;

    print(
        '[ProductCard] STEP 25: Price calculation for product $productId - Original: \$${price.toStringAsFixed(2)}, Discounted: \$${discountedPrice.toStringAsFixed(2)}, Has Discount: $hasDiscount');

    final imageUrl = _getFirstImageUrl();
    print(
        '[ProductCard] STEP 26: Final image URL for product $productId: $imageUrl');

    bool isNewArrival = false;
    if (product['Status'] != null) {
      try {
        Map<String, dynamic> status = product['Status'] is String
            ? json.decode(product['Status'])
            : product['Status'];
        isNewArrival = status['NewArrival'] == true;
        print(
            '[ProductCard] STEP 27: NewArrival status for product $productId: $isNewArrival');
      } catch (e) {
        print(
            '[ProductCard] ERROR: Error parsing Status JSON for product $productId: $e');
      }
    }

    print('[ProductCard] STEP 28: Building card UI for product $productId');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          print(
              '[ProductCard] STEP 29: InkWell onTap triggered for product $productId');
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Auto-expand based on content
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
                  if (isNewArrival)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'NEW',
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
                mainAxisSize: MainAxisSize.min, // Auto-expand based on content
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
                  if (product['Sub_Category_Name'] != null)
                    Text(
                      product['Sub_Category_Name'].toString(),
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
