import config = require("config");
import * as fs from 'fs-extra';
import * as path from 'path';
import * as os from 'os';
import { v4 as uuidv4 } from 'uuid';

export interface AppConfig {
  port: number;
  bind: string;
  sumatraPath: string;
  dataDir: string;
  logMaxEntries: number;
  corsAllow: string;
}

export interface UserConfig {
  apiKey: string;
  defaultPrinter?: string;
}

let userConfig: UserConfig | null = null;

export async function getConfig(): Promise<AppConfig> {
  return config.get('default') as AppConfig;
}

export function getDataDir(): string {
  const cfg = config.get('default') as AppConfig;
  return cfg.dataDir.replace('~', os.homedir());
}

export async function ensureDataDir(): Promise<void> {
  const dataDir = getDataDir();
  await fs.ensureDir(dataDir);
  await fs.ensureDir(path.join(dataDir, 'tmp'));
  await fs.ensureDir(path.join(dataDir, 'logs'));
}

export async function getUserConfig(): Promise<UserConfig | null> {
  if (userConfig) return userConfig;
  
  const configPath = path.join(getDataDir(), 'config.json');
  
  try {
    if (await fs.pathExists(configPath)) {
      userConfig = await fs.readJson(configPath);
    } else {
      // Generate new API key on first run
      userConfig = {
        apiKey: uuidv4(),
        defaultPrinter: undefined
      };
      await fs.writeJson(configPath, userConfig, { spaces: 2 });
      console.log(`Generated new API key: ${userConfig.apiKey}`);
    }
  } catch (error) {
    console.error('Error reading user config:', error);
    // Fallback to generating new config
    userConfig = {
      apiKey: uuidv4(),
      defaultPrinter: undefined
    };
    await fs.writeJson(configPath, userConfig, { spaces: 2 });
  }
  
  return userConfig;
}

export function getApiKey(): string {
  if (!userConfig) {
    throw new Error('Config not initialized. Call getUserConfig() first.');
  }
  return userConfig.apiKey;
}

export function corsRegex(): RegExp {
  const cfg = config.get('default') as AppConfig;
  return new RegExp(cfg.corsAllow);
}

export async function updateUserConfig(updates: Partial<UserConfig>): Promise<void> {
  const currentConfig = await getUserConfig();
  const newConfig = { ...currentConfig, ...updates } as UserConfig;
  
  const configPath = path.join(getDataDir(), 'config.json');
  await fs.writeJson(configPath, newConfig, { spaces: 2 });
  
  userConfig = newConfig;
}
