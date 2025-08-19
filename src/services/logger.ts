import * as fs from 'fs-extra';
import * as path from 'path';
import { getDataDir, getConfig } from './config';

export interface PrintJob {
  id: string;
  timestamp: number;
  printer: string;
  filename: string;
  status: 'success' | 'error';
  error?: string;
}

export async function appendJob(job: Omit<PrintJob, 'id'>): Promise<PrintJob> {
  const config = await getConfig();
  const logPath = path.join(getDataDir(), 'logs', 'prints.log');
  
  const jobWithId: PrintJob = {
    ...job,
    id: `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
  };
  
  try {
    // Read existing logs
    let logs: PrintJob[] = [];
    if (await fs.pathExists(logPath)) {
      const content = await fs.readFile(logPath, 'utf-8');
      if (content.trim()) {
        logs = JSON.parse(content);
      }
    }
    
    // Add new job
    logs.push(jobWithId);
    
    // Keep only the last N entries
    if (logs.length > config.logMaxEntries) {
      logs = logs.slice(-config.logMaxEntries);
    }
    
    // Write back to file
    await fs.writeFile(logPath, JSON.stringify(logs, null, 2));
    
    return jobWithId;
  } catch (error) {
    console.error('Error writing to log:', error);
    // Return job even if logging fails
    return jobWithId;
  }
}

export async function getJobs(limit?: number): Promise<PrintJob[]> {
  const config = await getConfig();
  const logPath = path.join(getDataDir(), 'logs', 'prints.log');
  
  try {
    if (!(await fs.pathExists(logPath))) {
      return [];
    }
    
    const content = await fs.readFile(logPath, 'utf-8');
    if (!content.trim()) {
      return [];
    }
    
    const logs: PrintJob[] = JSON.parse(content);
    const maxLimit = limit || config.logMaxEntries;
    
    return logs.slice(-maxLimit).reverse(); // Most recent first
  } catch (error) {
    console.error('Error reading logs:', error);
    return [];
  }
}
