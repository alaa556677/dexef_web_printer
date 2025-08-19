import { Request, Response, NextFunction } from 'express';
import { getApiKey } from './config';

export function apiKeyMiddleware(req: Request, res: Response, next: NextFunction) {
  const key = req.header('X-API-Key');
  if (key && key === getApiKey()) {
    return next();
  }
  return res.status(401).json({ error: 'Unauthorized' });
}
