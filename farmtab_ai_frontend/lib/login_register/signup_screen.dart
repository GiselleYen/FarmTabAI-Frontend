import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'package:farmtab_ai_frontend/widget/custom_welcome_scaffold.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  @override
  Widget build(BuildContext context) {
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
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: TColor.primaryColor1,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      // full name
                      TextFormField(
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
                              ),
                          ),
                          hintText: 'Enter Full Name',
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
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // email
                      TextFormField(
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
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // password
                      TextFormField(
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
                            ),
                          ),
                          hintText: 'Enter Password',
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
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      // i agree to the processing
                      Container(
                        alignment: Alignment.centerLeft, // Aligns the entire content to the left
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
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces the tap area size
                            ),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'I agree to the processing of ',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: TColor.primaryColor1.withOpacity(0.6),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Personal data',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: TColor.primaryColor1,
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
                          onPressed: () {
                            if (_formSignupKey.currentState!.validate() &&
                                agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing Data'),
                                ),
                              );
                            } else if (!agreePersonalData) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please agree to the processing of personal data')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primaryColor1,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: const Text(
                              'Sign up',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
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
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TColor.primaryColor1,
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