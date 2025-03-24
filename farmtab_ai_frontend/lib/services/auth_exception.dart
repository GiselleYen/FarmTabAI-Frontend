// Add this to a new file: lib/exceptions/auth_exceptions.dart
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() => message;
}