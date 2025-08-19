import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import multer from 'multer';
import swaggerUi from 'swagger-ui-express';
import { router as printersRouter } from './routes/printers';
import { router as printRouter } from './routes/print';
import { router as healthRouter } from './routes/health';
import { router as jobsRouter } from './routes/jobs';
import { getConfig, ensureDataDir, getUserConfig, corsRegex } from './services/config';
import { specs } from './swagger';

export async function startServer() {
  const app = express();
  const cfg = await getConfig();
  
  // Ensure data directory exists and get user config
  await ensureDataDir();
  await getUserConfig();

  // Security middleware
  app.use(helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        styleSrc: ["'self'", "'unsafe-inline'", "https://unpkg.com", "https://fonts.googleapis.com"],
        scriptSrc: ["'self'", "'unsafe-inline'", "https://unpkg.com", "https://cdn.jsdelivr.net"],
        imgSrc: ["'self'", "data:", "https:", "blob:"],
        connectSrc: ["'self'", "http://127.0.0.1:5123", "http://localhost:5123", "https:"],
        fontSrc: ["'self'", "https:", "data:", "https://fonts.gstatic.com"],
        objectSrc: ["'none'"],
        mediaSrc: ["'self'", "data:", "blob:"],
        frameSrc: ["'none'"],
        workerSrc: ["'self'", "blob:"],
        childSrc: ["'self'", "blob:"],
      },
    },
  }));
  app.use(express.json({ limit: '20mb' }));
  
  // CORS configuration
  app.use(cors({
    origin: (origin, cb) => {
      const re = corsRegex();
      if (!origin || re.test(origin)) {
        cb(null, true);
      } else {
        cb(new Error('CORS blocked'));
      }
    },
    credentials: true
  }));

  // Swagger UI - No auth required
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs, {
    customCss: '.swagger-ui .topbar { display: none }',
    customSiteTitle: 'WebPrint Agent API',
    customfavIcon: '/favicon.ico',
    swaggerOptions: {
      docExpansion: 'list',
      filter: true,
      showRequestHeaders: true,
      tryItOutEnabled: true,
    }
  }));
  
  // Routes
  app.use('/health', healthRouter); // No auth required
  app.use('/printers', printersRouter); // No auth required
  app.use('/print', printRouter); // No auth required
  app.use('/jobs', jobsRouter); // No auth required

  // Error handling middleware
  app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error('Error:', err);
    console.error('Request URL:', req.url);
    console.error('Request Method:', req.method);
    
    if (err instanceof multer.MulterError) {
      if (err.code === 'LIMIT_FILE_SIZE') {
        return res.status(400).json({ error: 'File too large. Maximum size is 100MB.' });
      }
    }
    
    // Handle specific printer-related errors
    if (err.message && err.message.includes('printer_default')) {
      console.error('Printer error detected:', err.message);
      return res.status(500).json({ error: 'Printer configuration error. Please check printer setup.' });
    }
    
    res.status(500).json({ error: err.message || 'Internal server error' });
  });

  // Start server
  app.listen(cfg.port, cfg.bind, async () => {
    console.log(`WebPrint Agent listening on http://${cfg.bind}:${cfg.port}`);
    const newLocal = await getUserConfig();
    if (newLocal == null) {
      console.log('No user config found, please run `npm run validate` to generate a new API key');
      return;
    }
    console.log(`API key: ${(newLocal).apiKey}`);
    console.log(`Data directory: ${cfg.dataDir.replace('~', require('os').homedir())}`);
  });
}
