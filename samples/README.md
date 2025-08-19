# Sample Files Directory

This directory is for storing sample PDF files for testing the WebPrint Agent.

## Creating Test PDFs

### Option 1: Online PDF Generators
- [PDF24](https://tools.pdf24.org/en/create-pdf) - Create simple PDFs from text
- [SmallPDF](https://smallpdf.com/create-pdf) - Convert documents to PDF
- [ILovePDF](https://www.ilovepdf.com/create_pdf) - Create PDFs from various formats

### Option 2: Microsoft Word/Google Docs
1. Create a document with some text
2. Save/Export as PDF
3. Place the PDF file in this directory

### Option 3: Command Line (if you have tools installed)
```bash
# Using pandoc (if installed)
echo "# Test Document\n\nThis is a test PDF for the WebPrint Agent." > test.txt
pandoc test.txt -o test.pdf

# Using wkhtmltopdf (if installed)
echo "<h1>Test Document</h1><p>This is a test PDF for the WebPrint Agent.</p>" > test.html
wkhtmltopdf test.html test.pdf
```

## Recommended Test Files

Create these sample PDFs for testing:

1. **simple.pdf** - A simple 1-page document with text
2. **multi-page.pdf** - A multi-page document to test different scenarios
3. **large.pdf** - A larger file to test file size limits

## File Naming Convention

Use descriptive names for your test files:
- `test-simple.pdf`
- `test-multi-page.pdf`
- `test-large.pdf`
- `sample-document.pdf`

## Testing the Print Function

Once you have sample PDFs, you can test the print functionality:

1. Start the WebPrint Agent: `npm run dev`
2. Use the `api.http` file to test printing
3. Or use a tool like Postman/Insomnia
4. Make sure to include your API key in the `X-API-Key` header

## Note

The WebPrint Agent will automatically clean up temporary files after printing, so your original sample files will remain intact.
