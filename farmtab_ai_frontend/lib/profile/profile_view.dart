import 'package:farmtab_ai_frontend/login_register/personal_data_screen.dart';
import 'package:farmtab_ai_frontend/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../login_register/welcome_screen.dart';
import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import '../theme/color_extension.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final UserService _userService = UserService();
  String? profileImageUrl;
  String username = "User";
  String bio = "";
  String organizationName = "";
  bool isLoading = true;
  bool positive = true;

  List otherArr = [
    {"icon": Icons.contact_support_outlined, "name": "Contact Us", "tag": "5"},
    {"icon": Icons.privacy_tip_outlined, "name": "Privacy Policy", "tag": "6"},
    {"icon": Icons.logout_outlined, "name": "Log Out", "tag": "8"},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userData = await _userService.getUserProfile();

      setState(() {
        username = userData['username'] ?? "User";
        profileImageUrl = userData['profile_image_url'];
        bio = userData['bio'] ?? "Passionate about learning and growing every day.";
        organizationName = userData['organization_name'] ?? "No Organization";
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Widget profileImage;
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      profileImage = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(75),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(70),
          child: Image.network(
            profileImageUrl!,
            width: 140,
            height: 140,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(70),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(70),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/profile_photo.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      profileImage = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(75),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: TColor.lightGray,
            borderRadius: BorderRadius.circular(70),
            image: const DecorationImage(
              image: AssetImage("assets/images/profile_photo.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: TColor.backgroundColor1,
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
        ),
      )
          : Container(
        decoration: BoxDecoration(
          color: TColor.backgroundColor1,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header section with animation
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColor.primaryColor1.withOpacity(0.8),
                      TColor.primaryColor2.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TColor.primaryColor1.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
                  child: Column(
                    children: [
                      profileImage,
                      SizedBox(height: 16),
                      Text(username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ))
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.2, end: 0),
                      SizedBox(height: 4),
                      Text(
                        bio,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 100.ms)
                          .slideY(begin: 0.2, end: 0),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(),
                            ),
                          ).then((_) {
                            fetchUserProfile();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: TColor.primaryColor1,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        icon: Icon(Icons.edit, color: TColor.primaryColor1),
                        label: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: 200.ms)
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),
              SizedBox(height: 20),
              // Organization Info with animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: TColor.primaryColor1,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Organization",
                            style: TextStyle(
                              color: TColor.primaryColor1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: TColor.primaryG,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: TColor.primaryColor1.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.apartment_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          organizationName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Your Organization",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Inter',
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: TColor.lightGray,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: TColor.primaryColor1,
                            size: 14,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return OrganizationChangeDialog(
                                organizationName: organizationName,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 400.ms)
                  .slideX(begin: -0.2, end: 0),
              SizedBox(height: 20),
              // Notification Section with animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: TColor.primaryColor1,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Notification",
                            style: TextStyle(
                              color: TColor.primaryColor1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: TColor.secondaryG,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color:
                                TColor.secondaryColor1.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          "Pop-up Notification",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            color: Colors.black87,
                          ),
                        ),
                        trailing: CustomAnimatedToggleSwitch<bool>(
                          current: positive,
                          values: [false, true],
                          dif: 0.0,
                          indicatorSize: Size.square(30.0),
                          animationDuration: const Duration(milliseconds: 200),
                          animationCurve: Curves.linear,
                          onChanged: (b) => setState(() => positive = b),
                          iconBuilder: (context, local, global) {
                            return const SizedBox();
                          },
                          defaultCursor: SystemMouseCursors.click,
                          onTap: () {
                            setState(() => positive = !positive);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  positive
                                      ? "Notifications Enabled"
                                      : "Notifications Disabled",
                                  style: const TextStyle(fontFamily: 'Inter'),
                                ),
                                backgroundColor:
                                positive ? Colors.green : Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          iconsTappable: false,
                          wrapperBuilder: (context, global, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 10.0,
                                  right: 10.0,
                                  height: 30.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: positive
                                          ? LinearGradient(
                                          colors: TColor.secondaryG)
                                          : const LinearGradient(colors: [
                                        Colors.grey,
                                        Colors.grey
                                      ]),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0)),
                                    ),
                                  ),
                                ),
                                child,
                              ],
                            );
                          },
                          foregroundIndicatorBuilder: (context, global) {
                            return SizedBox.fromSize(
                              size: const Size(10, 10),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: TColor.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0)),
                                  boxShadow: const[
                                    BoxShadow(
                                      color: Colors.black38,
                                      spreadRadius: 0.05,
                                      blurRadius: 1.1,
                                      offset: Offset(0.0, 0.8),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 500.ms)
                  .slideX(begin: -0.2, end: 0),
              SizedBox(height: 20),
              // Other Settings Section with animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: TColor.primaryColor1,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Settings",
                            style: TextStyle(
                              color: TColor.primaryColor1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: otherArr.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: TColor.lightGray,
                          indent: 16,
                          endIndent: 16,
                        ),
                        itemBuilder: (context, index) {
                          var iObj = otherArr[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: index % 2 == 0
                                      ? TColor.primaryG
                                      : TColor.secondaryG,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: (index % 2 == 0
                                        ? TColor.primaryColor1
                                        : TColor.secondaryColor1)
                                        .withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                iObj["icon"] as IconData,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            title: Text(
                              iObj["name"].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                color: Colors.black87,
                              ),
                            ),
                            trailing: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: TColor.lightGray,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: TColor.primaryColor1,
                                size: 14,
                              ),
                            ),
                            onTap: () async {
                              switch (iObj["tag"]) {
                                case "5": // Contact Us
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        title: Row(
                                          children: [
                                            Icon(Icons.contact_support_outlined, color: TColor.primaryColor1, size: 24),
                                            SizedBox(width: 10),
                                            Text(
                                              "Contact Us",
                                              style: TextStyle(
                                                color: TColor.primaryColor1,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Need help? \nContact our administrator:",
                                              style: TextStyle(fontSize: 14, color: Colors.black87, fontFamily: 'Inter'),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              "kelven.farmtabai@gmail.com",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                color: TColor.primaryColor1.withOpacity(0.7),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            child: ElevatedButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: TColor.primaryColor1,
                                                padding: EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                elevation: 2,
                                              ),
                                              child: Text(
                                                "Close",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  break;

                                case "6": // Privacy Policy
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PersonalDataScreen()),
                                  );
                                  break;

                                case "8": // Log Out
                                  final shouldLogout = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        "Log Out",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                                      ),
                                      content: Text(
                                        "Are you sure you want to log out?",
                                        style: TextStyle(fontFamily: 'Inter'),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.grey, fontFamily: 'Inter'),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text(
                                            "Log Out",
                                            style: TextStyle(
                                              color: TColor.primaryColor1,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (shouldLogout == true) {
                                    try {
                                      await authProvider.logout(); // Assuming authProvider is accessible
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Logged out successfully",
                                            style: const TextStyle(fontFamily: 'Inter'),
                                          ),
                                          backgroundColor: Colors.green, // Changed to green for success
                                        ),
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => WelcomeScreen()),
                                            (route) => false,
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Logout failed: $e",
                                            style: const TextStyle(fontFamily: 'Inter'),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                  break;
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 500.ms)
                  .slideX(begin: -0.2, end: 0),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// OrganizationChangeDialog remains unchanged
class OrganizationChangeDialog extends StatelessWidget {
  final String organizationName;

  const OrganizationChangeDialog({
    Key? key,
    required this.organizationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: TColor.primaryColor1,
            size: 24,
          ),
          SizedBox(width: 10),
          Text(
            "Organization Info",
            style: TextStyle(
              color: TColor.primaryColor1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: TColor.primaryG,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: TColor.primaryColor1.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.apartment_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "You're currently assigned to:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: 'Inter',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            organizationName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: TColor.primaryColor2,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 20),
          Text(
            "If you need to switch organizations, please reach out to your administrator.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 12),
          Text(
            "kelven.farmtabai@gmail.com",
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: TColor.primaryColor1.withOpacity(0.7),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
      actions: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primaryColor1,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: Text(
              "Got it",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ],
    );
  }
}