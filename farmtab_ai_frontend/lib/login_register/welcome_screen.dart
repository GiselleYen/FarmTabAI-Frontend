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
              flex: 7,
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
                            text: 'Welcome FarmTab AI\n',
                            style: TextStyle(
                              fontSize: 50.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              shadows: [
                                Shadow(
                                  offset: Offset(1.6, 1.6),
                                  blurRadius: 3.0,
                                  color: TColor.primaryColor1.withOpacity(0.4),
                                ),
                              ],
                            )
                        ),
                        TextSpan(
                            text:
                            '\nDaily care to keep your plants healthy and thriving',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              shadows: [
                                Shadow(
                                  offset: Offset(1.5, 2.0),
                                  blurRadius: 3.2,
                                  color: TColor.primaryColor1.withOpacity(0.4),
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
                      onTap: const SignInScreen(),
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