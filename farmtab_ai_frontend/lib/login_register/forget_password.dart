import 'package:farmtab_ai_frontend/login_register/signin_screen.dart';
import 'package:farmtab_ai_frontend/login_register/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../nav tab/home_tab_view.dart';
import '../providers/auth_provider.dart';
import '../widget/custom_welcome_scaffold.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final _formSignInKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _codeVerificationSent = false;
  TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    void _sendCode() async {
      if (_emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter your email'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final success = await Provider.of<AuthProvider>(context, listen: false)
          .forgotPassword(_emailController.text.trim());

      if (success) {
        setState(() {
          _codeVerificationSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent to your email'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    void _resetPassword() async {
      if (_formSignInKey.currentState!.validate()) {
        final success = await Provider.of<AuthProvider>(context, listen: false)
            .confirmForgotPassword(
            _emailController.text.trim(),
            _codeController.text.trim(),
            _newPasswordController.text.trim()
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to sign in page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        } else if (authProvider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return CustomWelcomeScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 2,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: TColor.primaryColor1,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: TColor.primaryColor1.withOpacity(0.7),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'Enter Your Account Email',
                            style: TextStyle(
                              color: TColor.primaryColor1.withOpacity(0.5),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: TColor.primaryColor1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: TColor.primaryColor1.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder( // Border when clicking
                            borderSide: BorderSide(
                              color: TColor.primaryColor1,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: [
                          // Verification Code Input
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              controller: _codeController,
                              cursorColor: TColor.primaryColor1.withOpacity(0.7),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the code';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: Text(
                                  'Enter Code',
                                  style: TextStyle(
                                    color: TColor.primaryColor1.withOpacity(0.5),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: TColor.primaryColor1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: TColor.primaryColor1.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: TColor.primaryColor1,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          // Send Code Button
                          Expanded(
                            flex: 3,
                            child: ElevatedButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _sendCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TColor.primaryColor1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              child: authProvider.isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              )
                                  : Text(
                                'Send Code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),

                      // New Password Field - Only show after verification code is sent
                      if (_codeVerificationSent)
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          cursorColor: TColor.primaryColor1.withOpacity(0.7),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text(
                              'New Password',
                              style: TextStyle(
                                color: TColor.primaryColor1.withOpacity(0.5),
                                fontFamily: 'Poppins',
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: TColor.primaryColor1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: TColor.primaryColor1.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: TColor.primaryColor1,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                      const SizedBox(height: 16.0),

                      // Reset Password Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_codeVerificationSent && !authProvider.isLoading)
                              ? _resetPassword
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primaryColor1,
                            minimumSize: const Size(double.infinity, 50),
                            // Disable button color
                            disabledBackgroundColor: TColor.primaryColor1.withOpacity(0.3),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      // don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Still remember the password?  ',
                            style: TextStyle(
                              color: TColor.primaryColor1.withOpacity(0.6),
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 300),
                                  pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(-1.0, 0.0); // Start from right
                                    const end = Offset.zero; // Move to normal position
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: TColor.primaryColor1,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
