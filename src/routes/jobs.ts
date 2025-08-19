import { Router } from 'express';
import { getJobs } from '../services/logger';

export const router = Router();

/**
 * @swagger
 * /jobs:
 *   get:
 *     summary: Get print jobs history
 *     description: Returns a list of recent print jobs with their status
 *     tags: [Jobs]
 *     parameters:
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *         description: Maximum number of jobs to return (optional)
 *         example: 10
 *     responses:
 *       200:
 *         description: Print jobs retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                     example: "job-12345"
 *                   timestamp:
 *                     type: number
 *                     example: 1640995200000
 *                   printer:
 *                     type: string
 *                     example: "HP LaserJet Pro"
 *                   filename:
 *                     type: string
 *                     example: "document.pdf"
 *                   status:
 *                     type: string
 *                     enum: [success, error]
 *                     example: "success"
 *                   error:
 *                     type: string
 *                     nullable: true
 *                     example: null
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
router.get('/', async (req, res) => {
  try {
    const limit = req.query.limit ? parseInt(req.query.limit as string) : undefined;
    const jobs = await getJobs(limit);
    res.json(jobs);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});
