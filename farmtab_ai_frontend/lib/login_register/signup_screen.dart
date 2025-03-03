import 'package:farmtab_ai_frontend/login_register/otp.dart';
import 'package:farmtab_ai_frontend/login_register/personal_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signin_screen.dart';
import 'package:farmtab_ai_frontend/widget/custom_welcome_scaffold.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import '../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    void _signup() async {
      if (_formSignupKey.currentState!.validate()) {
        if (!agreePersonalData) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please agree to the processing of personal data'),
            ),
          );
          return;
        }

        // Call the signup method on your AuthProvider
        final success = await Provider.of<AuthProvider>(context, listen: false)
            .register(
            _emailController.text.trim(),
            _passwordController.text,
            _nameController.text.trim(),
        );

        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OTP_Page(email: _emailController.text.trim())),
          );
        } else if (authProvider.error != null) {
          // Show error message from provider
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
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // get started text
                      Text(
                        "Let's Started!",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: TColor.primaryColor1,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      // full name
                      TextFormField(
                        controller: _nameController,
                        cursorColor: TColor.primaryColor1.withOpacity(0.7),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                              'Full Name',
                              style: TextStyle(
                                color: TColor.primaryColor1.withOpacity(0.7),
                                fontFamily: 'Poppins',
                              ),
                          ),
                          hintText: 'Enter Full Name',
                          hintStyle: TextStyle(
                            color: TColor.primaryColor1.withOpacity(0.3),
                            fontFamily: 'Poppins',
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: TColor.primaryColor1.withOpacity(0.3), // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: TColor.primaryColor1.withOpacity(0.3), // Default border color
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
                      // email
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
                              'Email',
                              style: TextStyle(
                                color: TColor.primaryColor1.withOpacity(0.7),
                                fontFamily: 'Poppins',
                              ),
                          ),
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(
                            color: TColor.primaryColor1.withOpacity(0.3),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: TColor.primaryColor1.withOpacity(0.3), // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: TColor.primaryColor1.withOpacity(0.3), // Default border color
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
                      // password
                      TextFormField(
                        cursorColor: TColor.primaryColor1.withOpacity(0.7),
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(
                              'Password',
                            style: TextStyle(
                              color: TColor.primaryColor1.withOpacity(0.7),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(
                            color: TColor.primaryColor1.withOpacity(0.3),
                            fontFamily: 'Poppins',
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: TColor.primaryColor1.withOpacity(0.3), // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: TColor.primaryColor1.withOpacity(0.3), // Default border color
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
                        height: 20.0,
                      ),
                      // i agree to the processing
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(right: 8.0), // Adds a left margin for positioning
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ensures the row fits its content
                          children: [
                            Checkbox(
                              value: agreePersonalData,
                              onChanged: (bool? value) {
                                setState(() {
                                  agreePersonalData = value!;
                                });
                              },
                              activeColor: TColor.primaryColor1,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'I agree to the processing of ',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: TColor.primaryColor1.withOpacity(0.6),
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    WidgetSpan( // Make "Personal data" clickable
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration: Duration(milliseconds: 300), // Animation duration
                                              pageBuilder: (context, animation, secondaryAnimation) => PersonalDataScreen(),
                                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                const begin = Offset(1.0, 0.0); // Right to left transition
                                                const end = Offset.zero;
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
                                          'Personal data',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.bold,
                                            color: TColor.primaryColor1,
                                            fontFamily: 'Poppins',
                                            decoration: TextDecoration.underline,
                                          ),
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
                      const SizedBox(
                        height: 25.0,
                      ),
                      // signup button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          // onPressed: () {
                          //   if (_formSignupKey.currentState!.validate() &&
                          //       agreePersonalData) {
                          //     // ScaffoldMessenger.of(context).showSnackBar(
                          //     //   const SnackBar(
                          //     //     content: Text('Processing Data'),
                          //     //   ),
                          //     // );
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(builder: (context) => OTP_Page()),
                          //     );
                          //   } else if (!agreePersonalData) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //           content: Text(
                          //               'Please agree to the processing of personal data')),
                          //     );
                          //   }
                          // },
                          onPressed: authProvider.isLoading
                              ? null
                              : _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primaryColor1,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      // sign up divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: TColor.primaryColor1.withOpacity(0.6),
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      // sign up social media logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Logo(Logos.facebook_f),
                          // Logo(Logos.twitter),
                          Logo(Logos.google),
                          // Logo(Logos.apple),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: TColor.primaryColor1.withOpacity(0.6),
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 300), // Animation duration
                                  pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0); // Start from left
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
                              'Log in',
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