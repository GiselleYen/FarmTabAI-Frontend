
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

import '../services/user_service.dart';
import '../widget/profile_row.dart';

class EditProfilePage extends StatefulWidget {

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  final UserService _userService = UserService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  List accountArr = [
    {"image": "assets/images/p_personal.png", "name": "Name", "tag": "1"},
    {"image": "assets/images/p_achi.png", "name": "Email", "tag": "2"},
    {
      "image": "assets/images/p_activity.png",
      "name": "Change Password",
      "tag": "3"
    },
    {
      "image": "assets/images/p_workout.png",
      "name": "Bio",
      "tag": "4"
    }
  ];

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userProfile = await _userService.getUserProfile();
      setState(() {
        _userProfile = userProfile;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateProfileImage(String newImageUrl) {
    setState(() {
      if (_userProfile != null) {
        _userProfile!['profile_image_url'] = newImageUrl;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: TColor.primaryColor1,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Back icon
            color: TColor.primaryColor1, // Change the back icon color
          ),
          onPressed: () {
            Navigator.pop(context); // Go back to previous screen
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Center(
          child: Column(
              children: [
                ClipRRect(
                borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "assets/images/profile_photo.jpg",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
              ),
                const SizedBox(height: 10,),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add your upload image functionality here
                  },
                  icon: Icon(
                    Icons.upload,
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text(
                    "Upload Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primaryColor1,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),

                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: accountArr.length,
                  itemBuilder: (context, index) {
                    var iObj = accountArr[index] as Map? ?? {};
                    return ProfileRow(
                      icon: iObj["image"].toString(),
                      title: iObj["name"].toString(),
                      onPressed: () {},
                    );
                  },
                )


            ],
          ),
        ),
      )
    );
  }
}
