// lib/core/network/response_code.dart

enum ResponseCode {
  success("200", "Operation completed successfully"),
  created("201", "Resource created successfully"),
  badRequest("400", "Bad request"),
  unauthorized("401", "Unauthorized"),
  forbidden("403", "Forbidden"),
  notFound("404", "Resource not found"),
  internalServerError("500", "Internal server error"),
  serviceUnavailable("503", "Service unavailable"),
  userNotFound("14", "User not found"),
  dataMandatory("63", "Mandatory data"),
  vpnDetected("83", "VPN detected"),
  generalError("10", "An error has occurred, please contact service provider.");

  final String code;
  final String message;

  const ResponseCode(this.code, this.message);

  @override
  String toString() => "$code: $message";

  /// Convert backend string code to Dart enum
  static ResponseCode fromCode(String code) {
    return ResponseCode.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ResponseCode.generalError,
    );
  }
}
