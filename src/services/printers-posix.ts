import { spawn } from 'child_process';
import { PrinterInfo } from './printers-win';

export async function listPrintersPosix(): Promise<PrinterInfo[]> {
  return new Promise((resolve, reject) => {
    const lpstat = spawn('lpstat', ['-a'], {
      windowsHide: true
    });

    let output = '';
    let errorOutput = '';

    lpstat.stdout.on('data', (data) => {
      output += data.toString();
    });

    lpstat.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    lpstat.on('close', (code) => {
      if (code === 0) {
        const printers = output
          .trim()
          .split('\n')
          .map(line => line.split(' ')[0])
          .filter(name => name && name.length > 0)
          .map(name => ({ name }));
        resolve(printers);
      } else {
        reject(new Error(`lpstat command failed with code ${code}: ${errorOutput}`));
      }
    });

    lpstat.on('error', (error) => {
      reject(new Error(`Failed to spawn lpstat: ${error.message}`));
    });
  });
}

export async function defaultPrinterPosix(): Promise<PrinterInfo | null> {
  return new Promise((resolve, reject) => {
    const lpstat = spawn('lpstat', ['-d'], {
      windowsHide: true
    });

    let output = '';
    let errorOutput = '';

    lpstat.stdout.on('data', (data) => {
      output += data.toString();
    });

    lpstat.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    lpstat.on('close', (code) => {
      if (code === 0) {
        // Parse output like "system default destination: HP_LaserJet_Pro_M404"
        const match = output.match(/system default destination:\s*(.+)/);
        const printer = match ? match[1].trim() : null;
        resolve(printer ? { name: printer } : null);
      } else {
        reject(new Error(`lpstat command failed with code ${code}: ${errorOutput}`));
      }
    });

    lpstat.on('error', (error) => {
      reject(new Error(`Failed to spawn lpstat: ${error.message}`));
    });
  });
}
