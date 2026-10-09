import "dotenv/config";
import express from "express";
import cors from "cors";
import healthRouter from "./routes/health.routes";

const app = express();

app.use(
    cors({
        origin: process.env.CORS_ORIGIN || "http://localhost:3000",
        credentials: true,
    }),
);

app.use(express.json());

app.use("/health", healthRouter);

export default app;