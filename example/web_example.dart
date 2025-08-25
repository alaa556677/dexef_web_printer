import 'dart:html' as html;
import 'dart:convert';
import 'dart:typed_data';

// For web, we'll simulate the WebPrint Agent client since we can't import the package directly
// This demonstrates how the package would work in a web environment

/// Simulated WebPrint Agent client for web demonstration
class WebPrintAgentClient {
  final String baseUrl;
  final String apiKey;
  final Duration timeout;

  WebPrintAgentClient({
    required this.apiKey,
    this.baseUrl = 'http://127.0.0.1:5123',
    this.timeout = const Duration(seconds: 30),
  });

  /// Simulate health check
  Future<Map<String, dynamic>> checkHealth() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'status': 'ok',
      'version': '1.0.0',
      'os': 'web',
      'arch': 'js',
      'uptime': 123.45,
      'memory': {
        'rss': 52428800, // 50MB
        'heapTotal': 41943040, // 40MB
        'heapUsed': 20971520, // 20MB
        'external': 1048576, // 1MB
        'arrayBuffers': 524288, // 0.5MB
      },
    };
  }

  /// Simulate listing printers
  Future<List<Map<String, dynamic>>> listPrinters() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      {
        'name': 'HP LaserJet Pro (Web Demo)',
        'portName': 'WEB001',
        'ipAddress': '192.168.1.100',
        'driverName': 'HP LaserJet Pro',
        'location': 'Office',
        'comment': 'Web demonstration printer',
      },
      {
        'name': 'Canon Printer (Web Demo)',
        'portName': 'WEB002',
        'driverName': 'Canon Driver',
        'location': 'Home',
        'comment': 'Web demonstration printer',
      },
    ];
  }

  /// Simulate getting default printer
  Future<Map<String, dynamic>?> getDefaultPrinter() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return {
      'name': 'HP LaserJet Pro (Web Demo)',
      'portName': 'WEB001',
      'ipAddress': '192.168.1.100',
      'driverName': 'HP LaserJet Pro',
      'location': 'Office',
    };
  }

  /// Simulate getting print jobs
  Future<List<Map<String, dynamic>>> getPrintJobs({int? limit}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final jobs = [
      {
        'id': 'web-job-001',
        'timestamp':
            DateTime.now().millisecondsSinceEpoch - 300000, // 5 minutes ago
        'printer': 'HP LaserJet Pro (Web Demo)',
        'filename': 'document.pdf',
        'status': 'success',
      },
      {
        'id': 'web-job-002',
        'timestamp':
            DateTime.now().millisecondsSinceEpoch - 3600000, // 1 hour ago
        'printer': 'HP LaserJet Pro (Web Demo)',
        'filename': 'report.pdf',
        'status': 'success',
      },
      {
        'id': 'web-job-003',
        'timestamp':
            DateTime.now().millisecondsSinceEpoch - 7200000, // 2 hours ago
        'printer': 'Canon Printer (Web Demo)',
        'filename': 'test.pdf',
        'status': 'error',
        'error': 'Printer offline (Web Demo)',
      },
    ];

    if (limit != null && limit < jobs.length) {
      return jobs.take(limit).toList();
    }
    return jobs;
  }

  /// Simulate printing
  Future<Map<String, dynamic>> printPdf({
    required Uint8List pdfData,
    required String filename,
    String? printer,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return {
      'jobId': 'web-job-${DateTime.now().millisecondsSinceEpoch}',
      'printer': printer ?? 'HP LaserJet Pro (Web Demo)',
      'filename': filename,
      'status': 'queued',
      'message': 'Print job submitted successfully (Web Demo)',
    };
  }

  /// Test connection
  Future<bool> testConnection() async {
    try {
      await checkHealth();
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    // No cleanup needed for web
  }
}

/// Main web example
void main() {
  // Set up the web page
  _setupWebPage();

  // Initialize the client
  final client = WebPrintAgentClient(
    apiKey: '49a65c3e-3fa6-436a-9376-b5daff101491',
    baseUrl: 'http://127.0.0.1:5123',
  );

  // Set up event listeners
  _setupEventListeners(client);

  // Initial connection test
  _testConnection(client);
}

/// Set up the web page structure
void _setupWebPage() {
  final body = html.document.body!;
  body.style.margin = '0';
  body.style.padding = '20px';
  body.style.fontFamily = 'Arial, sans-serif';
  body.style.backgroundColor = '#f5f5f5';

  body.append(html.DivElement()
    ..style.cssText =
        'max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'
    ..setInnerHtml('''
      <h1 style="color: #2c3e50; text-align: center; margin-bottom: 30px;">🖨️ WebPrint Agent - Web Demo</h1>
      
      <div style="background: #e8f4fd; padding: 20px; border-radius: 8px; margin-bottom: 30px; border-left: 4px solid #3498db;">
        <h3 style="margin-top: 0; color: #2980b9;">ℹ️ Web Demo Information</h3>
        <p style="margin: 10px 0;">This is a web demonstration of the WebPrint Agent Dart package. The examples below show simulated API responses to demonstrate how the package would work in a real Flutter web application.</p>
        <p style="margin: 10px 0;"><strong>Note:</strong> This demo uses simulated data. In a real application, you would connect to an actual WebPrint Agent server.</p>
      </div>

      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px;">
        <div style="background: #f8f9fa; padding: 20px; border-radius: 8px;">
          <h3 style="margin-top: 0; color: #2c3e50;">🔧 Configuration</h3>
          <p><strong>Base URL:</strong> <span id="baseUrl">http://127.0.0.1:5123</span></p>
          <p><strong>API Key:</strong> <span id="apiKey">49a65c3e-3fa6-436a-9376-b5daff101491</span></p>
          <p><strong>Status:</strong> <span id="connectionStatus">Testing...</span></p>
        </div>
        
        <div style="background: #f8f9fa; padding: 20px; border-radius: 8px;">
          <h3 style="margin-top: 0; color: #2c3e50;">📊 Quick Actions</h3>
          <button id="testConnectionBtn" style="width: 100%; padding: 10px; margin-bottom: 10px; background: #3498db; color: white; border: none; border-radius: 5px; cursor: pointer;">Test Connection</button>
          <button id="checkHealthBtn" style="width: 100%; padding: 10px; margin-bottom: 10px; background: #27ae60; color: white; border: none; border-radius: 5px; cursor: pointer;">Check Health</button>
          <button id="listPrintersBtn" style="width: 100%; padding: 10px; background: #e67e22; color: white; border: none; border-radius: 5px; cursor: pointer;">List Printers</button>
        </div>
      </div>

      <div style="margin-bottom: 30px;">
        <h3 style="color: #2c3e50;">📋 Results</h3>
        <div id="results" style="background: #f8f9fa; padding: 20px; border-radius: 8px; min-height: 200px; font-family: monospace; white-space: pre-wrap; overflow-x: auto;">
          Click a button above to see results...
        </div>
      </div>

      <div style="background: #fff3cd; padding: 20px; border-radius: 8px; border-left: 4px solid #ffc107;">
        <h3 style="margin-top: 0; color: #856404;">💡 How to Use in Flutter Web</h3>
        <p style="margin: 10px 0;">To use this package in a real Flutter web application:</p>
        <ol style="margin: 10px 0; padding-left: 20px;">
          <li>Add <code>webprint_agent: ^1.0.0</code> to your <code>pubspec.yaml</code></li>
          <li>Import the package: <code>import 'package:webprint_agent/webprint_agent.dart';</code></li>
          <li>Create a client instance with your API key</li>
          <li>Use the client methods to interact with your WebPrint Agent server</li>
        </ol>
      </div>
    '''));
}

/// Set up event listeners for the buttons
void _setupEventListeners(WebPrintAgentClient client) {
  // Test connection button
  html.document.getElementById('testConnectionBtn')!.onClick.listen((_) {
    _testConnection(client);
  });

  // Check health button
  html.document.getElementById('checkHealthBtn')!.onClick.listen((_) {
    _checkHealth(client);
  });

  // List printers button
  html.document.getElementById('listPrintersBtn')!.onClick.listen((_) {
    _listPrinters(client);
  });
}

/// Test connection to the WebPrint Agent
void _testConnection(WebPrintAgentClient client) async {
  _updateResults('Testing connection to WebPrint Agent...\n');
  _updateConnectionStatus('Testing...');

  try {
    final isConnected = await client.testConnection();
    if (isConnected) {
      _updateResults(
          '✅ Connection successful! WebPrint Agent is accessible.\n');
      _updateConnectionStatus('Connected');
    } else {
      _updateResults(
          '❌ Connection failed. WebPrint Agent is not accessible.\n');
      _updateConnectionStatus('Failed');
    }
  } catch (e) {
    _updateResults('❌ Connection error: $e\n');
    _updateConnectionStatus('Error');
  }
}

/// Check health status
void _checkHealth(WebPrintAgentClient client) async {
  _updateResults('Checking health status...\n');

  try {
    final health = await client.checkHealth();
    _updateResults('''
✅ Health check successful!

Status: ${health['status']}
Version: ${health['version']}
OS: ${health['os']}
Architecture: ${health['arch']}
Uptime: ${health['uptime'].toStringAsFixed(1)}s
Memory Usage:
  RSS: ${(health['memory']['rss'] / (1024 * 1024)).toStringAsFixed(2)}MB
  Heap Total: ${(health['memory']['heapTotal'] / (1024 * 1024)).toStringAsFixed(2)}MB
  Heap Used: ${(health['memory']['heapUsed'] / (1024 * 1024)).toStringAsFixed(2)}MB
  External: ${(health['memory']['external'] / (1024 * 1024)).toStringAsFixed(2)}MB
  Array Buffers: ${(health['memory']['arrayBuffers'] / (1024 * 1024)).toStringAsFixed(2)}MB

''');
  } catch (e) {
    _updateResults('❌ Health check failed: $e\n');
  }
}

/// List available printers
void _listPrinters(WebPrintAgentClient client) async {
  _updateResults('Listing available printers...\n');

  try {
    final printers = await client.listPrinters();
    _updateResults('''
✅ Found ${printers.length} printer(s):

${printers.map((printer) => '''
🖨️  ${printer['name']}
    Port: ${printer['portName'] ?? 'N/A'}
    Driver: ${printer['driverName'] ?? 'N/A'}
    Location: ${printer['location'] ?? 'N/A'}
    IP: ${printer['ipAddress'] ?? 'N/A'}
    Comment: ${printer['comment'] ?? 'N/A'}
''').join('\n')}

''');
  } catch (e) {
    _updateResults('❌ Failed to list printers: $e\n');
  }
}

/// Update the results display
void _updateResults(String text) {
  final resultsElement = html.document.getElementById('results')!;
  resultsElement.text = text;
}

/// Update the connection status
void _updateConnectionStatus(String status) {
  final statusElement = html.document.getElementById('connectionStatus')!;
  statusElement.text = status;

  // Update color based on status
  switch (status.toLowerCase()) {
    case 'connected':
      statusElement.style.color = '#27ae60';
      break;
    case 'failed':
    case 'error':
      statusElement.style.color = '#e74c3c';
      break;
    default:
      statusElement.style.color = '#f39c12';
  }
}
