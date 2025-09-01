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

class PlanDetailsPhoneWidget extends StatefulWidget {
  // width and height parameters are accepted but not used internally
  const PlanDetailsPhoneWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width; // Parameter declared but not used
  final double? height; // Parameter declared but not used

  @override
  _PlanDetailsPhoneWidgetState createState() => _PlanDetailsPhoneWidgetState();
}

class _PlanDetailsPhoneWidgetState extends State<PlanDetailsPhoneWidget>
    with TickerProviderStateMixin {
  List<PlanTableRow>? planData;
  bool isLoading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fetchPlanData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlanData() async {
    try {
      print('DEBUG: Fetching plan data from Supabase - Action: fetchPlanData');

      final response = await SupaFlow.client
          .from('Plan_Table')
          .select()
          .order('Price', ascending: true);

      print(
          'DEBUG: Plan data fetched successfully - Action: fetchPlanDataSuccess');
      print('DEBUG: Number of plans retrieved: ${response.length}');

      setState(() {
        planData = response.map((json) => PlanTableRow(json)).toList();
        isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      print('DEBUG: Error fetching plan data - Action: fetchPlanDataError');
      print('DEBUG: Error details: $e');

      setState(() {
        isLoading = false;
      });
    }
  }

  void _onPlanTapped(String planName) {
    print('DEBUG: Plan container tapped - Action: planContainerTapped');
    print('DEBUG: Selected plan name: $planName');
    print('DEBUG: Previous selected plan: ${FFAppState().Plantype}');

    // Update the app state variable
    FFAppState().update(() {
      FFAppState().Plantype = planName;
    });

    print('DEBUG: App state updated successfully - Action: appStateUpdated');
    print('DEBUG: FFAppState.Plantype set to: ${FFAppState().Plantype}');

    // Trigger rebuild to update UI selection
    setState(() {});
    print('DEBUG: UI refreshed to show selection - Action: uiRefreshed');
  }

  // Improved responsive design methods
  int _getCrossAxisCount(double width) {
    if (width > 1200) return 3; // Large desktop
    if (width > 900) return 2; // Desktop/tablet
    if (width > 600) return 2; // Tablet
    return 1; // Mobile
  }

  double _getGridSpacing(double width) {
    if (width > 1200) return 40.0; // Large desktop
    if (width > 900) return 30.0; // Desktop
    if (width > 600) return 24.0; // Tablet
    return 20.0; // Mobile
  }

  double _getContainerPadding(double width) {
    if (width > 1200) return 60.0; // Large desktop
    if (width > 900) return 40.0; // Desktop
    if (width > 600) return 30.0; // Tablet
    return 20.0; // Mobile
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      print('DEBUG: Showing loading indicator - Action: showLoadingIndicator');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Loading Plans...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E88E5),
              ),
            ),
          ],
        ),
      );
    }

    if (planData == null || planData!.isEmpty) {
      print('DEBUG: No plan data available - Action: showNoDataMessage');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No plans available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for available plans',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    print('DEBUG: Rendering plan cards - Action: renderPlanCards');
    print('DEBUG: Number of plans to render: ${planData!.length}');

    // FIX 1: Wrap the main content in SingleChildScrollView to prevent overflow
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(_getContainerPadding(screenWidth)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header section with improved spacing
            Container(
              margin: EdgeInsets.only(
                bottom: screenWidth > 600 ? 40 : 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Choose Your Plan',
                    style: TextStyle(
                      fontSize: screenWidth > 900
                          ? 42
                          : screenWidth > 600
                              ? 36
                              : 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                  SizedBox(height: screenWidth > 600 ? 16 : 12),
                  Text(
                    'Select the perfect plan for your business needs',
                    style: TextStyle(
                      fontSize: screenWidth > 900
                          ? 20
                          : screenWidth > 600
                              ? 18
                              : 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Plans grid with improved layout
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animationController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeOutCubic,
                    )),
                    child: _buildResponsiveGrid(screenWidth),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // FIX 2: Improved responsive grid layout with better constraints
  Widget _buildResponsiveGrid(double screenWidth) {
    final crossAxisCount = _getCrossAxisCount(screenWidth);
    final spacing = _getGridSpacing(screenWidth);

    // Use different layouts based on screen size
    if (crossAxisCount == 1) {
      // Single column for mobile
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: planData!.map((plan) {
          final isSelected = FFAppState().Plantype == plan.planName;
          return Container(
            margin: EdgeInsets.only(bottom: spacing),
            child: _buildPlanCard(plan, isSelected, screenWidth),
          );
        }).toList(),
      );
    } else {
      // Multi-column for tablet and desktop using LayoutBuilder for better constraints
      return LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final cardWidth = (availableWidth - spacing * (crossAxisCount - 1)) /
              crossAxisCount;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            alignment: WrapAlignment.center,
            children: planData!.map((plan) {
              final isSelected = FFAppState().Plantype == plan.planName;
              return SizedBox(
                width: cardWidth,
                child: _buildPlanCard(plan, isSelected, screenWidth),
              );
            }).toList(),
          );
        },
      );
    }
  }

  // FIX 3: Improved plan card with better height management
  Widget _buildPlanCard(
      PlanTableRow plan, bool isSelected, double screenWidth) {
    print('DEBUG: Building card for plan: ${plan.planName}');

    return GestureDetector(
      onTap: () => _onPlanTapped(plan.planName ?? ''),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isSelected ? 1.02 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF10B981),
                  width: 3,
                )
              : Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF10B981).withOpacity(0.25)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isSelected ? 20 : 15,
              spreadRadius: isSelected ? 2 : 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            // FIX 4: Use IntrinsicHeight to ensure all cards have equal height
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header section
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth > 900
                          ? 28
                          : screenWidth > 600
                              ? 24
                              : 20,
                      horizontal: screenWidth > 900 ? 28 : 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isSelected
                            ? [
                                const Color(0xFF10B981),
                                const Color(0xFF059669),
                              ]
                            : [
                                const Color(0xFF1E88E5),
                                const Color(0xFF1565C0),
                              ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Selected badge
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Text(
                              'SELECTED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),

                        // Price with currency symbol
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth > 900
                                    ? 22
                                    : screenWidth > 600
                                        ? 20
                                        : 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                plan.price ?? '0.00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth > 900
                                      ? 42
                                      : screenWidth > 600
                                          ? 38
                                          : 32,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenWidth > 600 ? 8 : 6),
                        Text(
                          plan.planName ?? 'Plan Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth > 900
                                ? 18
                                : screenWidth > 600
                                    ? 16
                                    : 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // FIX 5: Content section with proper expansion
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(screenWidth > 900
                          ? 28
                          : screenWidth > 600
                              ? 24
                              : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product listings
                          if (plan.noOfProducts != null)
                            _buildFeatureItemSingleLine(
                              Icons.inventory_2_outlined,
                              'Product Listings',
                              'Up to ${plan.noOfProducts!.toInt()} Products',
                              screenWidth,
                            ),

                          // Features
                          if (plan.planDetails != null &&
                              plan.planDetails!.isNotEmpty)
                            _buildFeatureList(
                              Icons.featured_play_list_outlined,
                              'Features',
                              plan.planDetails!,
                              screenWidth,
                            ),

                          // Branding
                          if (plan.noOfBanners != null)
                            _buildFeatureItemSingleLine(
                              Icons.branding_watermark_outlined,
                              'Branding',
                              '${plan.noOfBanners!.toInt()} customizable shop banner',
                              screenWidth,
                            ),

                          // Membership
                          if (plan.yearMembership != null)
                            _buildFeatureItemSingleLine(
                              Icons.calendar_month_outlined,
                              'Membership',
                              '${plan.yearMembership!.toInt()} year${plan.yearMembership! > 1 ? 's' : ''}',
                              screenWidth,
                            ),

                          // Spacer to push button to bottom
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  // Action button fixed at bottom
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      left: screenWidth > 900
                          ? 28
                          : screenWidth > 600
                              ? 24
                              : 20,
                      right: screenWidth > 900
                          ? 28
                          : screenWidth > 600
                              ? 24
                              : 20,
                      bottom: screenWidth > 900
                          ? 28
                          : screenWidth > 600
                              ? 24
                              : 20,
                    ),
                    child: ElevatedButton(
                      onPressed: () => _onPlanTapped(plan.planName ?? ''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color(0xFF10B981)
                            : const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth > 900
                              ? 18
                              : screenWidth > 600
                                  ? 16
                                  : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isSelected ? 'Selected' : 'Choose Plan',
                        style: TextStyle(
                          fontSize: screenWidth > 900
                              ? 16
                              : screenWidth > 600
                                  ? 15
                                  : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItemSingleLine(
      IconData icon, String title, String description, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: screenWidth > 600 ? 16.0 : 12.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth > 600 ? 8 : 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: screenWidth > 900
                  ? 20
                  : screenWidth > 600
                      ? 18
                      : 16,
              color: const Color(0xFF1E88E5),
            ),
          ),
          SizedBox(width: screenWidth > 600 ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth > 900
                        ? 15
                        : screenWidth > 600
                            ? 14
                            : 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
                SizedBox(height: screenWidth > 600 ? 4 : 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: screenWidth > 900
                        ? 14
                        : screenWidth > 600
                            ? 13
                            : 11,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FIX 6: Improved feature list with better text handling
  Widget _buildFeatureList(
      IconData icon, String title, String planDetails, double screenWidth) {
    final features =
        planDetails.split('\n').where((f) => f.trim().isNotEmpty).toList();
    // Reduce max features to prevent overflow
    final maxFeaturesToShow = screenWidth > 900 ? 2 : 1;
    final featuresToDisplay = features.take(maxFeaturesToShow).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: screenWidth > 600 ? 16.0 : 12.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth > 600 ? 8 : 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: screenWidth > 900
                  ? 20
                  : screenWidth > 600
                      ? 18
                      : 16,
              color: const Color(0xFF1E88E5),
            ),
          ),
          SizedBox(width: screenWidth > 600 ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth > 900
                        ? 15
                        : screenWidth > 600
                            ? 14
                            : 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
                SizedBox(height: screenWidth > 600 ? 4 : 2),
                ...featuresToDisplay.map((feature) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: screenWidth > 600 ? 3.0 : 2.0,
                    ),
                    child: Text(
                      feature.trim(),
                      style: TextStyle(
                        fontSize: screenWidth > 900
                            ? 14
                            : screenWidth > 600
                                ? 13
                                : 11,
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                // Show "and more..." if there are more features
                if (features.length > maxFeaturesToShow)
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenWidth > 600 ? 2.0 : 1.0,
                    ),
                    child: Text(
                      '+${features.length - maxFeaturesToShow} more',
                      style: TextStyle(
                        fontSize: screenWidth > 900
                            ? 13
                            : screenWidth > 600
                                ? 12
                                : 10,
                        color: const Color(0xFF9CA3AF),
                        fontStyle: FontStyle.italic,
                      ),
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

// Data model for Plan_Table
class PlanTableRow {
  final int? id;
  final DateTime? createdAt;
  final String? planName;
  final String? price;
  final String? planDetails;
  final double? noOfProducts;
  final double? noOfBanners;
  final double? yearMembership;

  PlanTableRow(Map<String, dynamic> data)
      : id = data['id'],
        createdAt = data['created_at'] != null
            ? DateTime.parse(data['created_at'])
            : null,
        planName = data['Plan_Name'],
        price = data['Price']?.toString(),
        planDetails = data['Plan_Details'],
        noOfProducts = data['No_of_Products']?.toDouble(),
        noOfBanners = data['No_of_Banners']?.toDouble(),
        yearMembership = data['Year_Membership']?.toDouble();
}
