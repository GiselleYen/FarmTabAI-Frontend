import 'package:farmtab_ai_frontend/login_register/signin_screen.dart';
import 'package:flutter/material.dart';

import '../widget/custom_welcome_scaffold.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';

class OTP_Page extends StatefulWidget {
  const OTP_Page({super.key});

  @override
  State<OTP_Page> createState() => _OTP_PageState();
}

class _OTP_PageState extends State<OTP_Page> {
  final _formSignInKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return CustomWelcomeScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 4,
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
                        'Verify Your Account',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: TColor.primaryColor1,
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the verification code';
                          }
                          return null;
                        },
                        decoration: InputDecoration(

                          hintText: 'Enter The Verification Code',
                          hintStyle: TextStyle(
                            color: TColor.primaryColor1.withOpacity(0.3),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: TColor.primaryColor1, // Default border color
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Doesn't receive the code? ",
                            style: TextStyle(
                              color: TColor.primaryColor1.withOpacity(0.7),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Logic to resend the code
                              print('Resend code tapped');
                            },
                            child: Text(
                              'Resend it',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: TColor.primaryColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // if (_formSignInKey.currentState!.validate() && rememberPassword) {
                            //   // ScaffoldMessenger.of(context).showSnackBar(
                            //   //   const SnackBar(
                            //   //     content: Text('Processing Data'),
                            //   //   ),
                            //   // );
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => SignInScreen()),
                            //   );
                            // } else if (!rememberPassword) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text('Please agree to the processing of personal data'),
                            //     ),
                            //   );
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primaryColor1,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Register Account',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
