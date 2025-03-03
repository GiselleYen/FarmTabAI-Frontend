
import 'dart:io';

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
  File? _imageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userProfile = await _userService.getUserProfile();
      setState(() {
        _userProfile = userProfile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error (show a snackbar, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final result = await _userService.uploadProfileImage(_imageFile!);

      // Update user profile with new data including the image URL
      setState(() {
        _userProfile = result['user'];
        _imageFile = null;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image uploaded successfully')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    Widget profileImage;
    if (_imageFile != null) {
      // Show locally selected image
      profileImage = Image.file(
        _imageFile!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else if (_userProfile != null && _userProfile!['profile_image_url'] != null) {
      // Show remote image from server
      profileImage = Image.network(
        _userProfile!['profile_image_url'],
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/profile_photo.jpg",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      // Show default image
      profileImage = Image.asset(
        "assets/images/profile_photo.jpg",
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }

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
                  child: profileImage,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isUploading ? null : _pickImage,
                      icon: Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: Text(
                        "Select Image",
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
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _isUploading ? null : _uploadImage,
                      icon: _isUploading
                          ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Icon(
                        Icons.upload,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: Text(
                        _isUploading ? "Uploading..." : "Save Image",
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
                  ],
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
