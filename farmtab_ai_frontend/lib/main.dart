import 'package:farmtab_ai_frontend/homepage/home_page.dart';
import 'package:farmtab_ai_frontend/login_register/signin_screen.dart';
import 'package:farmtab_ai_frontend/nav%20tab/home_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

import 'login_register/onboarding_screen.dart';
import 'login_register/welcome_screen.dart';

void main() async{
  // Add this line
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Load the dotenv file
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'FarmTab AI',
  //     // home: OnboardingScreen(),
  //     home: HomeTabView(),
  //     // home: SiteList(),
  //     // home: ShelfTabView(),
  //     // home: DatabaseTestPage(),
  //     debugShowCheckedModeBanner: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'FarmTab AI',
            // theme: ThemeData(
            //   primarySwatch: Colors.blue,
            // ),
            home: authProvider.isLoading
                ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                : authProvider.isLoggedIn
                ? const HomeTabView()
                : const WelcomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

}