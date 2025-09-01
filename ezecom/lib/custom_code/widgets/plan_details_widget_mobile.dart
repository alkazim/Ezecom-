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

class PlanDetailsWidgetMobile extends StatefulWidget {
  const PlanDetailsWidgetMobile({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _PlanDetailsWidgetMobileState createState() =>
      _PlanDetailsWidgetMobileState();
}

class _PlanDetailsWidgetMobileState extends State<PlanDetailsWidgetMobile>
    with TickerProviderStateMixin {
  List<PlanTableRow>? planData;
  bool isLoading = true;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchPlanData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlanData() async {
    try {
      final response = await SupaFlow.client
          .from('Plan_Table')
          .select()
          .order('Price', ascending: true);

      setState(() {
        planData = response.map((json) => PlanTableRow(json)).toList();
        isLoading = false;
      });

      if (planData!.isNotEmpty &&
          (FFAppState().Plantype == null || FFAppState().Plantype.isEmpty)) {
        _updatePlanSelection(planData![0].planName ?? '');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updatePlanSelection(String planName) {
    FFAppState().update(() {
      FFAppState().Plantype = planName;
    });
    setState(() {});
  }

  void _onPlanTapped(String planName) {
    _updatePlanSelection(planName);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildFeatureItem(String text, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: isHighlighted ? Colors.white : Colors.grey[700],
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isHighlighted ? Colors.white : Colors.grey[700],
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(PlanTableRow plan, bool isSelected) {
    final Color selectedColor = Color(0xFF3bbcf7);
    final Color unselectedColor = Color(0xFF004cff);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? selectedColor : unselectedColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => _onPlanTapped(plan.planName ?? ''),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor : unselectedColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'SELECTED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${plan.price ?? '0'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      plan.planName ?? 'Plan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Features
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plan.noOfProducts != null)
                      _buildFeatureItem(
                          'Up to ${plan.noOfProducts!.toInt()} Product Listings'),
                    if (plan.noOfBanners != null)
                      _buildFeatureItem(
                          '${plan.noOfBanners!.toInt()} Shop Banner${plan.noOfBanners! > 1 ? 's' : ''}'),
                    if (plan.yearMembership != null)
                      _buildFeatureItem(
                          '${plan.yearMembership!.toInt()} Year${plan.yearMembership! > 1 ? 's' : ''} Membership'),
                    if (plan.planDetails != null &&
                        plan.planDetails!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Features Include:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...plan.planDetails!
                          .split('\n')
                          .where((feature) => feature.trim().isNotEmpty)
                          .take(4)
                          .map((feature) => _buildFeatureItem(feature.trim()))
                          .toList(),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _onPlanTapped(plan.planName ?? ''),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? selectedColor : unselectedColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isSelected ? 'Selected Plan' : 'Choose Plan',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF3bbcf7) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading Plans...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (planData == null || planData!.isEmpty) {
      return Center(
        child: Text(
          'No plans available',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          // Header
          const SizedBox(height: 16),
          Text(
            'Choose Your Plan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004cff),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the perfect plan for your needs',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // Plans PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: planData!.length,
              itemBuilder: (context, pageIndex) {
                final plan = planData![pageIndex];
                final isSelected = FFAppState().Plantype == plan.planName;
                return _buildPlanCard(plan, isSelected);
              },
            ),
          ),

          // Page Indicator
          if (planData!.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  planData!.length,
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
