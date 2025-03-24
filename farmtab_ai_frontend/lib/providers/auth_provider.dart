import 'package:flutter/material.dart';
import '../services/auth_exception.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    _isLoggedIn = await _authService.isLoggedIn();

    _isLoading = false;
    notifyListeners();
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

    // Show dialog only if context is available and valid
    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Session Expired'),
            content: const Text('Your session has expired. Please log in again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    notifyListeners();
  }

// Modify your authenticatedRequest method to catch unauthorized errors
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