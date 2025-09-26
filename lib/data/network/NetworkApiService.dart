// network_api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../exceptions/ApiExceptions.dart';
import 'BaseApiService.dart';




class NetworkApiService extends BaseApiService {
  @override
  Future<dynamic> getApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 20));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on HttpException {
      throw FetchDataException('Could not find the resource');
    } on FormatException {
      throw FetchDataException('Bad response format');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      )
          .timeout(const Duration(seconds: 10));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on HttpException {
      throw FetchDataException('Could not find the resource');
    } on FormatException {
      throw FetchDataException('Bad response format');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200: // Success
        return jsonDecode(response.body);
      case 201: // Created
        return jsonDecode(response.body);
      case 204: // No content
        return "No Content";
      case 400: // Bad request
        throw BadRequestException(response.body.toString());
      case 401: // Unauthorized
        throw UnauthorisedException(response.body.toString());
      case 403: // Forbidden
        throw UnauthorisedException("Forbidden: ${response.body}");
      case 404: // Not found
        throw FetchDataException("Resource not found: ${response.body}");
      case 408: // Request timeout
        throw FetchDataException("Request Timeout");
      case 409: // Conflict
        throw FetchDataException("Conflict: ${response.body}");
      case 422: // Unprocessable Entity
        throw BadRequestException("Validation Error: ${response.body}");
      case 429: // Too many requests
        throw FetchDataException("Too many requests. Try again later.");
      case 500: // Internal server error
        throw FetchDataException("Internal Server Error: ${response.body}");
      case 503: // Service unavailable
        throw FetchDataException("Service Unavailable. Try later.");
      default:
        throw FetchDataException(
            "Error occurred with code: ${response.statusCode}, body: ${response.body}");
    }
  }
}
