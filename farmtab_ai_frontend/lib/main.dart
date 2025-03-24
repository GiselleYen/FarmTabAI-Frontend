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
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'FarmTab AI',
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