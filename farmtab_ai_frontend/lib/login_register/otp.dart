import 'dart:async';

import 'package:farmtab_ai_frontend/login_register/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widget/custom_welcome_scaffold.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import '../widget/custome_input_decoration.dart';

class OTP_Page extends StatefulWidget {
  final String email;
  const OTP_Page({super.key, required this.email});

  @override
  State<OTP_Page> createState() => _OTP_PageState();
}

class _OTP_PageState extends State<OTP_Page> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  bool _isResendingCode = false;
  int _timeLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCooldownTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldownTimer() {
    setState(() {
      _timeLeft = 60;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resendCode() async {
    if (_timeLeft > 0 || _isResendingCode) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isResendingCode = true;
    });

    final success = await authProvider.resendConfirmationCode(widget.email);

    setState(() {
      _isResendingCode = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification code resent. Please check your email.'))
      );
      _startCooldownTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? 'Failed to resend code'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    void _verifyOTP() async {
      if (_formKey.currentState!.validate()) {
        final success = await Provider.of<AuthProvider>(context, listen: false)
            .confirmRegistration(widget.email, _otpController.text.trim());

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP Verified Successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          await Future.delayed(const Duration(seconds: 1));
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignInScreen())
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Verify Your Account',
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w900,
                          color: TColor.primaryColor1,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: _otpController,
                        cursorColor: TColor.primaryColor1.withOpacity(0.7),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the verification code';
                          }
                          return null;
                        },
                        decoration: CustomInputDecoration.build(
                            label: 'Verification Code'),
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
                              fontFamily: 'Inter',
                            ),
                          ),
                          GestureDetector(
                            onTap: (_isResendingCode || _timeLeft > 0) ? null : _resendCode,
                            child: Text(
                              _isResendingCode
                                  ? 'Sending...'
                                  : (_timeLeft > 0
                                  ? 'Resend in $_timeLeft s'
                                  : 'Resend it'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Inter',
                                decoration: (_isResendingCode || _timeLeft > 0)
                                    ? TextDecoration.none
                                    : TextDecoration.underline,
                                color: (_isResendingCode || _timeLeft > 0)
                                    ? TColor.primaryColor1.withOpacity(0.5)  // Dimmed when disabled
                                    : TColor.primaryColor1,
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
                          onPressed: authProvider.isLoading
                              ? null
                              : _verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primaryColor1,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            'Register Account',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Poppins',
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
