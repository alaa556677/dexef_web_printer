# SumatraPDF Directory

This directory should contain the SumatraPDF executable for Windows PDF printing.

## Download Instructions

1. Go to [SumatraPDF Downloads](https://www.sumatrapdfreader.org/download-free-pdf-viewer)
2. Download the **portable version** (not the installer)
3. Extract the ZIP file
4. Copy `SumatraPDF.exe` to this directory (`vendor/sumatra/`)

## File Structure
```
vendor/sumatra/
├── README.md          # This file
└── SumatraPDF.exe     # Place the executable here
```

## Alternative Configuration

If you prefer to place SumatraPDF elsewhere, you can:

1. Set the `SUMATRA_PATH` environment variable
2. Modify the `sumatraPath` in `config/default.json`
3. Update the path in your user config

## Verification

After placing the file, verify it exists by running:
```bash
ls vendor/sumatra/SumatraPDF.exe
```

The WebPrint Agent will check for this file on startup and provide helpful error messages if it's missing.
