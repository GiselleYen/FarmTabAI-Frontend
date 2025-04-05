import 'dart:io';
import 'package:farmtab_ai_frontend/profile/edit_user_profile/edit_bio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Added animation import
import '../services/user_service.dart';
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
      _showErrorSnackBar('Failed to load profile: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Please select an image first', style: TextStyle(fontFamily: 'Inter')),
            ],
          ),
          backgroundColor: Colors.amber.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(16),
          elevation: 4,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final result = await _userService.uploadProfileImage(_imageFile!);
      setState(() {
        _userProfile = result['user'];
        _imageFile = null;
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Profile image uploaded successfully', style: TextStyle(fontFamily: 'Inter')),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(16),
          elevation: 4,
        ),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showErrorSnackBar('Failed to upload image: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontFamily: 'Inter'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
        elevation: 4,
      ),
    );
  }

  void _showEmailChangeNotSupportedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: TColor.primaryColor1, size: 24),
              SizedBox(width: 10),
              Text(
                "Email Change",
                style: TextStyle(
                  color: TColor.primaryColor1,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          content: Text(
            "Currently, changing your email address is not supported.",
            style: TextStyle(color: Colors.black87, fontSize: 14, fontFamily: 'Inter'),
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
      },
    );
  }

  List<Map<String, dynamic>> get accountArr => [
    {
      "icon": Icons.person_outline_rounded,
      "name": username,
      "tag": "1",
      "description": "Change your display name"
    },
    {
      "icon": Icons.email_outlined,
      "name": email,
      "tag": "2",
      "description": "Email address (cannot be changed)"
    },
    {
      "icon": Icons.lock_outline_rounded,
      "name": "Change Password",
      "tag": "3",
      "description": "Update your security credentials"
    },
    {
      "icon": Icons.info_outline_rounded,
      "name": "Bio",
      "tag": "4",
      "description": "Tell others about yourself"
    },
  ];

  @override
  Widget build(BuildContext context) {
    Widget profileImage;
    if (_imageFile != null) {
      profileImage = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(75),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(70),
          child: Image.file(_imageFile!, width: 140, height: 140, fit: BoxFit.cover),
        ),
      );
    } else if (_userProfile != null && _userProfile!['profile_image_url'] != null) {
      profileImage = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(75),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(70),
          child: Image.network(
            _userProfile!['profile_image_url'],
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
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
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
      appBar: AppBar(
        title: Text(
          "Edit Your Profile",
          style: TextStyle(
            color: TColor.primaryColor1,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: TColor.primaryColor1, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1)))
          : Container(
        decoration: BoxDecoration(
          color: TColor.backgroundColor1,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          profileImage
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0)),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.camera_alt, color: TColor.primaryColor1, size: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        username,
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
                        ),
                      ).animate().slideY(begin: 0.3, end: 0, duration: 500.ms).fadeIn(),
                      SizedBox(height: 4),
                      Text(
                        email,
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
                      ).animate().slideY(begin: 0.3, end: 0, duration: 500.ms, delay: 100.ms).fadeIn(),
                      SizedBox(height: 6),
                      if (_imageFile != null)
                        ElevatedButton.icon(
                          onPressed: _isUploading ? null : _uploadImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: TColor.primaryColor1,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 3,
                          ),
                          icon: _isUploading
                              ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: TColor.primaryColor1,
                              strokeWidth: 2,
                            ),
                          )
                              : Icon(Icons.cloud_upload, color: TColor.primaryColor1),
                          label: Text(
                            _isUploading ? "Uploading..." : "Save New Photo",
                            style: TextStyle(
                              color: TColor.primaryColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                    ],
                  ),
                ),
              ).animate().slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOut),

              SizedBox(height: 6),

              // Account information section with animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                            "Account Information",
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
                        itemCount: accountArr.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: TColor.lightGray,
                          indent: 16,
                          endIndent: 16,
                        ),
                        itemBuilder: (context, index) {
                          var iObj = accountArr[index];
                          return Card(
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            color: Colors.white.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: index % 2 == 0 ? TColor.primaryG : TColor.secondaryG,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (index % 2 == 0 ? TColor.primaryColor1 : TColor.secondaryColor1)
                                          .withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(iObj["icon"] as IconData, color: Colors.white, size: 22),
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
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  iObj["description"].toString(),
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
                                child: Icon(Icons.arrow_forward_ios, color: TColor.primaryColor1, size: 14),
                              ),
                              onTap: () async {
                                if (iObj["tag"] == "1") {
                                  await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => EditNamePage(currentName: username),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0); // Start from right
                                        const end = Offset.zero; // End at center
                                        const curve = Curves.easeInOut;

                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                        var offsetAnimation = animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: Duration(milliseconds: 300), // Adjust duration as needed
                                    ),
                                  );
                                  _loadUserProfile(); // Refresh data
                                } else if (iObj["tag"] == "2") {
                                  _showEmailChangeNotSupportedDialog(context);
                                } else if (iObj["tag"] == "3") {
                                  await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => const ChangePasswordPage(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0); // Start from right
                                        const end = Offset.zero; // End at center
                                        const curve = Curves.easeInOut;

                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                        var offsetAnimation = animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: Duration(milliseconds: 300),
                                    ),
                                  );
                                  _loadUserProfile(); // Refresh data
                                } else if (iObj["tag"] == "4") {
                                  await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => EditBioPage(currentBio: bio),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0); // Start from right
                                        const end = Offset.zero; // End at center
                                        const curve = Curves.easeInOut;

                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                        var offsetAnimation = animation.drive(tween);

                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: Duration(milliseconds: 300),
                                    ),
                                  );
                                  _loadUserProfile(); // Refresh data
                                }
                              },
                            ),
                          ).animate().fadeIn(duration: 500.ms, delay: (200 * index).ms);
                        },
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 300.ms, curve: Curves.easeOut),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}