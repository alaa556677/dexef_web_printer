import { Router } from 'express';
import * as os from 'os';
import { listPrintersWin, defaultPrinterWin } from '../services/printers-win';
import { listPrintersPosix, defaultPrinterPosix } from '../services/printers-posix';

export const router = Router();

/**
 * @swagger
 * /printers:
 *   get:
 *     summary: List available printers
 *     description: Returns a list of all available printers on the system
 *     tags: [Printers]
 *     responses:
 *       200:
 *         description: List of printers retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   name:
 *                     type: string
 *                     example: "HP LaserJet Pro"
 *                   portName:
 *                     type: string
 *                     example: "USB001"
 *                   ipAddress:
 *                     type: string
 *                     example: "192.168.1.100"
 *                   macAddress:
 *                     type: string
 *                     example: "00:11:22:33:44:55"
 *                   driverName:
 *                     type: string
 *                     example: "HP LaserJet Pro"
 *                   location:
 *                     type: string
 *                     example: "Office"
 *                   comment:
 *                     type: string
 *                     example: "Main office printer"
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
router.get('/', async (_req, res) => {
  try {
    const data = os.platform() === 'win32' 
      ? await listPrintersWin() 
      : await listPrintersPosix();
    res.json(data);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

/**
 * @swagger
 * /printers/default:
 *   get:
 *     summary: Get default printer
 *     description: Returns the system's default printer
 *     tags: [Printers]
 *     responses:
 *       200:
 *         description: Default printer retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               nullable: true
 *               properties:
 *                 name:
 *                   type: string
 *                   example: "HP LaserJet Pro"
 *                 portName:
 *                   type: string
 *                   example: "USB001"
 *                 ipAddress:
 *                   type: string
 *                   example: "192.168.1.100"
 *                 macAddress:
 *                   type: string
 *                   example: "00:11:22:33:44:55"
 *                 driverName:
 *                   type: string
 *                   example: "HP LaserJet Pro"
 *                 location:
 *                   type: string
 *                   example: "Office"
 *                 comment:
 *                   type: string
 *                   example: "Main office printer"
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
router.get('/default', async (_req, res) => {
  try {
    const data = os.platform() === 'win32' 
      ? await defaultPrinterWin() 
      : await defaultPrinterPosix();
    res.json(data ?? null);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});
