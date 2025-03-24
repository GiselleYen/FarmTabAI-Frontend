
import 'dart:io';

import 'package:farmtab_ai_frontend/profile/edit_user_profile/edit_bio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

import '../services/user_service.dart';
import '../widget/profile_row.dart';
import 'edit_user_profile/change_password.dart';
import 'edit_user_profile/edit_name.dart';

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

  String username = "User";
  String email = "@gmail.com";
  String bio = "";

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
        username = _userProfile?['username'] ?? "User";
        email = _userProfile?['email'] ?? "@gmail.com";
        bio = _userProfile?['bio'] ?? "";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

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

  void _showEmailChangeNotSupportedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Email Change Not Supported",
            style: TextStyle(
                color: TColor.primaryColor1,
                fontSize: 17,//
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter'
            ),
          ),
          content: Text("Currently, changing your email address is not supported.",
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Inter'
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("OK",
                style: TextStyle(
                    color: TColor.primaryColor1,
                    fontSize: 14,//
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter'
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  List<Map<String, dynamic>> get accountArr => [
    {"icon": Icons.person_2_outlined, "name": username, "tag": "1"},
    {"icon": Icons.email_outlined, "name": email, "tag": "2"},
    {"icon": Icons.lock, "name": "Change Password", "tag": "3"},
    {"icon": Icons.info, "name": "Bio", "tag": "4"},
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
      profileImage = Container();
    }

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: TColor.primaryColor1,
            fontSize: 24,
            fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Back icon
            color: TColor.primaryColor1, // Change the back icon color
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),))
          :Container(
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
                          fontFamily: 'Inter'
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
                            fontFamily: 'Inter'
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
                      icon: iObj["icon"] as IconData, // Ensure it's used as IconData
                      title: iObj["name"].toString(),
                      onPressed: () async {
                        // Check which row was clicked based on the tag
                        if (iObj["tag"] == "1") {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNamePage(currentName: username),
                            ),
                          ).then((_) {
                            _loadUserProfile(); // Refresh data
                          });

                          // Handle the result when user returns from edit page
                          if (result != null) {
                            setState(() {
                              username = result;
                            });
                          }

                        } else if (iObj["tag"] == "2") {
                          _showEmailChangeNotSupportedDialog(context);

                        } else if (iObj["tag"] == "3") {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage(),
                            ),
                          ).then((_) {
                            _loadUserProfile(); // Refresh data
                          });

                        } else if (iObj["tag"] == "4") {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBioPage(currentBio: bio),
                            ),
                          ).then((_) {
                            _loadUserProfile(); // Refresh data
                          });

                          // Handle the result when user returns from edit page
                          if (result != null) {
                            setState(() {
                              username = result;
                            });
                          }
                        }
                      },
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
