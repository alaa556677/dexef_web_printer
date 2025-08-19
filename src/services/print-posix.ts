import { spawn } from 'child_process';
import * as os from 'os';

export async function printPosix(pdfPath: string, printerName?: string): Promise<void> {
  const platform = os.platform();
  
  // If no printer specified, try to get default
  let targetPrinter = printerName;
  if (!targetPrinter) {
    try {
      const { defaultPrinterPosix } = await import('./printers-posix');
      const defaultPrinter = await defaultPrinterPosix();
      if (!defaultPrinter) {
        throw new Error('No default printer found and no printer specified');
      }
      targetPrinter = defaultPrinter.name;
    } catch (error) {
      throw new Error(`Failed to get default printer: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  return new Promise((resolve, reject) => {
    let command: string;
    let args: string[];

    if (platform === 'darwin') {
      // macOS
      command = 'lpr';
      args = ['-P', targetPrinter!, pdfPath];
    } else {
      // Linux
      command = 'lp';
      args = ['-d', targetPrinter!, pdfPath];
    }

    const printProcess = spawn(command, args, {
      stdio: 'ignore'
    });

    printProcess.on('close', (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`${command} failed with exit code ${code}`));
      }
    });

    printProcess.on('error', (error) => {
      reject(new Error(`Failed to spawn ${command}: ${error.message}`));
    });

    // Set a timeout to prevent hanging
    setTimeout(() => {
      printProcess.kill();
      reject(new Error('Print operation timed out after 30 seconds'));
    }, 30000);
  });
}
