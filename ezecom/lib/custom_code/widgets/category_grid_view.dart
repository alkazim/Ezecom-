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

//import 'package:flutter/material.dart';

class CategoryGridView extends StatelessWidget {
  final List<String> categories;
  final int crossAxisCount;
  final double spacing;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final double shadowBlur;
  final double shadowOpacity;
  final Offset shadowOffset;

  const CategoryGridView({
    super.key,
    required this.categories,
    this.crossAxisCount = 2,
    this.spacing = 12.0,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 16.0,
    this.borderRadius = 12.0,
    this.shadowBlur = 6.0,
    this.shadowOpacity = 0.1,
    this.shadowOffset = const Offset(0, 2),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      padding: EdgeInsets.all(spacing),
      children:
          categories.map((category) => _buildCategoryItem(category)).toList(),
    );
  }

  Widget _buildCategoryItem(String title) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(shadowOpacity),
            blurRadius: shadowBlur,
            offset: shadowOffset,
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
