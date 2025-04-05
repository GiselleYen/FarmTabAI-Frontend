import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:farmtab_ai_frontend/profile/edit_profile.dart';
import 'package:farmtab_ai_frontend/login_register/welcome_screen.dart';
import 'package:farmtab_ai_frontend/providers/auth_provider.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import '../../services/user_service.dart';
import '../notification_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeHeader extends StatefulWidget {
  final String username;
  final String? profileImageUrl;
  final int organizationID;
  final int userID;

  const HomeHeader({
    super.key,
    required this.username,
    required this.profileImageUrl,
    required this.organizationID,
    required this.userID,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
    Timer.periodic(const Duration(minutes: 1), (_) => _loadUnreadCount());
  }

  Future<void> _loadUnreadCount() async {
    final userService = UserService();
    int count = await userService.getUnreadNotificationCount(widget.userID, widget.organizationID);
    if (mounted) {
      setState(() => unreadCount = count);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side - User greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Hi ${widget.username},",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth < 360 ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 2, offset: const Offset(0, 1))],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: screenWidth < 360 ? 14 : 16,
                    fontFamily: 'Inter',
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 100.ms),
              ],
            ),
          ),

          // Right side - Notification and Profile
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Notification button
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationView(
                              organizationID: widget.organizationID,
                              userID: widget.userID,
                            ),
                          ),
                        );
                        _loadUnreadCount();
                      },
                      icon: const Icon(
                        Icons.notifications_none_sharp,
                        size: 28,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Center(
                          child: Text(
                            unreadCount < 10 ? unreadCount.toString() : '9+',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

              const SizedBox(width: 8),

              // Profile avatar with menu
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, 60), // bigger offset for larger avatar
                  onSelected: (value) async {
                    if (value == 'profile') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                    } else if (value == 'logout') {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          title: const Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                          content: const Text("Are you sure you want to log out?", style: TextStyle(fontFamily: 'Inter')),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("Cancel", style: TextStyle(color: TColor.primaryColor1, fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text("Log Out", style: TextStyle(color: TColor.primaryColor1, fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      );
                      if (shouldLogout == true) {
                        await authProvider.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                              (route) => false,
                        );
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  elevation: 10,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.account_circle, color: TColor.primaryColor1, size: 26),
                          const SizedBox(width: 12),
                          Text("Profile Info", style: TextStyle(color: TColor.primaryColor1, fontSize: 16, fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app, color: TColor.primaryColor1, size: 26),
                          const SizedBox(width: 12),
                          Text("Log Out", style: TextStyle(color: TColor.primaryColor1, fontSize: 16, fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ],
                  child: CircleAvatar(
                    radius: 28, // increased size
                    backgroundImage: widget.profileImageUrl != null && widget.profileImageUrl!.isNotEmpty
                        ? NetworkImage(widget.profileImageUrl!)
                        : const AssetImage("assets/images/profile_photo.jpg") as ImageProvider,
                    onBackgroundImageError: widget.profileImageUrl != null && widget.profileImageUrl!.isNotEmpty
                        ? (exception, stackTrace) {}
                        : null,
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
            ],
          ),
        ],
      ),
    );
  }
}