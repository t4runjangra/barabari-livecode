-- CreateEnum
CREATE TYPE "user_role" AS ENUM ('STUDENT', 'INSTRUCTOR', 'ADMIN');

-- CreateEnum
CREATE TYPE "exam_status" AS ENUM ('DRAFT', 'PUBLISHED', 'CANCELLED', 'ENDED');

-- CreateEnum
CREATE TYPE "test_case_visibility" AS ENUM ('PUBLIC', 'HIDDEN');

-- CreateEnum
CREATE TYPE "attempt_status" AS ENUM ('NOT_STARTED', 'IN_PROGRESS', 'SUBMITTED', 'AUTO_SUBMITTED', 'DISQUALIFIED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "execution_status" AS ENUM ('QUEUED', 'RUNNING', 'ACCEPTED', 'WRONG_ANSWER', 'TIME_LIMIT_EXCEEDED', 'MEMORY_LIMIT_EXCEEDED', 'COMPILATION_ERROR', 'RUNTIME_ERROR', 'INTERNAL_ERROR');

-- CreateEnum
CREATE TYPE "proctoring_event_type" AS ENUM ('TAB_HIDDEN', 'FULLSCREEN_EXIT', 'WINDOW_BLUR', 'COPY_ATTEMPT', 'PASTE_ATTEMPT', 'CONTEXT_MENU');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "role" "user_role" NOT NULL DEFAULT 'STUDENT',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exams" (
    "id" UUID NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "duration_seconds" INTEGER NOT NULL,
    "starts_at" TIMESTAMPTZ(6),
    "ends_at" TIMESTAMPTZ(6),
    "status" "exam_status" NOT NULL DEFAULT 'DRAFT',
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "exams_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "questions" (
    "id" UUID NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT NOT NULL,
    "constraints" TEXT,
    "input_description" TEXT,
    "output_description" TEXT,
    "starter_code" TEXT,
    "default_language" VARCHAR(50),
    "time_limit_ms" INTEGER NOT NULL,
    "memory_limit_mb" INTEGER,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exam_questions" (
    "id" UUID NOT NULL,
    "exam_id" UUID NOT NULL,
    "question_id" UUID NOT NULL,
    "position" INTEGER NOT NULL,
    "points" DECIMAL(10,2) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exam_questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "test_cases" (
    "id" UUID NOT NULL,
    "question_id" UUID NOT NULL,
    "input_data" TEXT NOT NULL,
    "expected_output" TEXT NOT NULL,
    "visibility" "test_case_visibility" NOT NULL,
    "weight" DECIMAL(10,2) NOT NULL DEFAULT 1,
    "position" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "test_cases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exam_attempts" (
    "id" UUID NOT NULL,
    "exam_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "started_at" TIMESTAMPTZ(6),
    "expires_at" TIMESTAMPTZ(6),
    "submitted_at" TIMESTAMPTZ(6),
    "status" "attempt_status" NOT NULL DEFAULT 'NOT_STARTED',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "exam_attempts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "submissions" (
    "id" UUID NOT NULL,
    "attempt_id" UUID NOT NULL,
    "exam_question_id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "language" VARCHAR(50) NOT NULL,
    "submitted_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "submissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "execution_results" (
    "id" UUID NOT NULL,
    "submission_id" UUID NOT NULL,
    "status" "execution_status" NOT NULL,
    "score" DECIMAL(10,2),
    "total_tests" INTEGER,
    "passed_tests" INTEGER,
    "execution_time_ms" INTEGER,
    "memory_used_kb" BIGINT,
    "judge_reference" VARCHAR(255),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMPTZ(6),

    CONSTRAINT "execution_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "proctoring_events" (
    "id" UUID NOT NULL,
    "attempt_id" UUID NOT NULL,
    "type" "proctoring_event_type" NOT NULL,
    "occurred_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "metadata" JSONB,

    CONSTRAINT "proctoring_events_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "exams_created_by_status_idx" ON "exams"("created_by", "status");

-- CreateIndex
CREATE UNIQUE INDEX "exam_questions_exam_id_question_id_key" ON "exam_questions"("exam_id", "question_id");

-- CreateIndex
CREATE UNIQUE INDEX "exam_questions_exam_id_position_key" ON "exam_questions"("exam_id", "position");

-- CreateIndex
CREATE UNIQUE INDEX "test_cases_question_id_position_key" ON "test_cases"("question_id", "position");

-- CreateIndex
CREATE INDEX "exam_attempts_exam_id_status_idx" ON "exam_attempts"("exam_id", "status");

-- CreateIndex
CREATE INDEX "exam_attempts_student_id_created_at_idx" ON "exam_attempts"("student_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "exam_attempts_exam_id_student_id_key" ON "exam_attempts"("exam_id", "student_id");

-- CreateIndex
CREATE INDEX "submissions_attempt_id_exam_question_id_submitted_at_idx" ON "submissions"("attempt_id", "exam_question_id", "submitted_at");

-- CreateIndex
CREATE INDEX "execution_results_submission_id_created_at_idx" ON "execution_results"("submission_id", "created_at");

-- CreateIndex
CREATE INDEX "proctoring_events_attempt_id_occurred_at_idx" ON "proctoring_events"("attempt_id", "occurred_at");

-- AddForeignKey
ALTER TABLE "exams" ADD CONSTRAINT "exams_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "questions" ADD CONSTRAINT "questions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exam_questions" ADD CONSTRAINT "exam_questions_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "exams"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exam_questions" ADD CONSTRAINT "exam_questions_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "questions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "test_cases" ADD CONSTRAINT "test_cases_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "questions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exam_attempts" ADD CONSTRAINT "exam_attempts_exam_id_fkey" FOREIGN KEY ("exam_id") REFERENCES "exams"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exam_attempts" ADD CONSTRAINT "exam_attempts_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submissions" ADD CONSTRAINT "submissions_attempt_id_fkey" FOREIGN KEY ("attempt_id") REFERENCES "exam_attempts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submissions" ADD CONSTRAINT "submissions_exam_question_id_fkey" FOREIGN KEY ("exam_question_id") REFERENCES "exam_questions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "execution_results" ADD CONSTRAINT "execution_results_submission_id_fkey" FOREIGN KEY ("submission_id") REFERENCES "submissions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "proctoring_events" ADD CONSTRAINT "proctoring_events_attempt_id_fkey" FOREIGN KEY ("attempt_id") REFERENCES "exam_attempts"("id") ON DELETE CASCADE ON UPDATE CASCADE;
