import 'package:farmtab_ai_frontend/profile/edit_profile.dart';
import 'package:flutter/material.dart';

import '../services/user_service.dart';
import '../theme/color_extension.dart';
import '../widget/round_button.dart';
import 'package:farmtab_ai_frontend/widget/setting_row.dart';
import 'package:farmtab_ai_frontend/widget/title_subtitle_cell.dart';
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
  bool isLoading = true;
  bool positive = false;

  List accountArr = [
    {"image": "assets/images/p_personal.png", "name": "Personal Data", "tag": "1"},
    {"image": "assets/images/p_achi.png", "name": "Achievement", "tag": "2"},
    {
      "image": "assets/images/p_activity.png",
      "name": "Activity History",
      "tag": "3"
    },
    {
      "image": "assets/images/p_workout.png",
      "name": "Workout Progress",
      "tag": "4"
    }
  ];
  List otherArr = [
    {"image": "assets/images/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/images/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    {"image": "assets/images/p_setting.png", "name": "Setting", "tag": "7"},
    {"image": "assets/images/p_setting.png", "name": "Log Out", "tag": "8"},
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: TColor.primaryColor1, fontSize: 20, fontWeight: FontWeight.w700,fontFamily: 'Poppins'),
        ),
      ),
      backgroundColor: TColor.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),))
          :SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty
                        ? NetworkImage(profileImageUrl!)
                        : AssetImage("assets/images/profile_photo.jpg") as ImageProvider,
                    onBackgroundImageError: profileImageUrl != null && profileImageUrl!.isNotEmpty
                        ? (exception, stackTrace) {
                      // Silently handle error and fall back to default image
                      setState(() {
                        profileImageUrl = null; // Reset to use default image
                      });
                    }
                        : null,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$username",
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          bio.length > 20 ? "${bio.substring(0, 20)}..." : bio,
                          style: TextStyle(
                            color: TColor.primaryColor2,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        ).then((_) {
                          fetchUserProfile(); // Refresh data
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "Universiti Sains Malaysia",
                      subtitle: "Your Organization",
                    ),
                  ),
                  // SizedBox(
                  //   width: 15,
                  // ),
                  // Expanded(
                  //   child: TitleSubtitleCell(
                  //     title: "65kg",
                  //     subtitle: "Weight",
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 15,
                  // ),
                  // Expanded(
                  //   child: TitleSubtitleCell(
                  //     title: "22yo",
                  //     subtitle: "Age",
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: accountArr.length,
                      itemBuilder: (context, index) {
                        var iObj = accountArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notification",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 30,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/p_notification.png",
                                height: 16, width: 16, fit: BoxFit.contain),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                "Pop-up Notification",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            CustomAnimatedToggleSwitch<bool>(
                              current: positive,
                              values: [false, true],
                              dif: 0.0,
                              indicatorSize: Size.square(30.0),
                              animationDuration:
                              const Duration(milliseconds: 200),
                              animationCurve: Curves.linear,
                              onChanged: (b) => setState(() => positive = b),
                              iconBuilder: (context, local, global) {
                                return const SizedBox();
                              },
                              defaultCursor: SystemMouseCursors.click,
                              onTap: () => setState(() => positive = !positive),
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
                                            gradient: LinearGradient(
                                                colors: TColor.secondaryG),
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(50.0)),
                                          ),
                                        )),
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
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black38,
                                            spreadRadius: 0.05,
                                            blurRadius: 1.1,
                                            offset: Offset(0.0, 0.8))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: otherArr.length,
                      itemBuilder: (context, index) {
                        var iObj = otherArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}