import { spawn } from 'child_process';
import * as fs from 'fs-extra';
import * as path from 'path';
import { getConfig } from './config';

export async function printWin(pdfPath: string, printerName?: string): Promise<void> {
  const config = await getConfig();
  
  // Check if SumatraPDF exists
  if (!(await fs.pathExists(config.sumatraPath))) {
    throw new Error(
      `SumatraPDF not found at ${config.sumatraPath}. ` +
      `Please download SumatraPDF and place it in the vendor/sumatra/ directory, ` +
      `or set SUMATRA_PATH environment variable.`
    );
  }

  // If no printer specified, try to get default
  let targetPrinter = printerName;
  if (!targetPrinter) {
    try {
      const { defaultPrinterWin } = await import('./printers-win');
      const defaultPrinter = await defaultPrinterWin();
      if (!defaultPrinter) {
        throw new Error('No default printer found and no printer specified');
      }
      targetPrinter = defaultPrinter.name;
    } catch (error) {
      throw new Error(`Failed to get default printer: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  return new Promise((resolve, reject) => {
    const args = ['-silent', '-print-to', targetPrinter!, pdfPath];
    
    const sumatra = spawn(config.sumatraPath, args, {
      windowsHide: true,
      stdio: 'ignore'
    });

    sumatra.on('close', (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`SumatraPDF failed with exit code ${code}`));
      }
    });

    sumatra.on('error', (error) => {
      reject(new Error(`Failed to spawn SumatraPDF: ${error.message}`));
    });

    // Set a timeout to prevent hanging
    setTimeout(() => {
      sumatra.kill();
      reject(new Error('Print operation timed out after 30 seconds'));
    }, 30000);
  });
}
