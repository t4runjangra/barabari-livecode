import "dotenv/config";
import { prisma } from "./lib/prisma";

async function main() {
  try {
    await prisma.$queryRaw`SELECT 1`;
    console.log("PostgreSQL connected successfully through Prisma!");
  } catch (error) {
    console.error("Database connection failed:", error);
    process.exitCode = 1;
  } finally {
    await prisma.$disconnect();
  }
}

main();