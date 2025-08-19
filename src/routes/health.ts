import { Router } from 'express';
import * as os from 'os';
import * as pkg from '../../package.json';

export const router = Router();

/**
 * @swagger
 * /health:
 *   get:
 *     summary: Health check endpoint
 *     description: Returns the current health status and system information
 *     tags: [Health]
 *     responses:
 *       200:
 *         description: Server is healthy
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: "ok"
 *                 version:
 *                   type: string
 *                   example: "1.0.0"
 *                 os:
 *                   type: string
 *                   example: "win32"
 *                 arch:
 *                   type: string
 *                   example: "x64"
 *                 uptime:
 *                   type: number
 *                   example: 123.45
 *                 memory:
 *                   type: object
 *                   properties:
 *                     rss:
 *                       type: number
 *                     heapTotal:
 *                       type: number
 *                     heapUsed:
 *                       type: number
 *                     external:
 *                       type: number
 */
router.get('/', (_req, res) => {
  res.json({
    status: 'ok',
    version: pkg.version,
    os: os.platform(),
    arch: os.arch(),
    uptime: process.uptime(),
    memory: process.memoryUsage()
  });
});
