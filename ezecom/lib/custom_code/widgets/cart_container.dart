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

class CartContainer extends StatefulWidget {
  const CartContainer({
    super.key,
    this.width,
    this.height,
    required this.userEmail,
  });

  final double? width;
  final double? height;
  final String userEmail;

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Fetch client data
      final clientResponse = await Supabase.instance.client
          .from('client_table')
          .select()
          .eq('Email', widget.userEmail)
          .maybeSingle();

      if (clientResponse == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'No client found with this email';
        });
        return;
      }

      // Get cart data with better error handling
      final cartRaw = clientResponse['CartList'];
      print('Raw cart data: $cartRaw');
      print('Cart data type: ${cartRaw.runtimeType}');

      // Initialize empty cart list
      List<dynamic> cartList = <dynamic>[];

      // Handle different data types more carefully
      if (cartRaw == null) {
        print('CartList is null');
        cartList = <dynamic>[];
      } else {
        try {
          // Convert to string first, then parse
          String cartString = '';

          if (cartRaw is String) {
            cartString = cartRaw;
          } else {
            // Convert any other type to JSON string first
            cartString = jsonEncode(cartRaw);
          }

          print('Cart string: $cartString');

          // Now decode the JSON string
          final decoded = jsonDecode(cartString);

          if (decoded is List) {
            cartList = decoded.cast<dynamic>();
          } else {
            print('Decoded data is not a list: ${decoded.runtimeType}');
            cartList = <dynamic>[];
          }
        } catch (parseError) {
          print('Error parsing cart data: $parseError');
          // Try alternative approach - direct list conversion
          try {
            if (cartRaw is Iterable) {
              cartList = cartRaw.toList().cast<dynamic>();
            } else {
              cartList = <dynamic>[];
            }
          } catch (e2) {
            print('Secondary parsing error: $e2');
            cartList = <dynamic>[];
          }
        }
      }

      print('Final cart list: $cartList');
      print('Cart list length: ${cartList.length}');

      if (cartList.isEmpty) {
        setState(() {
          isLoading = false;
          cartItems = [];
        });
        return;
      }

      // Process cart items
      final List<Map<String, dynamic>> items = <Map<String, dynamic>>[];

      for (int i = 0; i < cartList.length; i++) {
        try {
          final item = cartList[i];
          print('Processing item $i: $item');

          if (item != null) {
            // Convert item to Map safely
            Map<String, dynamic> itemMap = <String, dynamic>{};

            if (item is Map) {
              item.forEach((key, value) {
                itemMap[key.toString()] = value;
              });
            } else {
              print('Item is not a map: ${item.runtimeType}');
              continue;
            }

            // Check if required fields exist
            if (itemMap.containsKey('productid') &&
                itemMap.containsKey('quantity')) {
              final productId = itemMap['productid'];
              final quantity = itemMap['quantity'];

              print('Fetching product with ID: $productId');

              // Fetch product details
              final productResponse = await Supabase.instance.client
                  .from('Products_Table')
                  .select()
                  .eq('Product_id', productId)
                  .maybeSingle();

              if (productResponse != null) {
                // Debug: Print discounted price field only
                print('Product ID: $productId');
                print(
                    'Discounted_Price: ${productResponse['Discounted_Price']}');

                // Handle ImageURL array - get first image or empty string
                String imageUrl = '';
                final imageUrlRaw = productResponse['ImageURL'];

                if (imageUrlRaw != null) {
                  if (imageUrlRaw is List && imageUrlRaw.isNotEmpty) {
                    // If it's an array, take the first image
                    imageUrl = imageUrlRaw[0]?.toString() ?? '';
                  } else if (imageUrlRaw is String) {
                    // If it's already a string
                    imageUrl = imageUrlRaw;
                  } else {
                    // Try to parse as JSON array
                    try {
                      final decoded = jsonDecode(imageUrlRaw.toString());
                      if (decoded is List && decoded.isNotEmpty) {
                        imageUrl = decoded[0]?.toString() ?? '';
                      }
                    } catch (e) {
                      print('Error parsing ImageURL: $e');
                      imageUrl = '';
                    }
                  }
                }

                items.add({
                  'productId': productId,
                  'quantity': quantity,
                  'name': productResponse['Product_Name']?.toString() ??
                      'Unknown Product',
                  'price':
                      (productResponse['Discounted_Price'] ?? 0.0).toDouble(),
                  'imageUrl': imageUrl,
                  'category':
                      productResponse['Category_Name']?.toString() ?? '',
                });
                print('Added item: ${items.last}');
              } else {
                print('Product not found for ID: $productId');
              }
            } else {
              print('Item missing required fields: $itemMap');
            }
          }
        } catch (itemError) {
          print('Error processing item $i: $itemError');
          continue;
        }
      }

      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching cart data: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading cart: $e';
      });
    }
  }

  Future<void> removeFromCart(String productId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: const Text(
              'Are you sure you want to remove this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pushNamed('CartPage2');
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    // If user didn't confirm, return early
    if (confirmed != true) return;

    try {
      setState(() {
        isLoading = true;
      });

      // Fetch current cart data
      final clientResponse = await Supabase.instance.client
          .from('client_table')
          .select('CartList')
          .eq('Email', widget.userEmail)
          .maybeSingle();

      if (clientResponse == null) {
        throw Exception('Client not found');
      }

      final cartRaw = clientResponse['CartList'];
      List<dynamic> cartList = <dynamic>[];

      // Parse current cart
      if (cartRaw != null) {
        try {
          String cartString = '';
          if (cartRaw is String) {
            cartString = cartRaw;
          } else {
            cartString = jsonEncode(cartRaw);
          }

          final decoded = jsonDecode(cartString);
          if (decoded is List) {
            cartList = decoded.cast<dynamic>();
          }
        } catch (e) {
          if (cartRaw is Iterable) {
            cartList = cartRaw.toList().cast<dynamic>();
          }
        }
      }

      // Remove item with matching productId
      cartList.removeWhere((item) {
        if (item is Map) {
          return item['productid'].toString() == productId.toString();
        }
        return false;
      });

      // Update cart in database
      await Supabase.instance.client.from('client_table').update(
          {'CartList': jsonEncode(cartList)}).eq('Email', widget.userEmail);

      // Refresh the cart data
      await fetchCartData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item removed from cart'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to CartPage2 after successful removal
        Navigator.of(context).pushNamed('CartPage2');
      }
    } catch (e) {
      print('Error removing item from cart: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error removing item: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> refreshCart() async {
    await fetchCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: RefreshIndicator(
        onRefresh: refreshCart,
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
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchCartData,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : cartItems.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 200),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text('Your cart is empty'),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return _buildCartItem(cartItems[index], context);
                        },
                      ),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'].toString(),
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
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '\$${item['price']}',
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Quantity and Delete Button
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Qty: ${item['quantity']}',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => removeFromCart(item['productId'].toString()),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
