import 'package:flutter/material.dart';

import '../../services/user_service.dart';
import '../../theme/color_extension.dart';

class EditBioPage extends StatefulWidget {
  final String currentBio;

  const EditBioPage({Key? key, required this.currentBio}) : super(key: key);

  @override
  State<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;

  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.currentBio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _saveBio() async {
    String newBio = _bioController.text.trim();

    if (newBio.isEmpty) {
      _showSnackBar(
        "Bio cannot be empty",
        icon: Icons.error_outline,
        backgroundColor: Colors.red.shade700,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _userService.updateUserBio(newBio);

      if (response['success']) {
        _showSnackBar(
          "Bio updated successfully",
          icon: Icons.check_circle,
          backgroundColor: Colors.green.shade700,
        );

        FocusScope.of(context).unfocus();
        Future.delayed(Duration(milliseconds: 800), () {
          Navigator.pop(context);
        });
      } else {
        _showSnackBar(
          "Failed to update bio",
          icon: Icons.error_outline,
          backgroundColor: Colors.red.shade700,
        );
      }
    } catch (e) {
      _showSnackBar(
        "Error: ${e.toString()}",
        icon: Icons.error_outline,
        backgroundColor: Colors.red.shade700,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
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
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
        elevation: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.backgroundColor1,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit Bio',
          style: TextStyle(
            color: TColor.primaryColor1,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: TColor.primaryColor1,
            size: 22,
          ),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Future.delayed(Duration(milliseconds: 250), () {
              Navigator.pop(context);
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
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
                        Icons.edit_note_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Tell us about yourself",
                      style: TextStyle(
                        color: TColor.primaryColor1,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your bio will be visible to other users",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: TColor.backgroundColor1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 8),
                        child: Text(
                          "Bio",
                          style: TextStyle(
                            color: TColor.primaryColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                              selectionColor: TColor.primaryColor2.withOpacity(0.3),
                              selectionHandleColor: TColor.primaryColor1,
                            ),
                          ),
                          child: TextField(
                            controller: _bioController,
                            cursorColor: TColor.primaryColor1,
                            decoration: InputDecoration(
                              hintText: "Enter your bio",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                              prefixIcon: Icon(
                                Icons.supervised_user_circle_rounded,
                                color: TColor.primaryColor2,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                            autofocus: true,
                            minLines: 3,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: TColor.primaryColor1.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: TColor.primaryG,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _isLoading ? null : _saveBio,
                          child: _isLoading
                              ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}