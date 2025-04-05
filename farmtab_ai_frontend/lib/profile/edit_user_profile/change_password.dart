import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/color_extension.dart';
import '../../widget/custome_input_decoration.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = await _authService.getCurrentUserEmail();
      final result = await _authService.changePassword(
        email,
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      if (result['success'] == true) {
        _showSnackBar(
          "Password changed successfully",
          icon: Icons.check_circle,
          backgroundColor: Colors.green.shade700,
        );
        FocusScope.of(context).unfocus();
        Future.delayed(Duration(milliseconds: 800), () {
          Navigator.pop(context);
        });
      } else {
        _showSnackBar(
          result['message'] ?? "Failed to change password",
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
        scrolledUnderElevation: 0,
        title: Text(
          'Change Password',
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
                        Icons.lock_outline_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Update Your Password",
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
                      "Keep your account secure with a new password",
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPasswordField(
                          label: "Current Password",
                          controller: _currentPasswordController,
                          obscureText: _obscureCurrentPassword,
                          onVisibilityToggle: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter your current password' : null,
                        ),
                        SizedBox(height: 20),
                        _buildPasswordField(
                          label: "New Password",
                          controller: _newPasswordController,
                          obscureText: _obscureNewPassword,
                          onVisibilityToggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter a new password';
                            if (value.length < 8) return 'Password must be at least 8 characters long';
                            bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
                            bool hasDigits = value.contains(RegExp(r'[0-9]'));
                            bool hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                            if (!hasUppercase || !hasDigits || !hasSpecial) {
                              return 'Password must include uppercase, number, and special character';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        _buildPasswordField(
                          label: "Confirm New Password",
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          onVisibilityToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please confirm your new password';
                            if (value != _newPasswordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        Container(
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
                            onPressed: _isLoading ? null : _changePassword,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            label,
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
            child: TextFormField(
              controller: controller,
              cursorColor: TColor.primaryColor1,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: "Enter ${label.toLowerCase()}",
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: TColor.primaryColor2,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: TColor.primaryColor2,
                  ),
                  onPressed: onVisibilityToggle,
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
              validator: validator,
            ),
          ),
        ),
      ],
    );
  }
}