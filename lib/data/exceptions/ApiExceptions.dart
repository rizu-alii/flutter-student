// app_exceptions.dart

class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

// Exception when communication fails
class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Error During Communication: ');
}

// Exception for invalid request
class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Invalid Request: ');
}

// Exception for unauthorized access
class UnauthorisedException extends AppException {
  UnauthorisedException([String? message]) : super(message, 'Unauthorized: ');
}

// Exception for invalid input
class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, 'Invalid Input: ');
}
