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

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  // Assuming you have an AuthService class with the changePassword method
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the user's email from your auth system - adjust as needed
      final email = await _authService.getCurrentUserEmail();

      final result = await _authService.changePassword(
        email,
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      if (result['success'] == true) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );

        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to change password. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Change Password',
            style: TextStyle(
                color: TColor.primaryColor1,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins'
            )
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.primaryColor1,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),

                // Current Password Field
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: TColor.primaryColor2,
                      selectionHandleColor:TColor.primaryColor1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _currentPasswordController,
                    cursorColor: TColor.primaryColor1,
                    obscureText: _obscureCurrentPassword,
                    decoration: CustomInputDecoration.build(
                      label: 'Current Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                          color: TColor.primaryColor1,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // New Password Field
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: TColor.primaryColor2,
                      selectionHandleColor:TColor.primaryColor1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _newPasswordController,
                    cursorColor: TColor.primaryColor1,
                    obscureText: _obscureNewPassword,
                    decoration: CustomInputDecoration.build(
                    label: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                        color: TColor.primaryColor1,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }

                      // Add your password strength validation here
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }

                      bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
                      bool hasDigits = value.contains(RegExp(r'[0-9]'));
                      bool hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                      if (!hasUppercase || !hasDigits || !hasSpecialCharacters) {
                        return 'Password must include uppercase, number, and special character';
                      }

                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: TColor.primaryColor2,
                      selectionHandleColor:TColor.primaryColor1,
                    ),
                  ),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    cursorColor: TColor.primaryColor1,
                    decoration: CustomInputDecoration.build(
                      label: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: TColor.primaryColor1,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }

                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Change Password Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primaryColor1,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Change Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL',
                    style: TextStyle(
                      fontSize: 14,
                      color: TColor.primaryColor1,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}