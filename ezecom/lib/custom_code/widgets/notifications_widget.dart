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

import 'dart:convert'; // Added this import for json.decode

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({
    Key? key,
    this.width,
    this.height,
    required this.email,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String email;

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  List<NotificationItem> notifications = [];
  bool isLoading = true;
  String? error;
  String? debugInfo;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
        debugInfo = null;
      });

      print(
          '🔍 DEBUG: Starting to load notifications for email: ${widget.email}');

      // Check if Supabase is initialized
      if (Supabase.instance.client == null) {
        throw Exception('Supabase client is not initialized');
      }

      print('🔍 DEBUG: Supabase client is available');

      // Fixed the query - removed quotes around Email since it's case sensitive
      final response = await Supabase.instance.client
          .from('client_table')
          .select('Notification')
          .eq('Email', widget.email)
          .single();

      print('🔍 DEBUG: Supabase response received: $response');

      if (response == null) {
        throw Exception('No data returned from Supabase');
      }

      if (response['Notification'] == null) {
        print('🔍 DEBUG: Notification field is null');
        setState(() {
          notifications = [];
          isLoading = false;
          debugInfo = 'No notifications found for this email';
        });
        return;
      }

      print('🔍 DEBUG: Raw notification data: ${response['Notification']}');

      // Handle both String and List types
      dynamic notificationData = response['Notification'];
      List<dynamic> parsedData;

      if (notificationData is String) {
        parsedData = json.decode(notificationData);
      } else if (notificationData is List) {
        parsedData = notificationData;
      } else {
        throw Exception(
            'Unexpected notification data type: ${notificationData.runtimeType}');
      }

      print('🔍 DEBUG: Parsed notification data: $parsedData');

      notifications = parsedData.map((item) {
        print('🔍 DEBUG: Processing notification item: $item');
        return NotificationItem.fromJson(Map<String, dynamic>.from(item));
      }).toList();

      print(
          '🔍 DEBUG: Successfully parsed ${notifications.length} notifications');

      // Sort by time (newest first)
      notifications.sort((a, b) => b.time.compareTo(a.time));

      setState(() {
        isLoading = false;
        debugInfo = 'Successfully loaded ${notifications.length} notifications';
      });
    } catch (e, stackTrace) {
      print('🔍 DEBUG: Error occurred: $e');
      print('🔍 DEBUG: Stack trace: $stackTrace');

      setState(() {
        error = e.toString();
        isLoading = false;
        debugInfo = 'Error: $e';
      });
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else {
        return '${difference.inDays} days ago';
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours >= 12) {
        // Show time in PM/AM format for same day
        final hour = time.hour > 12
            ? time.hour - 12
            : time.hour == 0
                ? 12
                : time.hour;
        final period = time.hour >= 12 ? 'PM' : 'AM';
        return '${hour}:${time.minute.toString().padLeft(2, '0')} $period';
      } else {
        return '${difference.inHours}h ago';
      }
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  bool _isNewNotification(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    // Consider notifications from last 24 hours as "new"
    return difference.inHours < 24;
  }

  Widget _buildNotificationIcon(NotificationItem notification) {
    if (notification.image != null && notification.image!.isNotEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(notification.image!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    final title = notification.title.toLowerCase();
    final content = notification.content.toLowerCase();

    if (title.contains('offer') ||
        title.contains('sale') ||
        content.contains('discount') ||
        content.contains('off') ||
        content.contains('%')) {
      iconData = Icons.shopping_bag;
      backgroundColor = const Color(0xFFE8F5E8);
      iconColor = const Color(0xFF4CAF50);
    } else if (title.contains('exclusive')) {
      iconData = Icons.card_giftcard;
      backgroundColor = const Color(0xFFFFF3E0);
      iconColor = const Color(0xFFFF9800);
    } else if (title.contains('flash') || title.contains('sale')) {
      iconData = Icons.flash_on;
      backgroundColor = const Color(0xFFE3F2FD);
      iconColor = const Color(0xFF2196F3);
    } else if (title.contains('promo')) {
      iconData = Icons.percent;
      backgroundColor = const Color(0xFFFFEBEE);
      iconColor = const Color(0xFFE91E63);
    } else {
      iconData = Icons.notifications;
      backgroundColor = const Color(0xFFF5F5F5);
      iconColor = const Color(0xFF757575);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildDebugInfo() {
    if (debugInfo == null) return const SizedBox.shrink();

    return Container(
        //   margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        //   padding: const EdgeInsets.all(12),
        //   decoration: BoxDecoration(
        //     color: Colors.orange.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(8),
        //     border: Border.all(color: Colors.orange.withOpacity(0.3)),
        //   ),
        //   // child: Column(
        //   //   crossAxisAlignment: CrossAxisAlignment.start,
        //   //   children: [
        //   //     const Text(
        //   //       'Debug Info:',
        //   //       style: TextStyle(
        //   //         fontWeight: FontWeight.bold,
        //   //         color: Colors.orange,
        //   //       ),
        //   //     ),
        //   //     const SizedBox(height: 4),
        //   //     Text(
        //   //       debugInfo!,
        //   //       style: const TextStyle(
        //   //         fontSize: 12,
        //   //         color: Colors.orange,
        //   //       ),
        //   //     ),
        //   //     const SizedBox(height: 8),
        //   //     Text(
        //   //       'Email: ${widget.email}',
        //   //       style: const TextStyle(
        //   //         fontSize: 12,
        //   //         color: Colors.orange,
        //   //       ),
        //   //     ),
        //   //   ],
        //   // ),
        );
  }

  int get newNotificationCount {
    return notifications.where((n) => _isNewNotification(n.time)).length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          final isTablet =
              constraints.maxWidth > 600 && constraints.maxWidth <= 800;

          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: isDesktop ? 16 : 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with "New X" count
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      if (newNotificationCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F4FD),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF2196F3).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'New $newNotificationCount',
                            style: const TextStyle(
                              color: Color(0xFF1976D2),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const Spacer(),
                      // Optional: Add settings or clear all button
                    ],
                  ),
                ),

                // Debug Info (only shown when there's debug info)
                _buildDebugInfo(),

                // Content
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2196F3)),
                          ),
                        )
                      : error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Colors.red.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Failed to load notifications',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: isDesktop ? 16 : 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      error!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: _loadNotifications,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2196F3),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : notifications.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.notifications_none,
                                        size: 48,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No notifications yet',
                                        style: TextStyle(
                                          color: const Color(0xFF757575),
                                          fontSize: isDesktop ? 16 : 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    final notification = notifications[index];
                                    final isNew =
                                        _isNewNotification(notification.time);

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isNew
                                            ? const Color(0xFFE8F4FD)
                                            : const Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(12),
                                        border: isNew
                                            ? Border.all(
                                                color: const Color(0xFF2196F3)
                                                    .withOpacity(0.2),
                                                width: 1,
                                              )
                                            : null,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          // Handle notification tap
                                          print(
                                              'Tapped notification: ${notification.title}');
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildNotificationIcon(
                                                notification),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    notification.title,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF1A1A1A),
                                                      height: 1.2,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    notification.content,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF6B7280),
                                                      height: 1.3,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  if (notification
                                                      .data.isNotEmpty) ...[
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                                0xFF2196F3)
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Text(
                                                        notification
                                                            .data.entries
                                                            .map((e) =>
                                                                '${e.key}: ${e.value}')
                                                            .join(' • '),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xFF2196F3),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  _formatTime(
                                                      notification.time),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFF9CA3AF),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String content;
  final String? image;
  final Map<String, dynamic> data;
  final DateTime time;

  NotificationItem({
    required this.title,
    required this.content,
    this.image,
    required this.data,
    required this.time,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationItem(
        title: json['title']?.toString() ?? '',
        content: json['content']?.toString() ?? '',
        image: json['image']?.toString(),
        data: Map<String, dynamic>.from(json['data'] ?? {}),
        time: DateTime.parse(json['time']),
      );
    } catch (e) {
      print('🔍 DEBUG: Error parsing NotificationItem: $e');
      print('🔍 DEBUG: JSON data: $json');
      rethrow;
    }
  }
}
