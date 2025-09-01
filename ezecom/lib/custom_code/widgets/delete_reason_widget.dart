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

//import '/flutter_flow/flutter_flow_theme.dart';

class DeleteReasonWidget extends StatefulWidget {
  const DeleteReasonWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  State<DeleteReasonWidget> createState() => _DeleteReasonWidgetState();
}

class _DeleteReasonWidgetState extends State<DeleteReasonWidget> {
  String? selectedReason;

  final List<String> deleteReasons = [
    "I'm not using the app",
    "I found a better alternative.",
    "The app didn't have the features or functionality I was looking for.",
    "I'm not satisfied with the quality of content.",
    "The app was difficult to navigate.",
    "Other"
  ];

  @override
  void initState() {
    super.initState();
    selectedReason =
        FFAppState().DeleteReason.isNotEmpty ? FFAppState().DeleteReason : null;
  }

  void _onReasonSelected(String reason) {
    setState(() {
      selectedReason = reason;
    });

    // Update FFAppState directly
    FFAppState().DeleteReason = reason;
    FFAppState().update(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: deleteReasons.map(_buildReasonItem).toList(),
      ),
    );
  }

  Widget _buildReasonItem(String reason) {
    final bool isSelected = selectedReason == reason;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _onReasonSelected(reason),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8F3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 12.0, top: 2.0),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
              Expanded(
                child: Text(
                  reason,
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF374151),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getResponsiveFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) {
      return 16.0;
    } else if (screenWidth > 768) {
      return 15.0;
    } else {
      return 14.0;
    }
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
