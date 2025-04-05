import 'package:farmtab_ai_frontend/services/shelf_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:farmtab_ai_frontend/widget/notification_row.dart';

import '../nav tab/shelf_tab_view.dart';

class NotificationView extends StatefulWidget {
  final int organizationID;
  final int userID;
  const NotificationView({super.key, required this.organizationID,required this.userID,});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late Future<List<Map<String, dynamic>>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    notificationsFuture = fetchUserNotifications(widget.userID, widget.organizationID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/images/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Notification",
          style: TextStyle(
              color: TColor.primaryColor1, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
        ),
      ),
      backgroundColor: TColor.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to load notifications'));
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final alert = notifications[index];
              print("Alerts: $alert");

              return GestureDetector(
                onTap: () async {
                  await markAlertAsRead(alert["id"], widget.userID);
                  setState(() {
                    alert["is_read"] = true;
                  });

                  try {
                    final shelfId = alert["shelf_id"];
                    final shelfService = ShelfService();
                    final shelf = await shelfService.getShelfById(shelfId);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShelfTabView(shelf: shelf),
                      ),
                    );
                  } catch (e) {
                    print("❌ Failed to load shelf: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to load shelf details")),
                    );
                  }
                },

                child: NotificationRow(nObj: {
                  "image": "assets/images/plant-one.png",
                  "title": alert["message"] ?? "Alert",
                  "time": _formatTime(alert["created_at"]),
                  "isRead": alert["is_read"] ?? false,
                }),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: TColor.gray.withOpacity(0.5),
              height: 1,
            ),
          );
        },
      ),
    );
  }//
}

Future<List<Map<String, dynamic>>> fetchUserNotifications(int userId, int orgId) async {
  const String baseUrl = 'http://app.farmtab.my:4000';
  final response = await http.get(
    Uri.parse('$baseUrl/api/alerts/user/$userId/org/$orgId'),
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    print('❌ Backend error: ${response.body}');
    throw Exception('Failed to load user alerts');
  }
}

String _formatTime(String timestamp) {
  final createdAt = DateTime.tryParse(timestamp);
  if (createdAt == null) return "Unknown";

  final now = DateTime.now();
  final diff = now.difference(createdAt);

  if (diff.inMinutes < 1) return "Just now";
  if (diff.inMinutes < 60) return "About ${diff.inMinutes} minutes ago";
  if (diff.inHours < 24) return "About ${diff.inHours} hours ago";
  return "${createdAt.day}/${createdAt.month}/${createdAt.year}";
}

Future<void> markAlertAsRead(int alertId, int userId) async {
  const baseUrl = 'http://app.farmtab.my:4000';
  await http.post(
    Uri.parse('$baseUrl/api/alerts/$alertId/read'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'userId': userId}),
  );
}
