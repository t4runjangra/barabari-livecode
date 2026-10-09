
-- Add integrity constraints

ALTER TABLE "exams"
ADD CONSTRAINT "exams_duration_seconds_positive"
CHECK ("duration_seconds" > 0);

ALTER TABLE "exams"
ADD CONSTRAINT "exams_valid_schedule"
CHECK ("starts_at" IS NULL OR "ends_at" IS NULL OR "ends_at" > "starts_at");

ALTER TABLE "questions"
ADD CONSTRAINT "questions_time_limit_positive"
CHECK ("time_limit_ms" > 0);

ALTER TABLE "questions"
ADD CONSTRAINT "questions_memory_limit_positive"
CHECK ("memory_limit_mb" IS NULL OR "memory_limit_mb" > 0);

ALTER TABLE "exam_questions"
ADD CONSTRAINT "exam_questions_position_positive"
CHECK ("position" > 0);

ALTER TABLE "exam_questions"
ADD CONSTRAINT "exam_questions_points_nonnegative"
CHECK ("points" >= 0);

ALTER TABLE "test_cases"
ADD CONSTRAINT "test_cases_position_positive"
CHECK ("position" > 0);

ALTER TABLE "test_cases"
ADD CONSTRAINT "test_cases_weight_nonnegative"
CHECK ("weight" >= 0);

ALTER TABLE "execution_results"
ADD CONSTRAINT "execution_results_test_counts_valid"
CHECK (
  ("total_tests" IS NULL OR "total_tests" >= 0)
  AND ("passed_tests" IS NULL OR "passed_tests" >= 0)
  AND (
    "total_tests" IS NULL
    OR "passed_tests" IS NULL
    OR "passed_tests" <= "total_tests"
  )
);

ALTER TABLE "execution_results"
ADD CONSTRAINT "execution_results_execution_time_nonnegative"
CHECK ("execution_time_ms" IS NULL OR "execution_time_ms" >= 0);

ALTER TABLE "execution_results"
ADD CONSTRAINT "execution_results_memory_nonnegative"
CHECK ("memory_used_kb" IS NULL OR "memory_used_kb" >= 0);
