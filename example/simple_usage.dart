import 'dart:typed_data';
import 'package:webprint_agent/webprint_agent.dart';

/// Simple example demonstrating WebPrint Agent usage
void main() async {
  print('WebPrint Agent Example\n');

  // Initialize the client
  final client = WebPrintAgentClient(
    apiKey: '49a65c3e-3fa6-436a-9376-b5daff101491', // Replace with your API key
    baseUrl: 'http://127.0.0.1:5123',
  );

  try {
    // Test connection
    print('1. Testing connection...');
    final isConnected = await client.testConnection();
    print('   Connection: ${isConnected ? "SUCCESS" : "FAILED"}\n');

    if (!isConnected) {
      print(
          '   Please ensure the WebPrint Agent is running on http://127.0.0.1:5123');
      print('   You can start it with: npm run dev');
      return;
    }

    // Check health
    print('2. Checking health status...');
    final health = await client.checkHealth();
    print('   Status: ${health.status}');
    print('   Version: ${health.version}');
    print('   OS: ${health.os}');
    print('   Architecture: ${health.arch}');
    print('   Uptime: ${health.uptime.toStringAsFixed(1)}s');
    print('   Memory: ${health.memory.rssMB.toStringAsFixed(2)}MB\n');

    // List printers
    print('3. Listing available printers...');
    final printers = await client.listPrinters();
    print('   Found ${printers.length} printer(s):');
    for (final printer in printers) {
      print('     - ${printer.name}');
      if (printer.location != null)
        print('       Location: ${printer.location}');
      if (printer.driverName != null)
        print('       Driver: ${printer.driverName}');
      if (printer.ipAddress != null) print('       IP: ${printer.ipAddress}');
      print('');
    }

    // Get default printer
    print('4. Getting default printer...');
    final defaultPrinter = await client.getDefaultPrinter();
    if (defaultPrinter != null) {
      print('   Default printer: ${defaultPrinter.name}');
      if (defaultPrinter.location != null)
        print('   Location: ${defaultPrinter.location}');
    } else {
      print('   No default printer set');
    }
    print('');

    // Get print jobs
    print('5. Getting recent print jobs...');
    final jobs = await client.getPrintJobs(limit: 5);
    print('   Found ${jobs.length} job(s):');
    for (final job in jobs) {
      print('     - ${job.filename}');
      print('       Printer: ${job.printer}');
      print('       Status: ${job.status}');
      print('       Created: ${job.formattedTimestamp}');
      if (job.error != null) print('       Error: ${job.error}');
      print('');
    }

    // Example of printing (commented out since we don't have a real PDF)
    print('6. Example of how to print a PDF:');
    print('''
   // Create a sample PDF data (replace with actual PDF)
   final pdfData = Uint8List.fromList([/* PDF bytes */]);
   
   try {
     final result = await client.printPdf(
       pdfData: pdfData,
       filename: 'document.pdf',
       printer: defaultPrinter?.name, // Use default printer if available
     );
     print('   Print job submitted successfully');
     print('   Job ID: \${result['jobId']}');
   } catch (e) {
     print('   Print failed: \$e');
   }
''');
  } catch (e) {
    print('Error: $e');
  } finally {
    // Clean up
    client.dispose();
  }
}

/// Example of error handling
void demonstrateErrorHandling() async {
  final client = WebPrintAgentClient(
    apiKey: 'invalid-key',
    baseUrl: 'http://127.0.0.1:5123',
  );

  try {
    await client.listPrinters();
  } on NetworkException catch (e) {
    if (e.statusCode == 401) {
      print('Authentication failed: Invalid API key');
    } else {
      print('Network error: ${e.message}');
    }
  } on PrintException catch (e) {
    print('Print error: ${e.message}');
  } catch (e) {
    print('Unexpected error: $e');
  } finally {
    client.dispose();
  }
}

/// Example of printing with error handling
Future<void> printDocument({
  required Uint8List pdfData,
  required String filename,
  String? printer,
}) async {
  final client = WebPrintAgentClient(
    apiKey: '49a65c3e-3fa6-436a-9376-b5daff101491',
  );

  try {
    // First check if the agent is available
    final isConnected = await client.testConnection();
    if (!isConnected) {
      throw Exception('WebPrint Agent is not available');
    }

    // Get available printers if none specified
    if (printer == null) {
      final printers = await client.listPrinters();
      if (printers.isEmpty) {
        throw Exception('No printers available');
      }
      printer = printers.first.name;
      print('Using printer: $printer');
    }

    // Submit print job
    final result = await client.printPdf(
      pdfData: pdfData,
      filename: filename,
      printer: printer,
    );

    print('Print job submitted successfully');
    print('Job ID: ${result['jobId']}');
    print('Printer: ${result['printer']}');
    print('Filename: ${result['filename']}');
  } on NetworkException catch (e) {
    print('Network error: ${e.message}');
    if (e.statusCode == 401) {
      print('Please check your API key');
    }
  } on PrintException catch (e) {
    print('Print error: ${e.message}');
    if (e.printerName != null) {
      print('Printer: ${e.printerName}');
    }
  } catch (e) {
    print('Unexpected error: $e');
  } finally {
    client.dispose();
  }
}
