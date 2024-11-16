import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/widget/custom_welcome_scaffold.dart';
import 'package:farmtab_ai_frontend/widget/welcome_button.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomWelcomeScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text:  TextSpan(
                      children: [
                        TextSpan(
                            text: 'Welcome Home!\n',
                            style: TextStyle(
                              fontSize: 44.0,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  offset: Offset(2.0, 2.0), // Adjust the shadow offset
                                  blurRadius: 3.0,           // Adjust the blur radius
                                  color: Color(0xFF5D8C3F).withOpacity(0.5), // Shadow color
                                ),
                              ],
                            )
                        ),
                        TextSpan(
                            text:
                            '\nDaily care to keep your plants healthy and thriving',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              shadows: [
                                Shadow(
                                  offset: Offset(1.5, 2.0), // Adjust the shadow offset
                                  blurRadius: 3.0,           // Adjust the blur radius
                                  color: Color(0xFF5D8C3F).withOpacity(0.5), // Shadow color
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Log in',
                      onTap: SignInScreen(),
                      color: TColor.primaryColor1,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.transparent,
                       textColor: TColor.primaryColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}