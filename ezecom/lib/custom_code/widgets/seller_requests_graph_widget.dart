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
import 'dart:math' as math;
import 'dart:ui' as ui;

/// FlutterFlow Custom Widget for Seller Requests Graph
class SellerRequestsGraphWidget extends StatefulWidget {
  const SellerRequestsGraphWidget({
    Key? key,
    this.width,
    this.height,
    required this.sellerEmail,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String sellerEmail;

  @override
  _SellerRequestsGraphWidgetState createState() =>
      _SellerRequestsGraphWidgetState();
}

class _SellerRequestsGraphWidgetState extends State<SellerRequestsGraphWidget> {
  List<DayData> weekData = [];
  bool isLoading = true;
  String? error;
  double maxValue = 100; // Initial value, will be calculated dynamically

  late DateTime
      _currentWeekEndDate; // Stores the end date of the week being displayed

  @override
  void initState() {
    super.initState();
    // Initialize to today's date for the current week view
    _currentWeekEndDate = DateTime.now();
    print(
        '[SellerRequestsGraphWidget] Widget initialized for seller: ${widget.sellerEmail}');
    _fetchDataFromSupabase();
  }

  Future<void> _fetchDataFromSupabase() async {
    print(
        '[SellerRequestsGraphWidget] _fetchDataFromSupabase called. Current _currentWeekEndDate: $_currentWeekEndDate');
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final supabase = Supabase.instance.client;
      // Debug current user
      final currentUser = supabase.auth.currentUser;
      print('[DEBUG] Current User ID: ${currentUser?.id}');
      print('[DEBUG] Current User Email: ${currentUser?.email}');

// Test if this user can access ANY data from the table
      final testResponse = await supabase
          .from('Enquiry_Table_FactoryThrough')
          .select('Seller_Auth_ID, Seller_Email')
          .eq('Seller_Email', widget.sellerEmail)
          .limit(1);

      print('[DEBUG] Test query result: $testResponse');

// Check specific policy conditions
      final policyTestResponse = await supabase
          .from('Enquiry_Table_FactoryThrough')
          .select('Seller_Auth_ID, Auth_ID, Payment_Status, is_email_sent')
          .eq('Seller_Email', widget.sellerEmail);

      print('[DEBUG] Policy test result: $policyTestResponse');

      // FIX: Use UTC dates to match Supabase timezone
      final endOfDayCurrentWeek = DateTime.utc(_currentWeekEndDate.year,
          _currentWeekEndDate.month, _currentWeekEndDate.day, 23, 59, 59);

      final startOfDayWeekAgo = DateTime.utc(_currentWeekEndDate.year,
              _currentWeekEndDate.month, _currentWeekEndDate.day, 0, 0, 0)
          .subtract(const Duration(days: 6));

      print(
          '[SellerRequestsGraphWidget] Fetching data for date range: ${startOfDayWeekAgo.toIso8601String()} to ${endOfDayCurrentWeek.toIso8601String()}');

      final response = await supabase
          .from('Enquiry_Table_FactoryThrough')
          .select('created_at')
          .eq('Seller_Email', widget.sellerEmail)
          .gte('created_at', startOfDayWeekAgo.toIso8601String())
          .lte('created_at', endOfDayCurrentWeek.toIso8601String());

      print(
          '[SellerRequestsGraphWidget] Raw data fetched: ${response.length} records.');
      // print('[SellerRequestsGraphWidget] Raw response data: $response'); // Uncomment for very detailed debug

      // Process data by day
      Map<String, int> dailyCounts = {};

      // Initialize all days of the *current view week* with 0
      for (int i = 0; i < 7; i++) {
        final date = startOfDayWeekAgo.add(Duration(days: i));
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        dailyCounts[dateKey] = 0;
        print(
            '[SellerRequestsGraphWidget] Initialized dailyCounts[$dateKey] = 0');
      }

      // Count requests per day
      for (final record in response) {
        final createdAt = DateTime.parse(record['created_at']);
        final dateKey =
            '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
        if (dailyCounts.containsKey(dateKey)) {
          dailyCounts[dateKey] = dailyCounts[dateKey]! + 1;
          print(
              '[SellerRequestsGraphWidget] Incrementing count for $dateKey. New count: ${dailyCounts[dateKey]}');
        } else {
          print(
              '[SellerRequestsGraphWidget] Warning: Data for $dateKey found, but not in initial week range. This should not happen if dates are correct.');
        }
      }

      print('[SellerRequestsGraphWidget] Final daily counts: $dailyCounts');

      // Convert to DayData list
      final List<DayData> processedData = [];
      final List<String> dayNames = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ];

      // Determine the starting day of the week for `dayNames` to align correctly.
      // Dart's DateTime.weekday: 1=Monday, ..., 7=Sunday
      int startDayIndex =
          (startOfDayWeekAgo.weekday - 1) % 7; // 0=Mon, ..., 6=Sun

      for (int i = 0; i < 7; i++) {
        final date = startOfDayWeekAgo.add(Duration(days: i));
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final dayName =
            dayNames[(startDayIndex + i) % 7]; // Correctly map day name

        // isToday check should be against the *actual* current date, not the date in view
        final now = DateTime.now();
        final bool isActualToday = date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
        final String dateString = '${date.day}/${date.month}';

        final double dayValue = dailyCounts[dateKey]!.toDouble();
        processedData.add(DayData(
          day: dayName,
          value: dayValue,
          isToday: isActualToday,
          date: dateString,
        ));
        print(
            '[SellerRequestsGraphWidget] DayData created: Day: $dayName, Date: $dateString, Value: $dayValue, IsToday: $isActualToday');
      }

      // Calculate max value for scaling
      final List<double> values = processedData.map((d) => d.value).toList();
      final double calculatedMax =
          values.isEmpty ? 0.0 : values.reduce(math.max);

      if (calculatedMax == 0) {
        maxValue = 10.0; // If all values are 0, set a default max to show axis
      } else {
        // Find the next nice rounded number for the max value
        if (calculatedMax <= 10) {
          maxValue = 10.0;
        } else if (calculatedMax <= 20) {
          maxValue = 20.0;
        } else if (calculatedMax <= 50) {
          maxValue = 50.0;
        } else {
          maxValue = ((calculatedMax / 100).ceil() * 100).toDouble();
          if (maxValue < calculatedMax * 1.2) {
            // Ensure at least 20% padding
            maxValue = calculatedMax * 1.2;
          }
          maxValue = ((maxValue / 10).ceil() * 10)
              .toDouble(); // Round to nearest 10 for better labels
        }
      }

      print(
          '[SellerRequestsGraphWidget] Max value calculated: $calculatedMax, Final maxValue for graph: $maxValue');

      setState(() {
        weekData = processedData;
        isLoading = false;
      });
    } catch (e, stackTrace) {
      print('[SellerRequestsGraphWidget] Error fetching data: $e');
      print('[SellerRequestsGraphWidget] Stack Trace: $stackTrace');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  // --- Navigation Methods ---
  void _goToPreviousWeek() {
    print('[SellerRequestsGraphWidget] Navigating to previous week.');
    setState(() {
      _currentWeekEndDate =
          _currentWeekEndDate.subtract(const Duration(days: 7));
    });
    _fetchDataFromSupabase(); // Reload data for the new week
  }

  void _goToNextWeek() {
    print('[SellerRequestsGraphWidget] Navigating to next week.');
    // Check if moving to the next week would go beyond the current actual week.
    // We want to stop at the week that contains "today".
    final DateTime actualToday = DateTime.now();
    final DateTime nextWeekCandidateEndDate =
        _currentWeekEndDate.add(const Duration(days: 7));

    // If the next week's start date (nextWeekCandidateEndDate - 6 days)
    // is after the actual current date, then we are trying to go too far.
    // Or simply, if the current viewed week end date is today or later, disable.
    if (nextWeekCandidateEndDate.isAfter(actualToday)) {
      print(
          '[SellerRequestsGraphWidget] Next week navigation disabled: Already at or beyond current week.');
      return; // Do not proceed if it's the current week or a future week
    }

    setState(() {
      _currentWeekEndDate = nextWeekCandidateEndDate;
    });
    _fetchDataFromSupabase(); // Reload data for the new week
  }
  // --- End Navigation Methods ---

  @override
  Widget build(BuildContext context) {
    print(
        '[SellerRequestsGraphWidget] Building widget. IsLoading: $isLoading, Error: $error');

    // Determine the start and end dates of the displayed week for the header
    final DateTime displayWeekStart =
        _currentWeekEndDate.subtract(const Duration(days: 6));
    final DateTime displayWeekEnd = _currentWeekEndDate;

    // Check if the current viewed week contains the actual current date
    final DateTime actualToday = DateTime.now();
    final bool isViewingCurrentWeek = actualToday
            .isAfter(displayWeekStart.subtract(const Duration(days: 1))) &&
        actualToday.isBefore(displayWeekEnd.add(const Duration(days: 1)));

    return Container(
      width: widget.width,
      height: widget.height ?? 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Navigation Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: _goToPreviousWeek,
                color: const Color(0xFF666666),
              ),
              Expanded(
                child: Text(
                  isViewingCurrentWeek
                      ? 'Last 7 Days'
                      : '${displayWeekStart.day}/${displayWeekStart.month} - ${displayWeekEnd.day}/${displayWeekEnd.month}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 20),
                // Disable if we're already at the current real-world week
                onPressed: isViewingCurrentWeek ? null : _goToNextWeek,
                color: isViewingCurrentWeek
                    ? Colors.grey[300]
                    : const Color(0xFF666666),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildGraphContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphContent() {
    if (isLoading) {
      print(
          '[SellerRequestsGraphWidget] _buildGraphContent: Displaying loading state.');
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
        ),
      );
    }

    if (error != null) {
      print(
          '[SellerRequestsGraphWidget] _buildGraphContent: Displaying error state: $error');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              'Error loading data',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchDataFromSupabase,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Check if there's no data or all values are zero
    if (weekData.isEmpty || weekData.every((day) => day.value == 0)) {
      print(
          '[SellerRequestsGraphWidget] _buildGraphContent: No data or all data is zero for this week.');
      return const Center(
        child: Text(
          'No data available for this week',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    print(
        '[SellerRequestsGraphWidget] _buildGraphContent: Displaying graph with ${weekData.length} data points. MaxValue: $maxValue');
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 400;

        print(
            '[SellerRequestsGraphWidget] LayoutBuilder: Screen size: ${constraints.maxWidth}x${constraints.maxHeight}');

        return CustomPaint(
          painter: GraphPainter(
            data: weekData,
            maxValue: maxValue,
            screenWidth: constraints.maxWidth,
            isSmallScreen: isSmallScreen,
          ),
          child: Container(),
        );
      },
    );
  }
}

class DayData {
  final String day;
  final double value;
  final bool isToday;
  final String date;

  DayData({
    required this.day,
    required this.value,
    this.isToday = false,
    required this.date,
  });
}

class GraphPainter extends CustomPainter {
  final List<DayData> data;
  final double maxValue;
  final double screenWidth;
  final bool isSmallScreen;

  GraphPainter({
    required this.data,
    required this.maxValue,
    required this.screenWidth,
    required this.isSmallScreen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    print(
        '[GraphPainter] paint method started. Canvas size: ${size.width}x${size.height}');
    print('[GraphPainter] Data points: ${data.length}, MaxValue: $maxValue');

    // Define paints
    final Paint barPaint = Paint()..style = PaintingStyle.fill;
    final Paint linePaint = Paint()
      ..color = const Color(0xFF007AFF)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final Paint gradientPaint = Paint()..style = PaintingStyle.fill;
    final Paint gridLinePaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1.0;
    final TextStyle axisLabelStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: isSmallScreen ? 10 : 12,
      fontWeight: FontWeight.w500,
    );
    final TextStyle dayLabelStyle = TextStyle(
      color: const Color(0xFF666666),
      fontSize: isSmallScreen ? 11 : 13,
      fontWeight: FontWeight.w400,
    );
    final TextStyle dayLabelStyleToday = TextStyle(
      color: const Color(0xFF007AFF),
      fontSize: isSmallScreen ? 11 : 13,
      fontWeight: FontWeight.w600,
    );
    final TextStyle dateLabelStyle = TextStyle(
      color: const Color(0xFF999999),
      fontSize: isSmallScreen ? 9 : 11,
      fontWeight: FontWeight.w400,
    );
    final TextStyle dateLabelStyleToday = TextStyle(
      color: const Color(0xFF007AFF),
      fontSize: isSmallScreen ? 9 : 11,
      fontWeight: FontWeight.w500,
    );

    // Calculate dimensions with more space for date labels and Y-axis labels
    final double yAxisLabelWidth =
        isSmallScreen ? 24.0 : 32.0; // Space for Y-axis labels
    final EdgeInsets padding = EdgeInsets.only(
      left: yAxisLabelWidth +
          (isSmallScreen ? 12.0 : 16.0), // Left padding for y-axis labels
      right: isSmallScreen ? 16.0 : 24.0,
      top: isSmallScreen ? 16.0 : 24.0,
      bottom: isSmallScreen
          ? 70.0
          : 80.0, // Increased bottom padding for day/date labels
    );

    final double chartWidth = size.width - padding.left - padding.right;
    final double chartHeight = size.height - padding.top - padding.bottom;

    final int totalBars = data.length;
    final double barWidth = chartWidth / totalBars;

    print(
        '[GraphPainter] Chart dimensions - width: $chartWidth, height: $chartHeight, barWidth: $barWidth, padding: $padding');

    // Draw Y-axis labels and horizontal grid lines
    // Define specific Y-axis values as per design (0, 100, 900)
    final List<double> yAxisValues = [0.0, 100.0, 900.0];

    // Adjust yAxisValues if maxValue is less than 900, to ensure labels are within range
    if (maxValue < 100) {
      yAxisValues.clear();
      yAxisValues.add(0.0);
      yAxisValues.add(maxValue / 2);
      yAxisValues.add(maxValue);
    } else if (maxValue < 900) {
      yAxisValues.clear();
      yAxisValues.add(0.0);
      yAxisValues.add(100.0);
      yAxisValues.add(maxValue);
    }
    // If maxValue >= 900, ensure 0, 100, 900, and maxValue are present
    if (maxValue > 900 && !yAxisValues.contains(900.0)) {
      yAxisValues.add(900.0);
      yAxisValues.add(maxValue);
      yAxisValues.sort(); // Ensure they are in order
    }

    for (final double value in yAxisValues) {
      if (value > maxValue) continue; // Don't draw labels above the max value
      final double yPosition =
          padding.top + chartHeight - (value / maxValue) * chartHeight;

      // Draw grid line (don't draw at y=0, draw for 100 and 900 as per design)
      if (value > 0) {
        canvas.drawLine(
          Offset(padding.left, yPosition),
          Offset(size.width - padding.right, yPosition),
          gridLinePaint,
        );
      }

      // Draw Y-axis label
      _drawText(
        canvas,
        value.toStringAsFixed(value.truncateToDouble() == value
            ? 0
            : 1), // Avoid .0 for whole numbers
        Offset(padding.left - yAxisLabelWidth / 2.0 - 4.0,
            yPosition), // Position to the left
        axisLabelStyle,
        alignment: TextAlign.right, // Align text to the right
      );
    }

    // Draw bars (background for all, no specific highlighting for today's bar)
    for (int i = 0; i < data.length; i++) {
      final DayData dayData = data[i];
      // Ensure barHeight is at least a minimum visible height even for 0 value
      final double barHeight = math.max(
          (dayData.value / maxValue) * chartHeight,
          dayData.value > 0 ? 4.0 : 0.0);
      final double x = padding.left + (i * barWidth);
      final double y = padding.top + chartHeight - barHeight;

      // Draw the background bar (light blue) for the entire column height
      barPaint.color = const Color(0xFFE3F2FD); // Light blue background
      final Rect backgroundBarRect = Rect.fromLTWH(
          x, padding.top, barWidth, chartHeight); // Full height background bar
      canvas.drawRect(backgroundBarRect, barPaint);

      // NO SPECIFIC HIGHLIGHTING FOR TODAY'S BAR HERE. All bars are light blue background.
      // If you later decide you want *some* highlight, but not the solid blue, you could
      // adjust this section. Currently, it will just be the light blue background.

      // Draw day labels
      _drawText(
        canvas,
        dayData.day,
        Offset(x + barWidth / 2.0, size.height - padding.bottom + 20.0),
        dayData.isToday
            ? dayLabelStyleToday
            : dayLabelStyle, // Day label (e.g., "Mon") still changes color for today
      );

      // Draw date labels below day labels
      _drawText(
        canvas,
        dayData.date,
        Offset(x + barWidth / 2.0, size.height - padding.bottom + 40.0),
        dayData.isToday
            ? dateLabelStyleToday
            : dateLabelStyle, // Date label (e.g., "23/6") still changes color for today
      );
    }

    // Draw line chart and gradient fill
    if (data.isNotEmpty) {
      final Path path = Path();
      final Path fillPath = Path();

      // Starting point for the line and fill path
      final double firstX = padding.left + (0 * barWidth) + barWidth / 2.0;
      final double firstY = padding.top +
          chartHeight -
          math.max((data[0].value / maxValue) * chartHeight,
              data[0].value > 0 ? 4.0 : 0.0);

      path.moveTo(firstX, firstY);
      fillPath.moveTo(firstX, chartHeight + padding.top);
      fillPath.lineTo(firstX, firstY);

      for (int i = 0; i < data.length; i++) {
        final DayData dayData = data[i];
        final double lineHeight = padding.top +
            chartHeight -
            math.max((dayData.value / maxValue) * chartHeight,
                dayData.value > 0 ? 4.0 : 0.0);
        final double x = padding.left + (i * barWidth) + barWidth / 2.0;
        final double y = lineHeight;

        path.lineTo(x, y);
        fillPath.lineTo(x, y);

        // Draw circle points (main color)
        final Paint circlePaint = Paint()
          ..color = const Color(0xFF007AFF)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(x, y),
          isSmallScreen ? 3.0 : 4.0,
          circlePaint,
        );

        // REMOVED: No specific white inner circle highlight for today's point.
        // The circle will always be the primary blue color.
      }

      // Close the fill path
      final double lastX =
          padding.left + ((data.length - 1) * barWidth) + barWidth / 2.0;
      fillPath.lineTo(lastX, chartHeight + padding.top);
      fillPath.lineTo(firstX, chartHeight + padding.top);
      fillPath.close();

      // Draw the gradient fill
      gradientPaint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF007AFF).withOpacity(0.5),
          const Color(0xFF007AFF).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0.0, padding.top, size.width, chartHeight));

      canvas.drawPath(fillPath, gradientPaint);

      // Draw the line path over the gradient
      canvas.drawPath(path, linePaint);
    }

    print('[GraphPainter] paint method finished.');
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style,
      {TextAlign alignment = TextAlign.center}) {
    final TextSpan textSpan = TextSpan(text: text, style: style);
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: alignment,
      textDirection:
          ui.TextDirection.ltr, // Corrected: using ui.TextDirection.ltr
    );

    textPainter.layout();
    double xOffset;
    if (alignment == TextAlign.right) {
      xOffset = offset.dx - textPainter.width;
    } else if (alignment == TextAlign.left) {
      xOffset = offset.dx;
    } else {
      // TextAlign.center
      xOffset = offset.dx - textPainter.width / 2.0;
    }
    canvas.save();
    canvas.translate(xOffset, offset.dy - textPainter.height / 2.0);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
