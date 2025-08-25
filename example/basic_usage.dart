import 'dart:typed_data';
import 'package:webprint_agent/webprint_agent.dart';

/// Basic usage example for WebPrint Agent
void main() async {
  print('=== WebPrint Agent Basic Usage Example ===\n');

  // Initialize the client
  final client = WebPrintAgentClient(
    apiKey: '49a65c3e-3fa6-436a-9376-b5daff101491', // Replace with your API key
    baseUrl: 'http://127.0.0.1:5123',
  );

  try {
    // Test connection
    print('1. Testing connection...');
    final isConnected = await client.testConnection();
    print('   Connection: ${isConnected ? "✅ SUCCESS" : "❌ FAILED"}');

    if (!isConnected) {
      print('\n   💡 Please ensure the WebPrint Agent is running:');
      print('     1. Navigate to the WebPrint Agent directory');
      print('     2. Run: npm run dev');
      print('     3. Copy the API key from the console output');
      print('     4. Update the apiKey in this example');
      return;
    }

    print('');

    // Check health status
    print('2. Checking health status...');
    final health = await client.checkHealth();
    print('   Status: ${health.status}');
    print('   Version: ${health.version}');
    print('   OS: ${health.os}');
    print('   Architecture: ${health.arch}');
    print('   Uptime: ${health.uptime.toStringAsFixed(1)}s');
    print('   Memory: ${health.memory.rssMB.toStringAsFixed(2)}MB');
    print('');

    // List available printers
    print('3. Listing available printers...');
    final printers = await client.listPrinters();
    print('   Found ${printers.length} printer(s):');

    for (int i = 0; i < printers.length; i++) {
      final printer = printers[i];
      print('   ${i + 1}. ${printer.name}');
      if (printer.location != null) {
        print('      📍 Location: ${printer.location}');
      }
      if (printer.driverName != null) {
        print('      🖨️  Driver: ${printer.driverName}');
      }
      if (printer.ipAddress != null) {
        print('      🌐 IP: ${printer.ipAddress}');
      }
      print('');
    }

    // Get default printer
    print('4. Getting default printer...');
    final defaultPrinter = await client.getDefaultPrinter();
    if (defaultPrinter != null) {
      print('   Default printer: ${defaultPrinter.name}');
      if (defaultPrinter.location != null) {
        print('   Location: ${defaultPrinter.location}');
      }
    } else {
      print('   No default printer set');
    }
    print('');

    // Get recent print jobs
    print('5. Getting recent print jobs...');
    final jobs = await client.getPrintJobs(limit: 5);
    print('   Found ${jobs.length} recent job(s):');

    for (int i = 0; i < jobs.length; i++) {
      final job = jobs[i];
      final statusIcon = job.isSuccessful ? '✅' : '❌';
      print('   ${i + 1}. $statusIcon ${job.filename}');
      print('      🖨️  Printer: ${job.printer}');
      print('      📅 Created: ${job.formattedTimestamp}');
      if (job.error != null) {
        print('      ⚠️  Error: ${job.error}');
      }
      print('');
    }

    // Example of how to print (commented out since we don't have a real PDF)
    print('6. Example of how to print a PDF:');
    print('''
   // To print a PDF, you would do:
   
   // Load your PDF file
   final pdfFile = File('path/to/your/document.pdf');
   final pdfData = await pdfFile.readAsBytes();
   
   try {
     final result = await client.printPdf(
       pdfData: pdfData,
       filename: 'document.pdf',
       printer: defaultPrinter?.name, // Use default printer if available
     );
     
     print('   ✅ Print job submitted successfully');
     print('   🆔 Job ID: \${result['jobId']}');
     print('   🖨️  Printer: \${result['printer']}');
     print('   📄 File: \${result['filename']}');
     
   } catch (e) {
     print('   ❌ Print failed: \$e');
   }
''');
  } catch (e) {
    print('❌ Error: $e');

    // Provide helpful error information
    if (e.toString().contains('401')) {
      print('\n💡 This looks like an authentication error.');
      print('   Please check your API key in the example.');
    } else if (e.toString().contains('Connection refused')) {
      print('\n💡 This looks like a connection error.');
      print('   Please ensure the WebPrint Agent is running.');
    }
  } finally {
    // Clean up
    client.dispose();
    print('\n🧹 Client disposed successfully');
  }
}

/// Example of error handling patterns
void demonstrateErrorHandling() async {
  print('\n=== Error Handling Examples ===\n');

  final client = WebPrintAgentClient(
    apiKey: 'invalid-key',
    baseUrl: 'http://127.0.0.1:5123',
  );

  try {
    await client.listPrinters();
  } on NetworkException catch (e) {
    if (e.statusCode == 401) {
      print('🔐 Authentication failed: Invalid API key');
      print('   Please check your API key configuration');
    } else if (e.statusCode == 404) {
      print('🔍 Endpoint not found: ${e.url}');
      print('   Please check the API endpoint configuration');
    } else {
      print('🌐 Network error: ${e.message}');
      print('   Status code: ${e.statusCode}');
    }
  } on PrintException catch (e) {
    print('🖨️  Print error: ${e.message}');
    if (e.printerName != null) {
      print('   Printer: ${e.printerName}');
    }
    if (e.fileName != null) {
      print('   File: ${e.fileName}');
    }
  } catch (e) {
    print('❓ Unexpected error: $e');
  } finally {
    client.dispose();
  }
}

/// Example of a complete printing workflow
Future<void> completePrintingWorkflow({
  required Uint8List pdfData,
  required String filename,
  String? preferredPrinter,
}) async {
  print('\n=== Complete Printing Workflow ===\n');

  final client = WebPrintAgentClient(
    apiKey: '49a65c3e-3fa6-436a-9376-b5daff101491',
  );

  try {
    // Step 1: Verify agent is running
    print('1️⃣  Verifying WebPrint Agent is running...');
    if (!await client.testConnection()) {
      throw Exception('WebPrint Agent is not available');
    }
    print('   ✅ Agent is running');

    // Step 2: Check agent health
    print('\n2️⃣  Checking agent health...');
    final health = await client.checkHealth();
    print('   ✅ Agent status: ${health.status}');
    print('   📊 Memory usage: ${health.memory.rssMB.toStringAsFixed(2)}MB');

    // Step 3: Get available printers
    print('\n3️⃣  Getting available printers...');
    final printers = await client.listPrinters();
    if (printers.isEmpty) {
      throw Exception('No printers available on the system');
    }
    print('   ✅ Found ${printers.length} printer(s)');

    // Step 4: Select target printer
    String targetPrinter;
    if (preferredPrinter != null) {
      // Check if preferred printer exists
      final preferred =
          printers.where((p) => p.name == preferredPrinter).firstOrNull;
      if (preferred != null) {
        targetPrinter = preferredPrinter;
        print('   🎯 Using preferred printer: $targetPrinter');
      } else {
        print('   ⚠️  Preferred printer "$preferredPrinter" not found');
        targetPrinter = printers.first!.name;
        print('   🎯 Falling back to: $targetPrinter');
      }
    } else {
      // Try to get default printer
      final defaultPrinter = await client.getDefaultPrinter();
      targetPrinter = defaultPrinter?.name ?? printers.first!.name;
      print('   🎯 Using printer: $targetPrinter');
    }

    // Step 5: Submit print job
    print('\n4️⃣  Submitting print job...');
    final result = await client.printPdf(
      pdfData: pdfData,
      filename: filename,
      printer: targetPrinter,
    );

    print('   ✅ Print job submitted successfully!');
    print('   🆔 Job ID: ${result['jobId']}');
    print('   🖨️  Printer: ${result['printer']}');
    print('   📄 File: ${result['filename']}');

    // Step 6: Verify job was created
    print('\n5️⃣  Verifying job creation...');
    final jobs = await client.getPrintJobs(limit: 1);
    final newJob = jobs.firstWhere(
      (job) => job.id == result['jobId'],
      orElse: () => throw Exception('Job not found in recent jobs'),
    );
    print('   ✅ Job verified in system');

    print('\n🎉 Printing workflow completed successfully!');
  } on NetworkException catch (e) {
    print('\n❌ Network error: ${e.message}');
    print('   Status: ${e.statusCode}');
    print('   Method: ${e.method ?? 'N/A'}');
    print('   URL: ${e.url ?? 'N/A'}');
  } on PrintException catch (e) {
    print('\n❌ Print error: ${e.message}');
    if (e.printerName != null) print('   Printer: ${e.printerName}');
    if (e.fileName != null) print('   File: ${e.fileName}');
  } catch (e) {
    print('\n❌ Unexpected error: $e');
  } finally {
    client.dispose();
    print('\n🧹 Client disposed');
  }
}
