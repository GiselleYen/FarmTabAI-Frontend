import 'package:farmtab_ai_frontend/profile/edit_profile.dart';
import 'package:farmtab_ai_frontend/widget/custome_input_decoration.dart';
import 'package:flutter/material.dart';

import '../../services/user_service.dart';
import '../../theme/color_extension.dart';

class EditNamePage extends StatefulWidget {
  final String currentName;

  const EditNamePage({Key? key, required this.currentName}) : super(key: key);

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;

  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() async {
    String newName = _nameController.text.trim();

    if (newName.isEmpty) {
      _showSnackBar(
        "Name cannot be empty",
        icon: Icons.error_outline,
        backgroundColor: Colors.red.shade700,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _userService.updateUserName(newName);

      if (response['success']) {
        _showSnackBar(
          "Name updated successfully",
          icon: Icons.check_circle,
          backgroundColor: Colors.green.shade700,
        );

        FocusScope.of(context).unfocus();
        Future.delayed(Duration(milliseconds: 800), () {
          Navigator.pop(context);
        });
      } else {
        _showSnackBar(
          "Failed to update name",
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
          'Edit Name',
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
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with illustration
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
                        Icons.person_outline_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "What should we call you?",
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
                      "Your name will be visible to other users",
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
                          "Name",
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
                            controller: _nameController,
                            cursorColor: TColor.primaryColor1,
                            decoration: InputDecoration(
                              hintText: "Enter your name",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: TColor.primaryColor2,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                            autofocus: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),

                      // Save button
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
                              spreadRadius: 0,
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
                          onPressed: _isLoading ? null : _saveName,
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
                              Icon(Icons.check_circle_outline, color: Colors.white),
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