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

class BulletPointsWidget extends StatefulWidget {
  final String description;
  final double? width;
  final double? height; // We will ignore this parameter in the build method

  const BulletPointsWidget({
    Key? key,
    required this.description,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _BulletPointsWidgetState createState() => _BulletPointsWidgetState();
}

class _BulletPointsWidgetState extends State<BulletPointsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Device type detection
          final screenWidth = constraints.maxWidth;
          final isDesktop = screenWidth >= 1200;
          final isTablet = screenWidth >= 768 && screenWidth < 1200;
          final isWeb = screenWidth >= 600;
          final isMobile = screenWidth < 600;

          // Responsive dimensions
          final double fontSize = _getResponsiveFontSize(screenWidth);
          final double titleFontSize = fontSize + (isDesktop ? 6 : 4);
          final double bulletSize = _getResponsiveBulletSize(screenWidth);
          final double verticalSpacing = _getResponsiveSpacing(screenWidth);
          final double horizontalPadding =
              _getResponsiveHorizontalPadding(screenWidth);
          final double bulletRightMargin =
              _getResponsiveBulletMargin(screenWidth);

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalSpacing,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isDesktop ? 12 : 8),
              border: Border.all(
                color: const Color(0xFF31B9F7),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "About this item",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF232F3E),
                    letterSpacing: -0.3,
                  ),
                ),

                SizedBox(height: verticalSpacing),

                // Bullet points
                ...parseDescription(widget.description)
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final point = entry.value;
                  return _buildBulletPoint(
                    point,
                    fontSize,
                    bulletSize,
                    verticalSpacing,
                    bulletRightMargin,
                    index ==
                        parseDescription(widget.description).length -
                            1, // isLast
                    screenWidth,
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  double _getResponsiveFontSize(double screenWidth) {
    if (screenWidth >= 1200) return 16.0; // Desktop
    if (screenWidth >= 768) return 15.0; // Tablet
    if (screenWidth >= 600) return 14.5; // Large mobile/small tablet
    return 14.0; // Mobile
  }

  double _getResponsiveBulletSize(double screenWidth) {
    if (screenWidth >= 1200) return 6.0; // Desktop
    if (screenWidth >= 768) return 5.5; // Tablet
    if (screenWidth >= 600) return 5.0; // Large mobile
    return 4.5; // Mobile
  }

  double _getResponsiveSpacing(double screenWidth) {
    if (screenWidth >= 1200) return 18.0; // Desktop
    if (screenWidth >= 768) return 16.0; // Tablet
    if (screenWidth >= 600) return 14.0; // Large mobile
    return 12.0; // Mobile
  }

  double _getResponsiveHorizontalPadding(double screenWidth) {
    if (screenWidth >= 1200) return 28.0; // Desktop
    if (screenWidth >= 768) return 24.0; // Tablet
    if (screenWidth >= 600) return 20.0; // Large mobile
    return 16.0; // Mobile
  }

  double _getResponsiveBulletMargin(double screenWidth) {
    if (screenWidth >= 1200) return 14.0; // Desktop
    if (screenWidth >= 768) return 12.0; // Tablet
    if (screenWidth >= 600) return 10.0; // Large mobile
    return 8.0; // Mobile
  }

  Widget _buildBulletPoint(
    Map<String, String> pointData,
    double fontSize,
    double bulletSize,
    double verticalSpacing,
    double bulletRightMargin,
    bool isLast,
    double screenWidth,
  ) {
    final String title = pointData['title']!;
    final String description = pointData['description']!;
    final bool isDesktop = screenWidth >= 1200;
    final bool isTablet = screenWidth >= 768;

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : verticalSpacing * 0.8),
      padding: EdgeInsets.symmetric(
        vertical: verticalSpacing * 0.4,
        horizontal: isDesktop ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet point
          Container(
            margin: EdgeInsets.only(
              top: fontSize * 0.4,
              right: bulletRightMargin,
            ),
            width: bulletSize,
            height: bulletSize,
            decoration: BoxDecoration(
              color: const Color(0xFF232F3E),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),

          // Text content
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: fontSize,
                  color: const Color(0xFF0F1111),
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF232F3E),
                      fontSize: fontSize + (isDesktop ? 1 : 0.5),
                    ),
                  ),
                  TextSpan(
                    text: ': ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF232F3E),
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle(
                      color: const Color(0xFF565959),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> parseDescription(String description) {
    if (description.isEmpty) return [];

    List<Map<String, String>> points = [];

    // Clean the description
    String cleanedDescription =
        description.trim().replaceAll(RegExp(r'\s+'), ' ');

    // Method 1: Handle explicit bullet points (*, •, -, numbers)
    List<String> rawPoints = [];

    if (_hasBulletPoints(cleanedDescription)) {
      rawPoints = _parseBulletPoints(cleanedDescription);
    }
    // Method 2: Split by new lines
    else if (cleanedDescription.contains('\n')) {
      rawPoints = cleanedDescription
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();
    }
    // Method 3: Split by periods followed by capital letters (sentences)
    else if (cleanedDescription.contains(RegExp(r'\.(?=\s+[A-Z])'))) {
      rawPoints = cleanedDescription.split(RegExp(r'\.(?=\s+[A-Z])'));
    }
    // Method 4: Split by double spaces or common separators
    else if (cleanedDescription.contains(RegExp(r'  +')) ||
        cleanedDescription.contains(' | ') ||
        cleanedDescription.contains(' || ')) {
      rawPoints = cleanedDescription
          .split(RegExp(r'  +|\s+\|\s+|\s+\|\|\s+'))
          .where((part) => part.trim().isNotEmpty)
          .toList();
    }
    // Method 5: Try to split very long text into logical chunks
    else if (cleanedDescription.length > 200) {
      rawPoints = _splitLongText(cleanedDescription);
    }
    // Method 6: Use as single point if all else fails
    else {
      rawPoints = [cleanedDescription];
    }

    // Process each point
    for (String point in rawPoints) {
      point = point.trim();
      if (point.isEmpty || point.length < 8) continue;

      // Remove leading bullets/numbers
      point = point.replaceAll(RegExp(r'^[*•\-\d+\.\)\s]+'), '');

      // Add period if missing
      if (!point.endsWith('.') &&
          !point.endsWith('!') &&
          !point.endsWith('?')) {
        point += '.';
      }

      // Extract title and description
      String title = '';
      String description = '';

      // Look for colon or dash separators
      if (point.contains(':')) {
        List<String> parts = point.split(':');
        if (parts.length >= 2) {
          title = parts[0].trim();
          description = parts.sublist(1).join(':').trim();
        }
      } else if (point.contains(' - ')) {
        List<String> parts = point.split(' - ');
        if (parts.length >= 2) {
          title = parts[0].trim();
          description = parts.sublist(1).join(' - ').trim();
        }
      } else if (point.contains(' – ')) {
        List<String> parts = point.split(' – ');
        if (parts.length >= 2) {
          title = parts[0].trim();
          description = parts.sublist(1).join(' – ').trim();
        }
      } else {
        // No separator found, extract title from beginning
        description = point;
        title = _extractTitleFromDescription(point);
      }

      // Validate and clean title
      if (title.isNotEmpty) {
        title = title.replaceAll(RegExp(r'^[*•\-\s]+'), '');
        if (title.length > 50) {
          // Title too long, extract shorter version
          title = _extractTitleFromDescription(point);
        }
      }

      // Ensure we have both title and description
      if (title.isNotEmpty && description.isNotEmpty && title.length > 2) {
        points.add({
          'title': title,
          'description': description,
        });
      } else if (point.length > 10) {
        // Fallback: create point with extracted title
        points.add({
          'title': _extractTitleFromDescription(point),
          'description': point,
        });
      }
    }

    // If no points were parsed, create a single point
    if (points.isEmpty) {
      points.add({
        'title': 'Product Information',
        'description': cleanedDescription,
      });
    }

    return points;
  }

  bool _hasBulletPoints(String text) {
    return text.contains(RegExp(r'[*•\-]\s')) ||
        text.contains(RegExp(r'^\d+[\.\)]\s', multiLine: true));
  }

  List<String> _parseBulletPoints(String text) {
    // Split by bullet points
    List<String> points = text
        .split(RegExp(r'(?=[*•\-]\s)|(?=^\d+[\.\)]\s)', multiLine: true))
        .where((point) => point.trim().isNotEmpty)
        .toList();

    // Remove the first empty element if it exists
    if (points.isNotEmpty && points.first.trim().isEmpty) {
      points.removeAt(0);
    }

    return points;
  }

  List<String> _splitLongText(String text) {
    List<String> points = [];

    // Try to split by common patterns first
    if (text.contains(RegExp(r'[.!?]\s+(?=[A-Z])'))) {
      List<String> sentences = text.split(RegExp(r'[.!?]\s+(?=[A-Z])'));
      String currentChunk = '';

      for (String sentence in sentences) {
        if (currentChunk.isEmpty) {
          currentChunk = sentence;
        } else if (currentChunk.length + sentence.length < 150) {
          currentChunk += '. ' + sentence;
        } else {
          if (!currentChunk.endsWith('.')) currentChunk += '.';
          points.add(currentChunk);
          currentChunk = sentence;
        }
      }

      if (currentChunk.isNotEmpty) {
        if (!currentChunk.endsWith('.')) currentChunk += '.';
        points.add(currentChunk);
      }
    } else {
      // Split by word count if no sentences
      List<String> words = text.split(' ');
      for (int i = 0; i < words.length; i += 25) {
        String chunk = words
            .sublist(i, (i + 25 > words.length) ? words.length : i + 25)
            .join(' ');
        if (chunk.trim().isNotEmpty) {
          points.add(chunk);
        }
      }
    }

    return points;
  }

  String _extractTitleFromDescription(String text) {
    // Remove leading bullets/asterisks
    text = text.replaceAll(RegExp(r'^[*•\-\d+\.\)\s]+'), '');

    // Extract first few words as title
    List<String> words = text.split(' ');
    if (words.length >= 2) {
      // Look for logical breaking points
      for (int i = 2; i < words.length && i < 8; i++) {
        String potentialTitle = words.sublist(0, i).join(' ');

        // Check if this forms a good title (ends with adjective, noun, etc.)
        if (potentialTitle.length > 8 && potentialTitle.length < 40) {
          String lastWord = words[i - 1].toLowerCase();
          // Good title ending words
          if (lastWord.endsWith('ing') ||
              lastWord.endsWith('ed') ||
              lastWord.endsWith('er') ||
              lastWord.endsWith('ly') ||
              lastWord.endsWith('al') ||
              lastWord.endsWith('ic') ||
              lastWord.endsWith('ous') ||
              lastWord.endsWith('ful') ||
              _isNoun(lastWord)) {
            return potentialTitle;
          }
        }
      }

      // Fallback to first 2-4 words based on length
      if (words.length >= 4) {
        String shortTitle = words.sublist(0, 3).join(' ');
        if (shortTitle.length > 15) {
          return shortTitle;
        } else {
          return words.sublist(0, 4).join(' ');
        }
      } else {
        return words.sublist(0, 2).join(' ');
      }
    }

    return 'Product Feature';
  }

  bool _isNoun(String word) {
    // Common noun endings and words
    List<String> nounEndings = [
      'ity',
      'ness',
      'ment',
      'tion',
      'sion',
      'ance',
      'ence',
      'ing'
    ];
    List<String> commonNouns = [
      'quality',
      'design',
      'feature',
      'material',
      'performance',
      'comfort',
      'style',
      'durability',
      'functionality'
    ];

    return nounEndings.any((ending) => word.endsWith(ending)) ||
        commonNouns.contains(word.toLowerCase());
  }
}

// Example usage for testing
class BulletPointsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Multiple test cases to show flexibility
    const sampleDescription1 = '''
Durable and Long-Lasting: This six-piece kitchen knife set features high-quality stainless steel blades that ensure durability and longevity, making it a worthwhile investment for any home chef or professional cook.
Sustainable and Eco-Friendly: The wood grain rubber handle not only provides a comfortable grip but also aligns with environmentally conscious consumers who value sustainable kitchen accessories.
Comprehensive Set: This knife set includes a variety of essential knives, catering to the needs of both novice and experienced cooks, including a chef's knife, carving knife, and more.
    ''';

    const sampleDescription2 = '''
• Premium Quality Materials - Made from high-grade stainless steel for maximum durability
• Ergonomic Design - Comfortable grip reduces hand fatigue during extended use
• Versatile Functionality - Suitable for chopping, slicing, dicing, and mincing
• Easy Maintenance - Dishwasher safe and stain-resistant surface
    ''';

    const sampleDescription3 = '''
1. Advanced Technology: Features cutting-edge innovation for superior performance
2. User-Friendly Interface: Simple and intuitive controls for effortless operation
3. Energy Efficient: Consumes 40% less power than traditional models
4. Compact Design: Space-saving form factor perfect for modern kitchens
    ''';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Flexible Bullet Points Widget'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Test Case 1: Colon separated format
            Container(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Format 1: Colon Separated',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  BulletPointsWidget(description: sampleDescription1),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Test Case 2: Bullet points with dashes
            Container(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Format 2: Bullet Points with Dashes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  BulletPointsWidget(description: sampleDescription2),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Test Case 3: Numbered list
            Container(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Format 3: Numbered List',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  BulletPointsWidget(description: sampleDescription3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
