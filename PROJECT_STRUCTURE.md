# Project Structure Overview

This document provides a comprehensive overview of the WebPrint Agent project structure and organization.

## Directory Structure

```
webprint-agent/
├── 📁 src/                          # Source code (TypeScript)
│   ├── 📄 index.ts                  # Main entry point
│   ├── 📄 server.ts                 # Express server setup
│   ├── 📁 routes/                   # API route handlers
│   │   ├── 📄 health.ts            # Health check endpoint
│   │   ├── 📄 printers.ts          # Printer management endpoints
│   │   ├── 📄 print.ts             # PDF printing endpoint
│   │   └── 📄 jobs.ts              # Print job history endpoint
│   └── 📁 services/                 # Business logic services
│       ├── 📄 config.ts             # Configuration management
│       ├── 📄 security.ts           # API key authentication
│       ├── 📄 logger.ts             # Print job logging
│       ├── 📄 printers-win.ts       # Windows printer enumeration
│       ├── 📄 printers-posix.ts     # macOS/Linux printer enumeration
│       ├── 📄 print-win.ts          # Windows PDF printing (SumatraPDF)
│       └── 📄 print-posix.ts       # macOS/Linux PDF printing (lpr/lp)
├── 📁 config/                       # Configuration files
│   └── 📄 default.json              # Default application configuration
├── 📁 scripts/                      # Utility scripts
│   ├── 📄 win-service.js            # Windows service installation
│   ├── 📄 test-connection.js        # API connection testing
│   ├── 📄 validate-setup.js         # Project setup validation
│   ├── 📄 start-agent.bat           # Windows batch startup script
│   └── 📄 start-agent.ps1           # PowerShell startup script
├── 📁 vendor/                       # Third-party executables
│   └── 📁 sumatra/                  # SumatraPDF for Windows
│       ├── 📄 README.md             # Download instructions
│       └── 📄 SumatraPDF.exe        # PDF printing executable (user download)
├── 📁 samples/                      # Sample files for testing
│   └── 📄 README.md                 # Sample PDF creation guide
├── 📄 package.json                  # Node.js dependencies and scripts
├── 📄 tsconfig.json                 # TypeScript configuration
├── 📄 .gitignore                    # Git ignore patterns
├── 📄 README.md                     # Comprehensive documentation
├── 📄 QUICKSTART.md                 # Quick start guide
├── 📄 PROJECT_STRUCTURE.md          # This file
├── 📄 api.http                      # API testing examples
└── 📄 env.example                   # Environment configuration template
```

## Key Components

### 🚀 Entry Points
- **`src/index.ts`**: Application bootstrap
- **`src/server.ts`**: Express server configuration and middleware setup

### 🛣️ API Routes
- **`/health`**: System status (no authentication required)
- **`/printers`**: Printer management (list, default)
- **`/print`**: PDF printing endpoint
- **`/jobs`**: Print job history

### 🔧 Core Services
- **Configuration**: Loads and manages app/user settings
- **Security**: API key authentication middleware
- **Logging**: Rotating print job log with configurable retention
- **Printing**: Platform-specific PDF printing implementations

### 🖨️ Platform Support
- **Windows**: PowerShell-based printer enumeration + SumatraPDF printing
- **macOS**: CUPS-based printer enumeration + lpr printing
- **Linux**: CUPS-based printer enumeration + lp printing

### 📜 Utility Scripts
- **Service Management**: Windows service installation/uninstallation
- **Testing**: Connection testing and setup validation
- **Startup**: Platform-specific startup scripts

## File Naming Conventions

- **Routes**: `kebab-case.ts` (e.g., `print.ts`, `printers.ts`)
- **Services**: `kebab-case.ts` (e.g., `print-win.ts`, `printers-posix.ts`)
- **Scripts**: `kebab-case.js` (e.g., `win-service.js`, `test-connection.js`)
- **Configuration**: `kebab-case.json` (e.g., `default.json`)

## Architecture Patterns

### 🔐 Security
- API key authentication for all protected endpoints
- CORS configuration with regex-based origin validation
- Helmet.js security headers

### 📁 Configuration Management
- Hierarchical configuration with environment overrides
- User-specific configuration stored in `~/.webprint-agent/`
- Automatic API key generation on first run

### 🖨️ Printing Abstraction
- Platform detection with OS-specific implementations
- Common interface for printer enumeration and printing
- Graceful fallbacks and error handling

### 📝 Logging
- JSON-based structured logging
- Configurable log rotation and retention
- Print job tracking with success/error status

## Development Workflow

1. **Setup**: `npm install` → `npm run validate`
2. **Development**: `npm run dev` (with nodemon)
3. **Building**: `npm run build`
4. **Testing**: `npm run test-connection`
5. **Production**: `npm run start`

## Platform-Specific Features

### Windows
- PowerShell-based printer enumeration
- SumatraPDF silent printing
- Windows service installation
- Batch and PowerShell startup scripts

### macOS/Linux
- CUPS-based printer enumeration
- Native printing commands (lpr/lp)
- System service templates (optional)

## Configuration Files

- **`config/default.json`**: Application defaults
- **`~/.webprint-agent/config.json`**: User-specific settings
- **`env.example`**: Environment variable template

## Testing and Validation

- **`api.http`**: REST Client format API examples
- **`scripts/test-connection.js`**: Basic connectivity testing
- **`scripts/validate-setup.js`**: Complete project validation

## Deployment

- **Development**: `npm run dev` with hot reload
- **Production**: `npm run start` with compiled JavaScript
- **Windows Service**: `node scripts/win-service.js install`
- **Docker**: Ready for containerization (see README)

This structure provides a clean separation of concerns, platform-specific implementations, and comprehensive tooling for development, testing, and deployment.
