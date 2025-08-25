import 'package:flutter_test/flutter_test.dart';
import 'package:webprint_agent/webprint_agent.dart';

void main() {
  group('WebPrint Agent Tests', () {
    test('HealthStatus fromJson and toJson', () {
      final json = {
        'status': 'ok',
        'version': '1.0.0',
        'os': 'win32',
        'arch': 'x64',
        'uptime': 123.45,
        'memory': {
          'rss': 219070464,
          'heapTotal': 172253184,
          'heapUsed': 145909088,
          'external': 7669630,
          'arrayBuffers': 4675614,
        },
      };

      final health = HealthStatus.fromJson(json);
      expect(health.status, 'ok');
      expect(health.version, '1.0.0');
      expect(health.os, 'win32');
      expect(health.arch, 'x64');
      expect(health.uptime, 123.45);
      expect(health.memory.rss, 219070464);
      expect(health.memory.heapTotal, 172253184);
      expect(health.memory.heapUsed, 145909088);

      final convertedJson = health.toJson();
      expect(convertedJson['status'], 'ok');
      expect(convertedJson['version'], '1.0.0');
    });

    test('PrinterInfo fromJson and toJson', () {
      final json = {
        'name': 'HP LaserJet Pro',
        'portName': 'USB001',
        'ipAddress': '192.168.1.100',
        'driverName': 'HP LaserJet Pro',
        'location': 'Office',
        'comment': 'Main office printer',
      };

      final printer = PrinterInfo.fromJson(json);
      expect(printer.name, 'HP LaserJet Pro');
      expect(printer.portName, 'USB001');
      expect(printer.ipAddress, '192.168.1.100');
      expect(printer.driverName, 'HP LaserJet Pro');
      expect(printer.location, 'Office');
      expect(printer.comment, 'Main office printer');
      expect(printer.isNetworkPrinter, true);

      final convertedJson = printer.toJson();
      expect(convertedJson['name'], 'HP LaserJet Pro');
      expect(convertedJson['ipAddress'], '192.168.1.100');
    });

    test('PrintJob fromJson and toJson', () {
      final json = {
        'id': 'job-12345',
        'timestamp': 1640995200000,
        'printer': 'HP LaserJet Pro',
        'filename': 'document.pdf',
        'status': 'success',
      };

      final job = PrintJob.fromJson(json);
      expect(job.id, 'job-12345');
      expect(job.timestamp, 1640995200000);
      expect(job.printer, 'HP LaserJet Pro');
      expect(job.filename, 'document.pdf');
      expect(job.status, 'success');
      expect(job.isSuccessful, true);
      expect(job.hasError, false);

      final convertedJson = job.toJson();
      expect(convertedJson['id'], 'job-12345');
      expect(convertedJson['status'], 'success');
    });

    test('PrintJob with error', () {
      final json = {
        'id': 'job-67890',
        'timestamp': 1640995200000,
        'printer': 'HP LaserJet Pro',
        'filename': 'document.pdf',
        'status': 'error',
        'error': 'Printer offline',
      };

      final job = PrintJob.fromJson(json);
      expect(job.status, 'error');
      expect(job.error, 'Printer offline');
      expect(job.isSuccessful, false);
      expect(job.hasError, true);
    });

    test('ApiResponse success', () {
      final response = ApiResponse.success(
        data: 'test data',
        message: 'Success message',
        statusCode: 200,
      );

      expect(response.success, true);
      expect(response.data, 'test data');
      expect(response.message, 'Success message');
      expect(response.statusCode, 200);
      expect(response.hasData, true);
      expect(response.hasError, false);
    });

    test('ApiResponse error', () {
      final response = ApiResponse.error(
        error: 'Error message',
        message: 'Error occurred',
        statusCode: 500,
      );

      expect(response.success, false);
      expect(response.error, 'Error message');
      expect(response.message, 'Error occurred');
      expect(response.statusCode, 500);
      expect(response.hasData, false);
      expect(response.hasError, true);
    });

    test('NetworkException creation', () {
      final exception = NetworkException.fromResponse(
        404,
        'Not found',
        method: 'GET',
        url: 'http://example.com',
      );

      expect(exception.statusCode, 404);
      expect(exception.message, 'Not found');
      expect(exception.method, 'GET');
      expect(exception.url, 'http://example.com');
    });

    test('PrintException creation', () {
      final exception = PrintException(
        'Print failed',
        printerName: 'HP Printer',
        fileName: 'document.pdf',
        statusCode: 400,
      );

      expect(exception.message, 'Print failed');
      expect(exception.printerName, 'HP Printer');
      expect(exception.fileName, 'document.pdf');
      expect(exception.statusCode, 400);
    });

    test('ApiEndpoints constants', () {
      expect(ApiEndpoints.baseUrl, 'http://127.0.0.1:5123');
      expect(ApiEndpoints.health, '/health');
      expect(ApiEndpoints.printers, '/printers');
      expect(ApiEndpoints.defaultPrinter, '/printers/default');
      expect(ApiEndpoints.print, '/print');
      expect(ApiEndpoints.jobs, '/jobs');
      expect(ApiEndpoints.apiDocs, '/api-docs');
    });

    test('PrintStatus constants', () {
      expect(PrintStatus.success, 'success');
      expect(PrintStatus.error, 'error');
      expect(PrintStatus.processing, 'processing');
      expect(PrintStatus.queued, 'queued');
      expect(PrintStatus.cancelled, 'cancelled');
    });
  });
}
