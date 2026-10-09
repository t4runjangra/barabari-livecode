import { Router } from "express";
import { prisma } from "../lib/prisma";

const router = Router();

router.get("/", async (_req, res) => {
    try {
        await prisma.$queryRaw`SELECT 1`;

        res.status(200).json({
            status: "ok",
            message: "Barabari LiveCode API is running",
        });
    } catch (_error) {
        res.status(503).json({
            status: "error",
            database: "disconnected",
        });
    }
});

export default router;