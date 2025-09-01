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

class CartContainerNew extends StatefulWidget {
  const CartContainerNew({
    super.key,
    this.width,
    this.height,
    required this.userEmail,
    this.refreshKey, // Add this parameter to force rebuild
  });

  final double? width;
  final double? height;
  final String userEmail;
  final String? refreshKey; // New parameter

  @override
  State<CartContainerNew> createState() => _CartContainerNewState();
}

class _CartContainerNewState extends State<CartContainerNew> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  String errorMessage = '';
  String? _lastRefreshKey;

  @override
  void initState() {
    super.initState();
    _lastRefreshKey = widget.refreshKey;
    fetchCartData();
  }

  @override
  void didUpdateWidget(CartContainerNew oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if refreshKey has changed or userEmail has changed
    if (widget.refreshKey != _lastRefreshKey ||
        widget.userEmail != oldWidget.userEmail) {
      _lastRefreshKey = widget.refreshKey;
      fetchCartData();
    }
  }

  Future<void> fetchCartData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'No authenticated user found';
        });
        return;
      }

      final clientResponse = await Supabase.instance.client
          .from('client_table')
          .select('CartList')
          .eq('Auth_ID', user.id) // not 'Email'
          .maybeSingle();

      if (clientResponse == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'No client found with this user';
        });
        return;
      }

      final cartRaw = clientResponse['CartList'];
      print('Raw cart data: $cartRaw');
      print('Cart data type: ${cartRaw.runtimeType}');

      List<dynamic> cartList = <dynamic>[];

      if (cartRaw == null) {
        print('CartList is null');
        cartList = <dynamic>[];
      } else {
        try {
          String cartString = '';

          if (cartRaw is String) {
            cartString = cartRaw;
          } else {
            cartString = jsonEncode(cartRaw);
          }

          print('Cart string: $cartString');

          final decoded = jsonDecode(cartString);

          if (decoded is List) {
            cartList = decoded.cast<dynamic>();
          } else {
            print('Decoded data is not a list: ${decoded.runtimeType}');
            cartList = <dynamic>[];
          }
        } catch (parseError) {
          print('Error parsing cart data: $parseError');
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

      final List<Map<String, dynamic>> items = <Map<String, dynamic>>[];

      for (int i = 0; i < cartList.length; i++) {
        try {
          final item = cartList[i];
          print('Processing item $i: $item');

          if (item != null) {
            Map<String, dynamic> itemMap = <String, dynamic>{};

            if (item is Map) {
              item.forEach((key, value) {
                itemMap[key.toString()] = value;
              });
            } else {
              print('Item is not a map: ${item.runtimeType}');
              continue;
            }

            if (itemMap.containsKey('productid') &&
                itemMap.containsKey('quantity')) {
              final productId = itemMap['productid'];
              final quantity = itemMap['quantity'];

              print('Fetching product with ID: $productId');

              final productResponse = await Supabase.instance.client
                  .from('public_products_view')
                  .select()
                  .eq('Product_id', productId)
                  .maybeSingle();

              if (productResponse != null) {
                String imageUrl = '';
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
                  'price': (productResponse['Discounted_Price'] ?? 0.0)
                      .toDouble(), // CartContainerNew: Using discounted price
                  'imageUrl': imageUrl,
                  'category':
                      productResponse['Category_Name']?.toString() ?? '',
                });
                print('Added item: ${items.last}');
                print(
                    'CartContainerNew: Added item with discounted price: ${productResponse['Discounted_Price']}');
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

  bool _isDeletingItem =
      false; // Add this flag to prevent concurrent operations

  Future<void> deleteCartItem(int productId) async {
    // Prevent multiple concurrent delete operations
    if (_isDeletingItem) {
      print('Delete operation already in progress, ignoring...');
      return;
    }

    try {
      _isDeletingItem = true; // Set flag to prevent concurrent operations

      setState(() {
        isLoading = true;
      });

      // Get the current authenticated user
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final clientResponse = await Supabase.instance.client
          .from('client_table')
          .select('CartList')
          .eq('Auth_ID', user.id) // Use Auth_ID instead of Email
          .maybeSingle();

      if (clientResponse == null) {
        throw Exception('No client found for this user');
      }

      final cartRaw = clientResponse['CartList'];
      List<dynamic> currentCartList = <dynamic>[];

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
            currentCartList = decoded.cast<dynamic>();
          }
        } catch (e) {
          print('Error parsing current cart data: $e');
          if (cartRaw is Iterable) {
            currentCartList = cartRaw.toList().cast<dynamic>();
          }
        }
      }

      currentCartList.removeWhere((item) {
        if (item is Map) {
          return item['productid'] == productId;
        }
        return false;
      });

      print('Updated cart list after deletion: $currentCartList');

      final cartListValue = currentCartList.isEmpty ? null : currentCartList;

      final updateResponse = await Supabase.instance.client
          .from('client_table')
          .update({'CartList': cartListValue}).eq(
              'Auth_ID', user.id); // Use Auth_ID instead of Email

      // Note: updateResponse is null when successful - this is normal Supabase behavior
      print('Database update response: $updateResponse (null means success)');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item removed from cart successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Rebuild the entire page to update subtotal and other calculated fields
        await Future.delayed(const Duration(milliseconds: 500));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pushReplacementNamed(
              'cartPage2'); // This rebuilds the entire page
        });
      }
    } catch (e) {
      print('Error deleting cart item: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error removing item from cart: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing item: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      _isDeletingItem = false; // Reset flag when operation completes
    }
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing while operation is in progress
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width / 4, // Responsive width
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pink circle with delete icon at the top
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E6), // Light pink background
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4569), // Pink color
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Remove this item from cart ?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Buttons Row
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextButton(
                          onPressed: _isDeletingItem
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Confirm button
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextButton(
                          onPressed: _isDeletingItem
                              ? null
                              : () async {
                                  Navigator.of(context).pop();
                                  await deleteCartItem(item['productId']);
                                },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFF1744), // Bright pink
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: _isDeletingItem
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Confirm'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                  ? const Center(
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
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16), // Only horizontal padding
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(cartItems[index], context);
                      },
                    ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      //padding: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16), // Add padding on all sides

      width: double.infinity,
      decoration: BoxDecoration(
        //color: FlutterFlowTheme.of(context).secondaryBackground,
        color: Color(0XFFf7f6f6),
        borderRadius: BorderRadius.circular(7),
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
          Stack(
            children: [
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFECEFF4), // Background color
                  border: Border.all(
                    color: Color(0xFFFFFFFF), // Border color
                    width: 5, // Border thickness
                  ),
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
              // Delete button
              Positioned(
                left: 8,
                bottom: 8,
                child: Material(
                  color: Colors.white,
                  shape: CircleBorder(),
                  elevation: 2,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () => _showDeleteConfirmation(context, item),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red[300],
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'].toString(),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins', // Set font to Poppins
                        fontWeight: FontWeight.w400,
                        fontSize: 13, // Set font size to 13
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                if (item['category'].toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item['category'].toString(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins', // Set font to Poppins
                          fontWeight: FontWeight.w400,
                          fontSize: 13, // Set font size to 13
                        ),
                  ),
                  SizedBox(height: 10),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 70,
                      //color: Colors.blue,
                      child: Text(
                        '\$ ${item['price']}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins', // Set font to Poppins
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.black // Set font size to 13
                            ),
                      ),
                    ),
                    ////
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        //color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                        color: Color(0XFFe5ebfc),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Qty: ${item['quantity']}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              //color: FlutterFlowTheme.of(context).primary,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}
