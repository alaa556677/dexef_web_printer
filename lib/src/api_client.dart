import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'constants/api_endpoints.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/print_exception.dart';
import 'models/health_status.dart';
import 'models/printer_info.dart';
import 'models/print_job.dart';

/// Main API client for WebPrint Agent
class WebPrintAgentClient {
  /// Base URL for the API
  final String baseUrl;

  /// API key for authentication
  final String apiKey;

  /// HTTP client instance
  final http.Client _httpClient;

  /// Request timeout duration
  final Duration timeout;

  /// Create a new WebPrint Agent client
  WebPrintAgentClient({
    String? baseUrl,
    required this.apiKey,
    http.Client? httpClient,
    Duration? timeout,
  })  : baseUrl = baseUrl ?? ApiEndpoints.baseUrl,
        _httpClient = httpClient ?? http.Client(),
        timeout = timeout ?? const Duration(seconds: 30);

  /// Dispose the HTTP client
  void dispose() {
    _httpClient.close();
  }

  /// Get common headers for authenticated requests
  Map<String, String> get _headers => {
        'X-API-Key': apiKey,
        'Content-Type': 'application/json',
      };

  /// Check the health status of the WebPrint Agent
  Future<HealthStatus> checkHealth() async {
    try {
      final response = await _httpClient
          .get(
            Uri.parse('$baseUrl${ApiEndpoints.health}'),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return HealthStatus.fromJson(json);
      } else {
        throw NetworkException.fromResponse(
          response.statusCode,
          'Health check failed: ${response.statusCode}',
          url: '$baseUrl${ApiEndpoints.health}',
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException.connectionError(
        'Failed to connect to WebPrint Agent: ${e.message}',
        url: '$baseUrl${ApiEndpoints.health}',
      );
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException.connectionError(
        'Unexpected error during health check: $e',
        url: '$baseUrl${ApiEndpoints.health}',
      );
    }
  }

  /// Get a list of all available printers
  Future<List<PrinterInfo>> listPrinters() async {
    try {
      final response = await _httpClient
          .get(
            Uri.parse('$baseUrl${ApiEndpoints.printers}'),
            headers: _headers,
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => PrinterInfo.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw NetworkException.fromResponse(
          response.statusCode,
          'Unauthorized: Invalid API key',
          method: 'GET',
          url: '$baseUrl${ApiEndpoints.printers}',
        );
      } else {
        throw NetworkException.fromResponse(
          response.statusCode,
          'Failed to list printers: ${response.statusCode}',
          method: 'GET',
          url: '$baseUrl${ApiEndpoints.printers}',
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException.connectionError(
        'Failed to connect to WebPrint Agent: ${e.message}',
        url: '$baseUrl${ApiEndpoints.printers}',
      );
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException.connectionError(
        'Unexpected error while listing printers: $e',
        url: '$baseUrl${ApiEndpoints.printers}',
      );
    }
  }

  /// Get the default printer
  Future<PrinterInfo?> getDefaultPrinter() async {
    try {
      final response = await _httpClient
          .get(
            Uri.parse('$baseUrl${ApiEndpoints.defaultPrinter}'),
            headers: _headers,
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json == null) return null;
        return PrinterInfo.fromJson(json as Map<String, dynamic>);
      } else if (response.statusCode == 401) {
        throw NetworkException.fromResponse(
          response.statusCode,
          'Unauthorized: Invalid API key',
          method: 'GET',
          url: '$baseUrl${ApiEndpoints.defaultPrinter}',
        );
      } else {
        throw NetworkException.fromResponse(
          response.statusCode,
          'Failed to get default printer: ${response.statusCode}',
          method: 'GET',
          url: '$baseUrl${ApiEndpoints.defaultPrinter}',
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException.connectionError(
        'Failed to connect to WebPrint Agent: ${e.message}',
        url: '$baseUrl${ApiEndpoints.defaultPrinter}',
      );
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException.connectionError(
        'Unexpected error while getting default printer: $e',
        url: '$baseUrl${ApiEndpoints.defaultPrinter}',
      );
    }
  }

  /// Print a PDF file
  Future<Map<String, dynamic>> printPdf({
    required Uint8List pdfData,
    required String filename,
    String? printer,
  }) async {
    try {
      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl${ApiEndpoints.print}'),
      );

      // Add headers
      request.headers['X-API-Key'] = apiKey;

      // Add printer field if specified
      if (printer != null && printer.isNotEmpty) {
        request.fields['printer'] = printer;
      }

      // Add PDF file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          pdfData,
          filename: filename,
        ),
      );

      // Send request
      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json;
      } else if (response.statusCode == 400) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        throw PrintException.fromJson(json);
      } else if (response.statusCode == 401) {
        throw NetworkException.fromResponse(
          response.statusCode,
          'Unauthorized: Invalid API key',
          method: 'POST',
          url: '$baseUrl${ApiEndpoints.print}',
        );
      } else {
        throw NetworkException.fromResponse(
          response.statusCode,
          'Print request failed: ${response.statusCode}',
          method: 'POST',
          url: '$baseUrl${ApiEndpoints.print}',
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException.connectionError(
        'Failed to connect to WebPrint Agent: ${e.message}',
        url: '$baseUrl${ApiEndpoints.print}',
      );
    } catch (e) {
      if (e is NetworkException || e is PrintException) rethrow;
      throw NetworkException.connectionError(
        'Unexpected error while printing: $e',
        url: '$baseUrl${ApiEndpoints.print}',
      );
    }
  }

  /// Get print job history
  Future<List<PrintJob>> getPrintJobs({int? limit}) async {
    try {
      final queryParameters = <String, String>{};
      if (limit != null) {
        queryParameters['limit'] = limit.toString();
      }

      final uri = Uri.parse('$baseUrl${ApiEndpoints.jobs}')
          .replace(queryParameters: queryParameters);

      final response =
          await _httpClient.get(uri, headers: _headers).timeout(timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => PrintJob.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw NetworkException.fromResponse(
          response.statusCode,
          'Unauthorized: Invalid API key',
          method: 'GET',
          url: uri.toString(),
        );
      } else {
        throw NetworkException.fromResponse(
          response.statusCode,
          'Failed to get print jobs: ${response.statusCode}',
          method: 'GET',
          url: uri.toString(),
        );
      }
    } on http.ClientException catch (e) {
      throw NetworkException.connectionError(
        'Failed to connect to WebPrint Agent: ${e.message}',
        url: '$baseUrl${ApiEndpoints.jobs}',
      );
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException.connectionError(
        'Unexpected error while getting print jobs: $e',
        url: '$baseUrl${ApiEndpoints.jobs}',
      );
    }
  }

  /// Test the connection to the WebPrint Agent
  Future<bool> testConnection() async {
    try {
      await checkHealth();
      return true;
    } catch (e) {
      return false;
    }
  }
}
