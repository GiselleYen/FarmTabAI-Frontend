import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../services/auth_exception.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../login_register/welcome_screen.dart';
import '../theme/color_extension.dart'; // Import your welcome screen

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService(); // Add UserService
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _userProfile;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get userProfile => _userProfile;
  Function? onLoginSuccess;

  void setOnLoginSuccessCallback(Function callback) {
    onLoginSuccess = callback;
  }

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    _isLoggedIn = await _authService.isLoggedIn();

    // If logged in, try to fetch the user profile
    if (_isLoggedIn) {
      try {
        await fetchUserProfile();
      } catch (e) {
        // If fetching profile fails due to token expiration, reset login state
        if (e is UnauthorizedException) {
          await _authService.clearTokens();
          _isLoggedIn = false;
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // New method to fetch user profile
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      _userProfile = await _userService.getUserProfile();
      notifyListeners();
      return _userProfile!;
    } on UnauthorizedException {
      // If token is unauthorized, we'll handle it and rethrow
      rethrow;
    } catch (e) {
      _error = "Failed to load profile: $e";
      notifyListeners();
      throw e;
    }
  }

  Future<void> validateSession(BuildContext context) async {
    final isValid = await _authService.isTokenValid();

    if (!isValid && _isLoggedIn) {
      // Token is invalid but we thought we were logged in
      await handleSessionExpiration(context);
    }
  }

  Future<void> handleSessionExpiration(BuildContext context) async {
    // Update state
    await _authService.clearTokens();
    _isLoggedIn = false;
    _userProfile = null; // Clear the user profile

    // Show dialog only if context is available and valid
    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              children: [
                Icon(
                  Icons.timer_off_rounded,
                  color: TColor.primaryColor1,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'Session Expired',
                  style: TextStyle(
                    color: TColor.primaryColor1,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Text(
                'Your session has expired. Please login again to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontFamily: 'Poppins',),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primaryColor1,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Login Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      // Navigate to welcome screen after dialog is dismissed
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
              (Route<dynamic> route) => false,
        );
      }
    }

    notifyListeners();
  }

  // Helper method to handle user service calls with error handling
  Future<T> handleUserServiceCall<T>(
      BuildContext context,
      Future<T> Function() serviceCall
      ) async {
    try {
      return await serviceCall();
    } on UnauthorizedException catch (_) {
      await handleSessionExpiration(context);
      throw 'Session expired, please log in again';
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  // Method to get user profile with proper error handling
  Future<Map<String, dynamic>> getUserProfile(BuildContext context) async {
    return handleUserServiceCall(
      context,
          () => _userService.getUserProfile(),
    );
  }

  // Method to update user name with proper error handling
  Future<Map<String, dynamic>> updateUserName(BuildContext context, String username) async {
    return handleUserServiceCall(
      context,
          () => _userService.updateUserName(username),
    );
  }

  // Method to update user bio with proper error handling
  Future<Map<String, dynamic>> updateUserBio(BuildContext context, String bio) async {
    return handleUserServiceCall(
      context,
          () => _userService.updateUserBio(bio),
    );
  }

  // Method to upload profile image with proper error handling
  Future<Map<String, dynamic>> uploadProfileImage(BuildContext context, File imageFile) async {
    return handleUserServiceCall(
      context,
          () => _userService.uploadProfileImage(imageFile),
    );
  }

  Future<Map<String, dynamic>> authenticatedRequest(
      BuildContext context, String endpoint, {Map<String, dynamic>? data, String method = 'GET'}) async {
    try {
      final result = await _authService.authenticatedRequest(endpoint, data: data, method: method);
      return result;
    } on UnauthorizedException catch (_) {
      await handleSessionExpiration(context);
      return {'success': false, 'message': 'Session expired, please log in again'};
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(email, password, name);
      _isLoading = false;

      if (!response['success']) {
        _error = response['message'];
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> confirmRegistration(String email, String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.confirmRegistration(email, code);
      _isLoading = false;

      if (!response['success']) {
        _error = response['message'];
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendConfirmationCode(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.resendConfirmationCode(email);
      _isLoading = false;

      if (!response['success']) {
        _error = response['message'];
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);

      if (!response['success']) {
        _isLoading = false;
        _error = response['message'];
        notifyListeners();
        return false;
      }

      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();

      if (onLoginSuccess != null) {
        onLoginSuccess!();
      }
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.clearTokens();
    _isLoggedIn = false;

    try {
      await FirebaseMessaging.instance.deleteToken();
      print("🧹 FCM token deleted on logout");
    } catch (e) {
      print("⚠️ Error deleting FCM token: $e");
    }

    notifyListeners();
  }


  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.forgotPassword(email);
      _isLoading = false;

      if (!response['success']) {
        _error = response['message'];
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> confirmForgotPassword(String email, String code, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.confirmForgotPassword(email, code, newPassword);
      _isLoading = false;

      if (!response['success']) {
        _error = response['message'];
        notifyListeners();
        return false;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

}