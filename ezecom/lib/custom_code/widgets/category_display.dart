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

class CategoryDisplay extends StatefulWidget {
  const CategoryDisplay({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  State<CategoryDisplay> createState() => _CategoryDisplayState();
}

class _CategoryDisplayState extends State<CategoryDisplay> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    print('CategoryDisplay: Widget initialized');
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      print('CategoryDisplay: Starting to fetch categories from Supabase');
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await SupaFlow.client
          .from('Categories_Table')
          .select('Category_ID, Category_Name, ImageURL')
          .neq('Category_ID', 'EZE013')
          .order('created_at', ascending: true);

      print(
          'CategoryDisplay: Supabase response received: ${response.length} categories');

      setState(() {
        categories = (response as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        isLoading = false;
      });

      print(
          'CategoryDisplay: Categories loaded successfully: ${categories.length} items');
      for (var category in categories) {
        print(
            'CategoryDisplay: Category - Name: ${category['Category_Name']}, ImageURL: ${category['ImageURL']}');
      }
    } catch (e) {
      print('CategoryDisplay: Error fetching categories: $e');
      setState(() {
        errorMessage = 'Failed to load categories: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _refreshCategories() async {
    print('CategoryDisplay: Refreshing categories');
    await _fetchCategories();
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    final categoryName = category['Category_Name']?.toString() ?? '';
    print('CategoryDisplay: Category tapped - Name: $categoryName');

    try {
      context.pushNamed(
        'FilterPageCategories',
        queryParameters: {
          'categoryName': categoryName,
        }.withoutNulls,
      );
      print(
          'CategoryDisplay: Navigation to FilterPageCategories successful with categoryName: $categoryName');
    } catch (e) {
      print('CategoryDisplay: Navigation error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error navigating: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        'CategoryDisplay: Building main widget - isLoading: $isLoading, categories count: ${categories.length}');
    return _buildContent();
  }

  Widget _buildContent() {
    print('CategoryDisplay: _buildContent called - Determining content type');
    if (isLoading) {
      print('CategoryDisplay: Showing loading indicator');
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (errorMessage != null) {
      print('CategoryDisplay: Showing error state');
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: FlutterFlowTheme.of(context).error,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage ?? 'An error occurred',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshCategories,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (categories.isEmpty) {
      print('CategoryDisplay: No categories found - Showing empty state');
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: const SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'No categories found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      );
    } else {
      print(
          'CategoryDisplay: Building categories UI for ${categories.length} items');
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Categories',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            _buildResponsiveGrid(),
            const SizedBox(height: 20), // Add extra spacing at bottom
          ],
        ),
      );
    }
  }

  Widget _buildResponsiveGrid() {
    print(
        'CategoryDisplay: _buildResponsiveGrid called - Creating responsive grid');
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns and spacing based on screen width
        int columns;
        double horizontalPadding;
        double spacing;

        if (constraints.maxWidth > 1200) {
          columns = 5;
          horizontalPadding = 24.0;
          spacing = 20.0;
        } else if (constraints.maxWidth > 800) {
          columns = 4;
          horizontalPadding = 20.0;
          spacing = 16.0;
        } else if (constraints.maxWidth > 500) {
          columns = 3;
          horizontalPadding = 16.0;
          spacing = 12.0;
        } else {
          columns = 2;
          horizontalPadding = 12.0;
          spacing = 10.0;
        }

        // Calculate card width with proper spacing
        final totalSpacing = (columns - 1) * spacing + (horizontalPadding * 2);
        final cardWidth = (constraints.maxWidth - totalSpacing) / columns;

        print(
            'CategoryDisplay: Screen width: ${constraints.maxWidth}, Columns: $columns, Card width: $cardWidth');

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            alignment: WrapAlignment.start,
            children: categories.map((category) {
              final categoryName = category['Category_Name']?.toString() ?? '';
              print(
                  'CategoryDisplay: Creating CategoryCard for: $categoryName');
              return SizedBox(
                width: cardWidth,
                height: cardWidth * 1.4, // Maintain aspect ratio
                child: CategoryCard(
                  category: category,
                  onTap: () => _onCategoryTap(category),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    print('CategoryDisplay: Widget disposed');
    super.dispose();
  }
}

class CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryName =
        category['Category_Name']?.toString() ?? 'Unnamed Category';
    final imageUrl = category['ImageURL']?.toString();

    print('CategoryCard: Building card for category: $categoryName');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image section with AspectRatio
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          print(
                              'CategoryCard: Image load error for $categoryName: $error');
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
                            Icon(Icons.category, size: 48, color: Colors.grey),
                      ),
              ),
            ),
            // Text section
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categoryName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Browse Category',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
