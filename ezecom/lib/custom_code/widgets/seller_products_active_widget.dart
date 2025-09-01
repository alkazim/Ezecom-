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

import 'package:supabase_flutter/supabase_flutter.dart';

class SellerProductsActiveWidget extends StatefulWidget {
  final String sellerEmail;
  final double? width;
  final double? height;

  const SellerProductsActiveWidget({
    Key? key,
    required this.sellerEmail,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<SellerProductsActiveWidget> createState() =>
      _SellerProductsActiveWidgetState();
}

class _SellerProductsActiveWidgetState
    extends State<SellerProductsActiveWidget> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String? error;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    print(
        '[SellerProductsActiveWidget] Initializing widget for seller: ${widget.sellerEmail}');
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      print(
          '[SellerProductsActiveWidget] Fetching products for seller: ${widget.sellerEmail}');
      setState(() {
        isLoading = true;
        error = null;
      });

      // final response = await Supabase.instance.client
      //     .from('Products_Table')
      //     .select('*')
      //     .eq('Seller_Email', widget.sellerEmail)
      //     .order('created_at', ascending: false);

      final response = await Supabase.instance.client
          .from('Products_Table')
          .select('*')
          .eq('Auth_ID', widget.sellerEmail)
          .neq('Approval', 'pending')
          .order('created_at', ascending: false);

      print(
          '[SellerProductsActiveWidget] Successfully fetched ${response.length} products');

      setState(() {
        products = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('[SellerProductsActiveWidget] Error fetching products: $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Color _getStatusColor(String? approval) {
    switch (approval?.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return const Color(0xFFFF4757);
      case 'PENDING APPROVAL':
      default:
        return const Color(0xFF3742FA);
    }
  }

  IconData _getProductIcon(String? categoryName) {
    switch (categoryName?.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'fashion':
        return Icons.checkroom;
      case 'sports':
        return Icons.sports_soccer;
      case 'beauty':
        return Icons.face_retouching_natural;
      case 'home':
        return Icons.home;
      default:
        return Icons.shopping_bag;
    }
  }

  void _showProductDetails(Map<String, dynamic> product) {
    print(
        '[SellerProductsActiveWidget] Opening product details for: ${product['Product_Name']}');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ProductDetailsPopup(product: product),
          ),
        );
      },
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      print('[SellerProductsActiveWidget] Error parsing date: $e');
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        '[SellerProductsActiveWidget] Building widget - Loading: $isLoading, Products: ${products.length}');

    return Container(
      width: widget.width,
      height: widget.height ?? 400,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5DADE2),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5DADE2),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5DADE2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
//           Expanded(
//             child: isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       valueColor:
//                           AlwaysStoppedAnimation<Color>(Color(0xFF5DADE2)),
//                     ),
//                   )
//                 : error != null
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.error_outline,
//                               color: Colors.red[400],
//                               size: 48,
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               'Error loading products',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               error!,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[500],
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 16),
//                             ElevatedButton(
//                               onPressed: _fetchProducts,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF5DADE2),
//                               ),
//                               child: const Text('Retry'),
//                             ),
//                           ],
//                         ),
//                       )
//                     : products.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.inventory_2_outlined,
//                                   color: Colors.grey[400],
//                                   size: 48,
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   'No products found',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'No products available for ${widget.sellerEmail}',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[500],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: EdgeInsets.zero,
//                             itemCount: products.length,
//                             itemBuilder: (context, index) {
//                               final product = products[index];
//                               final isHighlighted = product['Approval']
//                                       ?.toString()
//                                       .toUpperCase() !=
//                                   'REJECTED';

//                               return Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: isHighlighted
//                                       ? Border.all(
//                                           color: const Color(0xFF5DADE2),
//                                           width: 2)
//                                       : null,
//                                   borderRadius: BorderRadius.circular(8),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.05),
//                                       blurRadius: 4,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Material(
//                                   color: Colors.transparent,
//                                   child: InkWell(
//                                     onTap: () => _showProductDetails(product),
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(12),
//                                       child: Row(
//                                         children: [
//                                           // Product Info
//                                           Expanded(
//                                             flex: 2,
//                                             child: Row(
//                                               children: [
//                                                 Container(
//                                                   width: 40,
//                                                   height: 40,
//                                                   decoration: BoxDecoration(
//                                                     color:
//                                                         const Color(0xFF5DADE2)
//                                                             .withOpacity(0.1),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20),
//                                                   ),
//                                                   child: Icon(
//                                                     _getProductIcon(product[
//                                                         'Category_Name']),
//                                                     color:
//                                                         const Color(0xFF5DADE2),
//                                                     size: 20,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 12),
//                                                 Expanded(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         product['Product_Name'] ??
//                                                             'Unknown Product',
//                                                         style: const TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color:
//                                                               Color(0xFF2C3E50),
//                                                         ),
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                       ),
//                                                       const SizedBox(height: 2),
//                                                       Text(
//                                                         product['Category_Name'] ??
//                                                             'Unknown Category',
//                                                         style: TextStyle(
//                                                           fontSize: 12,
//                                                           color:
//                                                               Colors.grey[600],
//                                                         ),
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
// /////////////////////////////////////////////////////////////////
//                                           // Date
// // Date
//                                           Expanded(
//                                             flex: 1,
//                                             child: Center(
//                                               child: Text(
//                                                 _formatDate(
//                                                     product['created_at']),
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color: Color(0xFF2C3E50),
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                           ),

// // Status
//                                           Expanded(
//                                             flex: 1,
//                                             child: Center(
//                                               child: Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                   horizontal: 8,
//                                                   vertical: 4,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: _getStatusColor(
//                                                           product['Approval'])
//                                                       .withOpacity(0.1),
//                                                   borderRadius:
//                                                       BorderRadius.circular(12),
//                                                 ),
//                                                 child: Text(
//                                                   product['Approval']
//                                                           ?.toString()
//                                                           .toUpperCase() ??
//                                                       'PENDING',
//                                                   style: TextStyle(
//                                                     fontSize: 10,
//                                                     fontWeight: FontWeight.w600,
//                                                     color: _getStatusColor(
//                                                         product['Approval']),
//                                                   ),
//                                                   textAlign: TextAlign.center,
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
// ///////////////////////////////////////////////////////////////////////////////////////////////////
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//           ),

// Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchProducts,
              color: const Color(0xFF5DADE2),
              backgroundColor: Colors.white,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF5DADE2)),
                      ),
                    )
                  : error != null
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red[400],
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Error loading products',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    error!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _fetchProducts,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5DADE2),
                                    ),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : products.isEmpty
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inventory_2_outlined,
                                        color: Colors.grey[400],
                                        size: 48,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No products found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No products available for ${widget.sellerEmail}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final isHighlighted = product['Approval']
                                        ?.toString()
                                        .toUpperCase() !=
                                    'REJECTED';

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: isHighlighted
                                        ? Border.all(
                                            color: const Color(0xFF5DADE2),
                                            width: 2)
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _showProductDetails(product),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center, // Add this line
                                          children: [
                                            // Product Info
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center, // Add this line
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xFF5DADE2)
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Icon(
                                                      _getProductIcon(product[
                                                          'Category_Name']),
                                                      color: const Color(
                                                          0xFF5DADE2),
                                                      size: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          product['Product_Name'] ??
                                                              'Unknown Product',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xFF2C3E50),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 2),
                                                        Text(
                                                          product['Category_Name'] ??
                                                              'Unknown Category',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Date
                                            // Date
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                // Wrap Text with Center widget
                                                child: Text(
                                                  _formatDate(
                                                      product['created_at']),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF2C3E50),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Status
                                            // Status
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                // Add Center widget here
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(
                                                            product['Approval'])
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    product['Approval']
                                                            ?.toString()
                                                            .toUpperCase() ??
                                                        'PENDING',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: _getStatusColor(
                                                          product['Approval']),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('[SellerProductsActiveWidget] Disposing widget');
    _pageController.dispose();
    super.dispose();
  }
}

class ProductDetailsPopup extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPopup({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsPopup> createState() => _ProductDetailsPopupState();
}

class _ProductDetailsPopupState extends State<ProductDetailsPopup> {
  PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  bool _isImageExpanded = false;

  List<String> get imageUrls {
    print(
        '[ProductDetailsPopup] Processing ImageURL data: ${widget.product['ImageURL']}');
    final imageUrlsData = widget.product['ImageURL'];
    if (imageUrlsData is List) {
      final urls = imageUrlsData.map((url) => url.toString()).toList();
      print('[ProductDetailsPopup] Found ${urls.length} image URLs');
      return urls;
    }
    print('[ProductDetailsPopup] No valid image URLs found');
    return [];
  }

  Future<void> _deleteProduct() async {
    try {
      print(
          '[ProductDetailsPopup] Deleting product ID: ${widget.product['Product_id']}');

      await Supabase.instance.client
          .from('Products_Table')
          .delete()
          .eq('Product_id', widget.product['Product_id']);

      if (mounted) {
        Navigator.of(context).pop(); // Close popup
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('[ProductDetailsPopup] Error deleting product: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: EditProductDialog(
              product: widget.product,
              onProductUpdated: () {
                Navigator.of(context).pop(); // Close edit dialog
                Navigator.of(context).pop(); // Close details popup
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text(
              'Are you sure you want to delete "${widget.product['Product_Name']}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation dialog
                _deleteProduct();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String? approval) {
    switch (approval?.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return const Color(0xFFFF4757);
      case 'PENDING APPROVAL':
      default:
        return const Color(0xFF3742FA);
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    return '₹${double.tryParse(price.toString())?.toStringAsFixed(2) ?? price.toString()}';
  }

  Widget _buildDetailRow(String label, String value, {bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140, // Increased width for better alignment
            child: Text(
              label,
              style: TextStyle(
                fontSize: isLarge ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5DADE2),
              ),
            ),
          ),
          Text(': ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isLarge ? 16 : 14,
              )),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isLarge ? 16 : 14,
                color: const Color(0xFF2C3E50),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    if (imageUrls.isEmpty) {
      print('[ProductDetailsPopup] No images to display');
      return Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 60,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                'No images available',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Main image container with dynamic height
        GestureDetector(
          onTap: () {
            setState(() {
              _isImageExpanded = !_isImageExpanded;
            });
            print(
                '[ProductDetailsPopup] Image expanded state: $_isImageExpanded');
          },
          child: Container(
            height: _isImageExpanded ? 400 : 300, // Dynamic height
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _imagePageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                    print(
                        '[ProductDetailsPopup] Image page changed to: $index');
                  },
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    print(
                        '[ProductDetailsPopup] Building image at index $index: ${imageUrls[index]}');
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit
                            .contain, // Changed from cover to contain to show full image
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          print(
                              '[ProductDetailsPopup] Error loading image at index $index: $error');
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Failed to load image',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            print(
                                '[ProductDetailsPopup] Image loaded successfully at index $index');
                            return child;
                          }
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF5DADE2)),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                // Navigation arrows for multiple images
                if (imageUrls.length > 1) ...[
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (_currentImageIndex > 0) {
                              _imagePageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (_currentImageIndex < imageUrls.length - 1) {
                              _imagePageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                // Expand/Collapse button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _isImageExpanded = !_isImageExpanded;
                        });
                      },
                      icon: Icon(
                        _isImageExpanded
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Image counter
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentImageIndex + 1} / ${imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Image indicators
        if (imageUrls.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageUrls.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  _imagePageController.animateToPage(
                    entry.key,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: _currentImageIndex == entry.key ? 12 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentImageIndex == entry.key
                        ? const Color(0xFF5DADE2)
                        : Colors.grey[400],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        '[ProductDetailsPopup] Building popup for product: ${widget.product['Product_Name']}');

    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 1200;
    final isTablet = screenWidth > 768 && screenWidth <= 1200;
    final isMobile = screenWidth <= 768;

    print(
        '[ProductDetailsPopup] Screen width: $screenWidth, isWeb: $isWeb, isTablet: $isTablet, isMobile: $isMobile');

    return Container(
      width: isWeb
          ? screenWidth * 0.6
          : (isTablet ? screenWidth * 0.8 : screenWidth * 0.95),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(isWeb ? 20 : 16),
            decoration: const BoxDecoration(
              color: Color(0xFF5DADE2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Product Details',
                    style: TextStyle(
                      fontSize: isWeb ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print('[ProductDetailsPopup] Closing popup');
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isWeb ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Section
                  _buildImageSection(),

                  const SizedBox(height: 24),

                  // Product Details
                  Container(
                    padding: EdgeInsets.all(isWeb ? 24 : 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name with Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product['Product_Name'] ??
                                    'Unknown Product',
                                style: TextStyle(
                                  fontSize: isWeb ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2C3E50),
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _getStatusColor(widget.product['Approval'])
                                        .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getStatusColor(
                                          widget.product['Approval'])
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                widget.product['Approval']
                                        ?.toString()
                                        .toUpperCase() ??
                                    'PENDING',
                                style: TextStyle(
                                  fontSize: isWeb ? 14 : 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(
                                      widget.product['Approval']),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Product Details Grid
                        _buildDetailRow('Category',
                            widget.product['Category_Name'] ?? 'N/A',
                            isLarge: isWeb),
                        _buildDetailRow('Sub Category',
                            widget.product['Sub_Category_Name'] ?? 'N/A',
                            isLarge: isWeb),
                        _buildDetailRow(
                            'Price', _formatPrice(widget.product['Price']),
                            isLarge: isWeb),

                        if (widget.product['Discounted_Price'] != null)
                          _buildDetailRow('Discounted Price',
                              _formatPrice(widget.product['Discounted_Price']),
                              isLarge: isWeb),

                        if (widget.product['Discount'] != null)
                          _buildDetailRow(
                              'Discount', '${widget.product['Discount']}%',
                              isLarge: isWeb),

                        _buildDetailRow('Quantity',
                            widget.product['Quantity']?.toString() ?? 'N/A',
                            isLarge: isWeb),
                        _buildDetailRow(
                            'Model No', widget.product['Model_N0'] ?? 'N/A',
                            isLarge: isWeb),
                        _buildDetailRow(
                            'Added By', widget.product['Added_by'] ?? 'N/A',
                            isLarge: isWeb),
                        _buildDetailRow('Seller Email',
                            widget.product['Seller_Email'] ?? 'N/A',
                            isLarge: isWeb),

                        // Description
                        if (widget.product['Description'] != null &&
                            widget.product['Description']
                                .toString()
                                .isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: isWeb ? 18 : 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF5DADE2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              widget.product['Description'],
                              style: TextStyle(
                                fontSize: isWeb ? 16 : 14,
                                color: const Color(0xFF2C3E50),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],

                        // Tags
                        if (widget.product['Tags'] != null &&
                            widget.product['Tags'] is List) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Tags',
                            style: TextStyle(
                              fontSize: isWeb ? 18 : 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF5DADE2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                (widget.product['Tags'] as List).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF5DADE2).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF5DADE2)
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  tag.toString(),
                                  style: TextStyle(
                                    fontSize: isWeb ? 14 : 12,
                                    color: const Color(0xFF5DADE2),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        // Created Date
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          'Created At',
                          widget.product['created_at'] != null
                              ? DateTime.parse(widget.product['created_at'])
                                  .toString()
                                  .split('.')[0]
                              : 'N/A',
                          isLarge: isWeb,
                        ),
                        //
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showEditDialog,
                          icon: const Icon(Icons.edit, size: 20),
                          label: const Text('Edit Product'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5DADE2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showDeleteConfirmation,
                          icon: const Icon(Icons.delete, size: 20),
                          label: const Text('Delete Product'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    //
  }

  @override
  void dispose() {
    print('[ProductDetailsPopup] Disposing popup');
    _imagePageController.dispose();
    super.dispose();
  }
}

class EditProductDialog extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onProductUpdated;

  const EditProductDialog({
    Key? key,
    required this.product,
    required this.onProductUpdated,
  }) : super(key: key);

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _modelController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with existing values
    _productNameController.text = widget.product['Product_Name'] ?? '';
    _descriptionController.text = widget.product['Description'] ?? '';
    _priceController.text = widget.product['Price']?.toString() ?? '';
    _discountController.text = widget.product['Discount']?.toString() ?? '';
    _quantityController.text = widget.product['Quantity']?.toString() ?? '';
    _modelController.text = widget.product['Model_N0'] ?? '';
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final price = double.tryParse(_priceController.text) ?? 0;
      final discount = double.tryParse(_discountController.text) ?? 0;
      final discountedPrice = price - (price * discount / 100);

      final updateData = {
        'Product_Name': _productNameController.text.trim(),
        'Description': _descriptionController.text.trim(),
        'Price': price,
        'Discount': discount,
        'Discounted_Price': discountedPrice,
        'Quantity': int.tryParse(_quantityController.text) ?? 0,
        'Model_N0': _modelController.text.trim(),
      };

      await Supabase.instance.client
          .from('Products_Table')
          .update(updateData)
          .eq('Product_id', widget.product['Product_id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onProductUpdated();
      }
    } catch (e) {
      print('[EditProductDialog] Error updating product: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF5DADE2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.edit, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Edit Product',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),

        // Form
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _productNameController,
                    label: 'Product Name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Product name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _priceController,
                          label: 'Price',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Price is required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter valid price';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _discountController,
                          label: 'Discount (%)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _quantityController,
                          label: 'Quantity',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Quantity is required';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Enter valid quantity';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _modelController,
                          label: 'Model Number',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Action Buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed:
                      _isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5DADE2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Update Product',
                          style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF5DADE2)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _quantityController.dispose();
    _modelController.dispose();
    super.dispose();
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
