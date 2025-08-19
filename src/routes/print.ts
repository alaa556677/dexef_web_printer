import { Router } from 'express';
import multer from 'multer';
import * as path from 'path';
import * as fs from 'fs-extra';
import * as os from 'os';
import { getDataDir } from '../services/config';
import { printWin } from '../services/print-win';
import { printPosix } from '../services/print-posix';
import { appendJob } from '../services/logger';

export const router = Router();

const upload = multer({ 
  limits: { fileSize: 100 * 1024 * 1024 }, // 100MB
  fileFilter: (req, file, cb) => {
    if (file.mimetype === 'application/pdf') {
      cb(null, true);
    } else {
      cb(new Error('Only PDF files are allowed'));
    }
  }
});

/**
 * @swagger
 * /print:
 *   post:
 *     summary: Print a PDF file
 *     description: Upload and print a PDF file to the specified or default printer
 *     tags: [Print]
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - file
 *             properties:
 *               file:
 *                 type: string
 *                 format: binary
 *                 description: PDF file to print (max 100MB)
 *               printer:
 *                 type: string
 *                 description: Name of the printer to use (optional, uses default if not specified)
 *     responses:
 *       200:
 *         description: File printed successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "printed"
 *                 jobId:
 *                   type: string
 *                   example: "job-12345"
 *                 printer:
 *                   type: string
 *                   example: "HP LaserJet Pro"
 *                 filename:
 *                   type: string
 *                   example: "document.pdf"
 *       400:
 *         description: Bad request - file missing or invalid
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "file is required"
 *       500:
 *         description: Server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 */
router.post('/', upload.single('file'), async (req, res) => {
  try {
    const printer = (req.body.printer || '').trim();
    const file = req.file;
    
    if (!file) {
      return res.status(400).json({ error: 'file is required' });
    }

    // Create temp directory and save file
    const dir = path.join(getDataDir(), 'tmp');
    await fs.ensureDir(dir);
    const pdfPath = path.join(dir, `${Date.now()}-${file.originalname}`);
    await fs.writeFile(pdfPath, file.buffer);

    try {
      // Print based on platform
      const platform = os.platform();
      if (platform === 'win32') {
        await printWin(pdfPath, printer);
      } else {
        await printPosix(pdfPath, printer);
      }

      // Log successful job
      const job = await appendJob({
        timestamp: Date.now(),
        printer: printer || 'default',
        filename: file.originalname,
        status: 'success'
      });

      res.json({
        status: 'printed',
        jobId: job.id,
        printer: job.printer,
        filename: job.filename
      });

      // Clean up temp file after a delay
      setTimeout(async () => {
        try {
          await fs.remove(pdfPath);
        } catch (error) {
          console.error('Failed to clean up temp file:', error);
        }
      }, 5000);

    } catch (printError) {
      // Log failed job
      await appendJob({
        timestamp: Date.now(),
        printer: printer || 'default',
        filename: file.originalname,
        status: 'error',
        error: printError instanceof Error ? printError.message : 'Unknown error'
      });

      // Clean up temp file
      try {
        await fs.remove(pdfPath);
      } catch (error) {
        console.error('Failed to clean up temp file:', error);
      }

      throw printError;
    }

  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});
