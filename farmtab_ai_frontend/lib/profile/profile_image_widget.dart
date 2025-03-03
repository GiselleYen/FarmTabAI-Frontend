import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/user_service.dart';
import '../theme/color_extension.dart';

class ProfileImageWidget extends StatefulWidget {
  final Map<String, dynamic>? userProfile;
  final Function(Map<String, dynamic>) onProfileUpdated;

  const ProfileImageWidget({
    Key? key,
    required this.userProfile,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  final UserService _userService = UserService();
  File? _imageFile;
  bool _isUploading = false;
  String? _errorMessage;

  Future<void> _pickImage() async {
    setState(() {
      _errorMessage = null;
    });

    final ImagePicker picker = ImagePicker();

    try {
      // Specify imageQuality to ensure we get a proper image
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,  // Limit size to avoid excessively large files
        maxHeight: 800,
      );

      if (pickedFile != null) {
        // Check file extension
        final String extension = pickedFile.path.split('.').last.toLowerCase();
        if (!['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
          setState(() {
            _errorMessage = 'Please select a JPG, PNG, or GIF image';
          });
          return;
        }

        setState(() {
          _imageFile = File(pickedFile.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected. Tap "Upload Image" to save it.')),
        );
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
      _errorMessage = null;
    });

    try {
      final result = await _userService.uploadProfileImage(_imageFile!);

      // Notify parent widget of the update
      widget.onProfileUpdated(result['user']);

      setState(() {
        _imageFile = null;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image uploaded successfully')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine which image to show
    Widget profileImage;

    if (_isUploading) {
      // Show loading indicator while uploading
      profileImage = Container(
        width: 100,
        height: 100,
        color: Colors.grey[200],
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),),
        ),
      );
    } else if (_imageFile != null) {
      // Show locally selected image
      profileImage = Image.file(
        _imageFile!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else if (widget.userProfile != null &&
        widget.userProfile!['profile_image_url'] != null) {
      // Show remote image from server
      profileImage = Image.network(
        widget.userProfile!['profile_image_url'],
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
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

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: profileImage,
        ),
        const SizedBox(height: 10),

        // Display error message if any
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),

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
              onPressed: _isUploading || _imageFile == null ? null : _uploadImage,
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
                _isUploading ? "Uploading..." : "Upload Image",
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
                disabledBackgroundColor: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}