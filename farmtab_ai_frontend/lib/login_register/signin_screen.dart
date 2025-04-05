import 'package:farmtab_ai_frontend/nav%20tab/home_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:farmtab_ai_frontend/widget/custom_welcome_scaffold.dart';
import 'package:farmtab_ai_frontend/theme/color_extension.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../admin/admin_page.dart';
import '../providers/auth_provider.dart';
import 'forget_password.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool rememberPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    void _login() async {
      if (_formSignInKey.currentState!.validate()) {
        if (!rememberPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please agree to the processing of personal data'),
            ),
          );
          return;
        }

        final email = _emailController.text.trim();
        final password = _passwordController.text;

        final success = await Provider.of<AuthProvider>(context, listen: false)
            .login(email, password);

        if (success) {
          if (email == 'admin@app.farmtab.my' && password == 'Farmtab@123') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AdminHomePage()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeTabView()),
            );
          }
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
            flex: 1,
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
                        'Welcome Back',
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
                        keyboardType: TextInputType.emailAddress,
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
                            fontFamily: 'Poppins',
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
                      TextFormField(
                        controller: _passwordController,
                        cursorColor: TColor.primaryColor1.withOpacity(0.7),
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
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: TColor.primaryColor1,
                                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 300), // Animation duration
                                  pageBuilder: (context, animation, secondaryAnimation) => ForgetPassword(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0); // Start from right (1.0 on X-axis)
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
                              'Forget password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TColor.primaryColor1,
                                fontFamily: 'Inter',
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
                              : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primaryColor1,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white, // Ensures visibility
                          )
                              : const Text(
                            'Log in',
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
                              'Log in with',
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
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Facebook login will be available in the next version."),
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Logo(Logos.facebook_f),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Google login will be available in the next version."),
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Logo(Logos.google),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
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
                                  pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
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
                              'Sign up',
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