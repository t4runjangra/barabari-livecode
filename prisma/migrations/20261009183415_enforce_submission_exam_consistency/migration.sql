/*
  Warnings:

  - Added the required column `exam_id` to the `submissions` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "submissions" DROP CONSTRAINT "submissions_attempt_id_fkey";

-- DropForeignKey
ALTER TABLE "submissions" DROP CONSTRAINT "submissions_exam_question_id_fkey";

-- AlterTable
ALTER TABLE "submissions" ADD COLUMN     "exam_id" UUID NOT NULL;

-- AddForeignKey
ALTER TABLE "submissions" ADD CONSTRAINT "submissions_attempt_id_exam_id_fkey" FOREIGN KEY ("attempt_id", "exam_id") REFERENCES "exam_attempts"("id", "exam_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submissions" ADD CONSTRAINT "submissions_exam_question_id_exam_id_fkey" FOREIGN KEY ("exam_question_id", "exam_id") REFERENCES "exam_questions"("id", "exam_id") ON DELETE RESTRICT ON UPDATE CASCADE;
