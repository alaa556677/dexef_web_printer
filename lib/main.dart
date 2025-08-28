import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'webprint_agent.dart';

void main() {
  runApp(const WebPrintAgentDemo());
}

class WebPrintAgentDemo extends StatelessWidget {
  const WebPrintAgentDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebPrint Agent Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WebPrintAgentHomePage(),
    );
  }
}

class WebPrintAgentHomePage extends StatefulWidget {
  const WebPrintAgentHomePage({super.key});

  @override
  State<WebPrintAgentHomePage> createState() => _WebPrintAgentHomePageState();
}

class _WebPrintAgentHomePageState extends State<WebPrintAgentHomePage> {
  final TextEditingController _apiKeyController = TextEditingController(
    text: '49a65c3e-3fa6-436a-9376-b5daff101491',
  );
  final TextEditingController _baseUrlController = TextEditingController(
    text: 'http://127.0.0.1:5123',
  );
  
  WebPrintAgentClient? _client;
  bool _isConnected = false;
  bool _isLoading = false;
  String _statusMessage = 'Not connected';
  List<PrinterInfo> _printers = [];
  PrinterInfo? _defaultPrinter;
  List<PrintJob> _printJobs = [];
  HealthStatus? _healthStatus;

  @override
  void initState() {
    super.initState();
    _initializeClient();
  }

  void _initializeClient() {
    _client = WebPrintAgentClient(
      apiKey: _apiKeyController.text,
      baseUrl: _baseUrlController.text,
    );
  }

  Future<void> _testConnection() async {
    if (_client == null) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testing connection...';
    });

    try {
      final isConnected = await _client!.testConnection();
      setState(() {
        _isConnected = isConnected;
        _statusMessage = isConnected ? 'Connected successfully!' : 'Connection failed';
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _statusMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkHealth() async {
    if (_client == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final health = await _client!.checkHealth();
      setState(() {
        _healthStatus = health;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Health check failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _listPrinters() async {
    if (_client == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final printers = await _client!.listPrinters();
      setState(() {
        _printers = printers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to list printers: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getDefaultPrinter() async {
    if (_client == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final defaultPrinter = await _client!.getDefaultPrinter();
      setState(() {
        _defaultPrinter = defaultPrinter;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get default printer: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getPrintJobs() async {
    if (_client == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final jobs = await _client!.getPrintJobs(limit: 10);
      setState(() {
        _printJobs = jobs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get print jobs: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPrintDialog() {
    showDialog(
      context: context,
      builder: (context) => PrintDialog(
        printers: _printers,
        defaultPrinter: _defaultPrinter,
        onPrint: _printPdf,
      ),
    );
  }

  Future<void> _printPdf(Uint8List pdfData, String filename, String? printer) async {
    if (_client == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _client!.printPdf(
        pdfData: pdfData,
        filename: filename,
        printer: printer,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Print job submitted successfully! Job ID: ${result['jobId']}')),
      );
      
      // Refresh print jobs
      await _getPrintJobs();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to print PDF: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebPrint Agent Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConnectionSection(),
            const SizedBox(height: 20),
            _buildActionsSection(),
            const SizedBox(height: 20),
            _buildResultsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connection Settings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _baseUrlController,
              decoration: const InputDecoration(
                labelText: 'Base URL',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (_client != null) {
                  _client = WebPrintAgentClient(
                    apiKey: _apiKeyController.text,
                    baseUrl: value,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (_client != null) {
                  _client = WebPrintAgentClient(
                    apiKey: value,
                    baseUrl: _baseUrlController.text,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testConnection,
                    child: Text(_isLoading ? 'Testing...' : 'Test Connection'),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isConnected ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusMessage,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _checkHealth,
                  child: const Text('Check Health'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _listPrinters,
                  child: const Text('List Printers'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _getDefaultPrinter,
                  child: const Text('Get Default Printer'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _getPrintJobs,
                  child: const Text('Get Print Jobs'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _showPrintDialog,
                  child: const Text('Print PDF'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_healthStatus != null) ...[
          _buildHealthCard(),
          const SizedBox(height: 16),
        ],
        if (_printers.isNotEmpty) ...[
          _buildPrintersCard(),
          const SizedBox(height: 16),
        ],
        if (_defaultPrinter != null) ...[
          _buildDefaultPrinterCard(),
          const SizedBox(height: 16),
        ],
        if (_printJobs.isNotEmpty) ...[
          _buildPrintJobsCard(),
        ],
      ],
    );
  }

  Widget _buildHealthCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Status',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('Status: ${_healthStatus!.status}'),
            Text('Version: ${_healthStatus!.version}'),
            Text('OS: ${_healthStatus!.os}'),
            Text('Architecture: ${_healthStatus!.arch}'),
            Text('Uptime: ${_healthStatus!.uptime.toStringAsFixed(1)}s'),
            Text('Memory RSS: ${(_healthStatus!.memory.rss / 1024 / 1024).toStringAsFixed(2)}MB'),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Printers (${_printers.length})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...(_printers.map((printer) => ListTile(
              title: Text(printer.name),
              subtitle: Text(printer.location ?? 'No location'),
              trailing: printer.ipAddress != null 
                ? Text(printer.ipAddress!, style: const TextStyle(fontSize: 12))
                : null,
            ))),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPrinterCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Default Printer',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_defaultPrinter!.name),
              subtitle: Text(_defaultPrinter!.location ?? 'No location'),
              trailing: _defaultPrinter!.ipAddress != null 
                ? Text(_defaultPrinter!.ipAddress!, style: const TextStyle(fontSize: 12))
                : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintJobsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Print Jobs (${_printJobs.length})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...(_printJobs.map((job) => ListTile(
              title: Text(job.filename),
              subtitle: Text('${job.printer} - ${job.formattedTimestamp}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: job.isSuccessful ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  job.status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ))),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _client?.dispose();
    super.dispose();
  }
}

class PrintDialog extends StatefulWidget {
  final List<PrinterInfo> printers;
  final PrinterInfo? defaultPrinter;
  final Function(Uint8List, String, String?) onPrint;

  const PrintDialog({
    super.key,
    required this.printers,
    required this.defaultPrinter,
    required this.onPrint,
  });

  @override
  State<PrintDialog> createState() => _PrintDialogState();
}

class _PrintDialogState extends State<PrintDialog> {
  String? _selectedPrinter;
  Uint8List? _pdfData;
  String _filename = '';

  @override
  void initState() {
    super.initState();
    _selectedPrinter = widget.defaultPrinter?.name;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Print PDF'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // File picker button
          ElevatedButton.icon(
            onPressed: _pickPdfFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('Select PDF File'),
          ),
          if (_filename.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Selected: $_filename', style: const TextStyle(fontSize: 12)),
          ],
          const SizedBox(height: 16),
          // Printer selection
          DropdownButtonFormField<String>(
            value: _selectedPrinter,
            decoration: const InputDecoration(
              labelText: 'Printer',
              border: OutlineInputBorder(),
            ),
            items: [
              if (widget.defaultPrinter != null)
                DropdownMenuItem(
                  value: widget.defaultPrinter!.name,
                  child: Text('${widget.defaultPrinter!.name} (Default)'),
                ),
              ...widget.printers
                  .where((p) => p.name != widget.defaultPrinter?.name)
                  .map((printer) => DropdownMenuItem(
                        value: printer.name,
                        child: Text(printer.name),
                      )),
            ],
            onChanged: (value) {
              setState(() {
                _selectedPrinter = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _pdfData != null && _selectedPrinter != null ? _print : null,
          child: const Text('Print'),
        ),
      ],
    );
  }

  void _pickPdfFile() {
    // For web, we'll use a file input
    final input = html.FileUploadInputElement()..accept = '.pdf';
    input.click();
    
    input.onChange.listen((event) {
      final file = input.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.onLoad.listen((event) {
          final result = reader.result as Uint8List;
          setState(() {
            _pdfData = result;
            _filename = file.name;
          });
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  void _print() {
    if (_pdfData != null && _selectedPrinter != null) {
      widget.onPrint(_pdfData!, _filename, _selectedPrinter);
      Navigator.of(context).pop();
    }
  }
}
