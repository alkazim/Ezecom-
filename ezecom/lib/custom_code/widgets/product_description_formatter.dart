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

// If the above import doesn't work, use this alternative:
// import '../flutter_flow/flutter_flow_theme.dart';

class ProductDescriptionFormatter extends StatefulWidget {
  const ProductDescriptionFormatter({
    super.key,
    this.width,
    this.height,
    required this.description,
  });

  final double? width;
  final double? height;
  final String description;

  @override
  State<ProductDescriptionFormatter> createState() =>
      _ProductDescriptionFormatterState();
}

class _ProductDescriptionFormatterState
    extends State<ProductDescriptionFormatter> {
  late List<Map<String, String>> specs;

  @override
  void initState() {
    super.initState();
    specs = _parseDescription(widget.description);
  }

  @override
  void didUpdateWidget(ProductDescriptionFormatter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.description != widget.description) {
      specs = _parseDescription(widget.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: specs.map((spec) => _buildSpecRow(spec)).toList(),
      ),
    );
  }

  Widget _buildSpecRow(Map<String, String> spec) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  spec['label']!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge?.color ??
                        Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  spec['value']!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.black54,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          if (specs.indexOf(spec) < specs.length - 1)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
              child: Container(
                width: double.infinity,
                height: 1,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, String>> _parseDescription(String description) {
    final List<Map<String, String>> specs = [];

    // Common specification patterns
    final patterns = [
      RegExp(r'Screen Size(\d+(?:\.\d+)?)\s*Inches?', caseSensitive: false),
      RegExp(
          r'Brand\s+([A-Za-z0-9\s]+?)(?=Display|Resolution|Refresh|Special|$)',
          caseSensitive: false),
      RegExp(
          r'Display\s+Technology\s+([A-Za-z0-9\s]+?)(?=Resolution|Refresh|Special|Brand|Screen|$)',
          caseSensitive: false),
      RegExp(
          r'Resolution\s+([A-Za-z0-9\s]+?)(?=Refresh|Special|Brand|Screen|Display|$)',
          caseSensitive: false),
      RegExp(r'Refresh Rate\s+(\d+(?:\.\d+)?)\s*Hz', caseSensitive: false),
      RegExp(
          r'Special Feature\s+(.+?)(?=Brand|Screen|Display|Resolution|Refresh|$)',
          caseSensitive: false),
    ];

    // Extract Screen Size
    final screenSizeMatch = patterns[0].firstMatch(description);
    if (screenSizeMatch != null) {
      specs.add({
        'label': 'Screen Size',
        'value': '${screenSizeMatch.group(1)} Inches'
      });
    }

    // Extract Brand
    final brandMatch = patterns[1].firstMatch(description);
    if (brandMatch != null) {
      specs.add({'label': 'Brand', 'value': brandMatch.group(1)!.trim()});
    }

    // Extract Display Technology
    final displayMatch = patterns[2].firstMatch(description);
    if (displayMatch != null) {
      specs.add({
        'label': 'Display Technology',
        'value': displayMatch.group(1)!.trim()
      });
    }

    // Extract Resolution
    final resolutionMatch = patterns[3].firstMatch(description);
    if (resolutionMatch != null) {
      specs.add(
          {'label': 'Resolution', 'value': resolutionMatch.group(1)!.trim()});
    }

    // Extract Refresh Rate
    final refreshMatch = patterns[4].firstMatch(description);
    if (refreshMatch != null) {
      specs.add(
          {'label': 'Refresh Rate', 'value': '${refreshMatch.group(1)} Hz'});
    }

    // Extract Special Features
    final specialMatch = patterns[5].firstMatch(description);
    if (specialMatch != null) {
      String features = specialMatch.group(1)!.trim();
      features = _formatSpecialFeatures(features);
      specs.add({'label': 'Special Feature', 'value': features});
    }

    // Fallback: if no patterns matched, try to parse manually
    if (specs.isEmpty) {
      specs.addAll(_fallbackParse(description));
    }

    return specs;
  }

  String _formatSpecialFeatures(String features) {
    final featureList = features
        .split('|')
        .map((f) => f.trim())
        .where((f) => f.isNotEmpty)
        .toList();

    if (featureList.length <= 2) {
      return featureList.join(' | ');
    }

    String formatted = '';
    for (int i = 0; i < featureList.length; i++) {
      if (i == 0) {
        formatted += featureList[i];
      } else if (i % 2 == 0 && i > 0) {
        formatted += ' |\n                                   ${featureList[i]}';
      } else {
        formatted += ' | ${featureList[i]}';
      }
    }

    return formatted;
  }

  List<Map<String, String>> _fallbackParse(String description) {
    final List<Map<String, String>> specs = [];

    final words = description.split(RegExp(r'(?=[A-Z][a-z])'));

    String currentKey = '';
    String currentValue = '';

    for (String word in words) {
      word = word.trim();
      if (word.isEmpty) continue;

      if (_isSpecificationKey(word)) {
        if (currentKey.isNotEmpty && currentValue.isNotEmpty) {
          specs.add({'label': currentKey.trim(), 'value': currentValue.trim()});
        }
        currentKey = word;
        currentValue = '';
      } else {
        currentValue += ' $word';
      }
    }

    if (currentKey.isNotEmpty && currentValue.isNotEmpty) {
      specs.add({'label': currentKey.trim(), 'value': currentValue.trim()});
    }

    return specs;
  }

  bool _isSpecificationKey(String word) {
    final commonKeys = [
      'screen',
      'size',
      'brand',
      'display',
      'technology',
      'resolution',
      'refresh',
      'rate',
      'special',
      'feature',
      'color',
      'connectivity',
      'weight',
      'dimensions',
      'power',
      'warranty'
    ];

    return commonKeys.any((key) => word.toLowerCase().contains(key));
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
