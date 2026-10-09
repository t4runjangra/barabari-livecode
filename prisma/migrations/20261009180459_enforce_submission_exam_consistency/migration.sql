/*
  Warnings:

  - A unique constraint covering the columns `[id,exam_id]` on the table `exam_attempts` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,exam_id]` on the table `exam_questions` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "exam_attempts_id_exam_id_key" ON "exam_attempts"("id", "exam_id");

-- CreateIndex
CREATE UNIQUE INDEX "exam_questions_id_exam_id_key" ON "exam_questions"("id", "exam_id");
