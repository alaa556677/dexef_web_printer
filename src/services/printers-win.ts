import { spawn } from 'child_process';

export interface PrinterInfo {
  name: string;
  portName?: string;
  ipAddress?: string;
  macAddress?: string;
  driverName?: string;
  location?: string;
  comment?: string;
}

export async function listPrintersWin(): Promise<PrinterInfo[]> {
  return new Promise((resolve, reject) => {
    const powershell = spawn('powershell', [
      '-NoProfile',
      '-Command',
      `Get-Printer | Select-Object Name, PortName, DriverName, Location, Comment | ConvertTo-Json`
    ], {
      windowsHide: true
    });

    let output = '';
    let errorOutput = '';

    powershell.stdout.on('data', (data) => {
      output += data.toString();
    });

    powershell.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    powershell.on('close', (code) => {
      if (code === 0) {
        try {
          const printers = JSON.parse(output.trim());
          const result = Array.isArray(printers) ? printers : [printers];
          resolve(result.map(printer => ({
            name: printer.Name || printer.name || '',
            portName: printer.PortName || printer.portName || undefined,
            ipAddress: printer.ipAddress || undefined,
            macAddress: printer.macAddress || undefined,
            driverName: printer.DriverName || printer.driverName || undefined,
            location: printer.Location || printer.location || undefined,
            comment: printer.Comment || printer.comment || undefined
          })));
        } catch (parseError) {
          // Fallback to simple name list if JSON parsing fails
          const printers = output
            .trim()
            .split('\n')
            .map(name => name.trim())
            .filter(name => name.length > 0)
            .map(name => ({ name }));
          resolve(printers);
        }
      } else {
        reject(new Error(`PowerShell command failed with code ${code}: ${errorOutput}`));
      }
    });

    powershell.on('error', (error) => {
      reject(new Error(`Failed to spawn PowerShell: ${error.message}`));
    });
  });
}

export async function defaultPrinterWin(): Promise<PrinterInfo | null> {
  return new Promise((resolve, reject) => {
    const powershell = spawn('powershell', [
      '-NoProfile',
      '-Command',
      `$defaultPrinter = Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Default=$true"
       if ($defaultPrinter) {
         $port = Get-PrinterPort -Name $defaultPrinter.PortName -ErrorAction SilentlyContinue
         $result = @{
           name = $defaultPrinter.Name
           portName = $defaultPrinter.PortName
           driverName = $defaultPrinter.DriverName
           location = $defaultPrinter.Location
           comment = $defaultPrinter.Comment
         }
         
         if ($port) {
           if ($port.PrinterHostAddress) {
             $result.ipAddress = $port.PrinterHostAddress
           }
           if ($port.PrinterHostAddress -and $port.PrinterHostAddress -match '^\\d+\\.\\d+\\.\\d+\\.\\d+$') {
             try {
               $arp = arp -a | Where-Object { $_ -match $port.PrinterHostAddress }
               if ($arp -match '([0-9a-fA-F]{2}[:-]){5}([0-9a-fA-F]{2})') {
                 $result.macAddress = ($matches[0] -replace '-', ':').ToUpper()
               }
             } catch { }
           }
         }
         
         [PSCustomObject]$result | ConvertTo-Json -Depth 3
       }`
    ], {
      windowsHide: true
    });

    let output = '';
    let errorOutput = '';

    powershell.stdout.on('data', (data) => {
      output += data.toString();
    });

    powershell.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    powershell.on('close', (code) => {
      if (code === 0) {
        try {
          const printer = JSON.parse(output.trim());
          if (printer && printer.name) {
            resolve({
              name: printer.Name || printer.name || '',
              portName: printer.PortName || printer.portName || undefined,
              ipAddress: printer.ipAddress || undefined,
              macAddress: printer.macAddress || undefined,
              driverName: printer.DriverName || printer.driverName || undefined,
              location: printer.Location || printer.location || undefined,
              comment: printer.Comment || printer.comment || undefined
            });
          } else {
            resolve(null);
          }
        } catch (parseError) {
          // Fallback to simple name if JSON parsing fails
          const printer = output.trim();
          resolve(printer ? { name: printer } : null);
        }
      } else {
        reject(new Error(`PowerShell command failed with code ${code}: ${errorOutput}`));
      }
    });

    powershell.on('error', (error) => {
      reject(new Error(`Failed to spawn PowerShell: ${error.message}`));
    });
  });
}
