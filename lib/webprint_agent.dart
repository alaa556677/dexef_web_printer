/// WebPrint Agent - A cross-platform local print agent for Flutter applications
///
/// This package provides a client for the WebPrint Agent API, allowing Flutter apps
/// to interact with local printers through a REST API.
library webprint_agent;

// Core API client
export 'src/api_client.dart';

// Models
export 'src/models/printer_info.dart';
export 'src/models/print_job.dart';
export 'src/models/health_status.dart';
export 'src/models/api_response.dart';

// Exceptions
export 'src/exceptions/webprint_exception.dart';
export 'src/exceptions/print_exception.dart';
export 'src/exceptions/network_exception.dart';

// Constants
export 'src/constants/api_endpoints.dart';
export 'src/constants/print_status.dart';
