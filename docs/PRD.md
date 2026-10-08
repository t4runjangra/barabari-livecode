# Barabari LiveCode --- Product Requirements Document

**Version:** 1.0\
**Status:** Development\
**Product:** Barabari LiveCode\
**Type:** Browser-based live coding examination platform\
**Target:** Bootcamps, colleges, universities, and training institutes

------------------------------------------------------------------------

## 1. Product Overview

### 1.1 Vision

Barabari LiveCode is a browser-based platform for conducting live, timed
coding examinations where students write and execute code inside the
browser while instructors can monitor exam progress, submissions, and
suspicious activity in real time.

The platform will eventually support:

-   Algorithmic programming
-   HTML/CSS/JavaScript DOM tasks
-   React applications
-   Full-stack applications
-   Real-time proctoring
-   Automated grading
-   Manual evaluation

### 1.2 MVP Goal

The MVP must allow an instructor to create a coding examination and
allow approximately **50--60 students to simultaneously take it**,
submit solutions, and receive automated results.

The first version will prioritize **reliability and correctness over
feature count**.

------------------------------------------------------------------------

## 2. Problem Statement

Existing coding platforms generally focus on one of two areas:

1.  Algorithmic coding problems with automated judging.
2.  Project-based development environments.

They often do not provide a unified environment for conducting live
educational coding examinations involving:

-   Timed exams
-   Multiple question types
-   Browser-based coding
-   Automated evaluation
-   Real-time candidate status
-   Basic anti-cheating mechanisms
-   Instructor monitoring

Barabari LiveCode aims to combine these capabilities into one platform.

------------------------------------------------------------------------

## 3. Target Users

### 3.1 Student / Candidate

A candidate should be able to:

-   Log in
-   View assigned examinations
-   Start an examination
-   View instructions and questions
-   Write code using an in-browser editor
-   Run code against sample test cases
-   Submit solutions
-   View submission status/results
-   Receive warnings for prohibited actions
-   Complete the examination within the configured time

### 3.2 Instructor / Examiner

An instructor should be able to:

-   Create examinations
-   Create and manage questions
-   Configure test cases
-   Assign exams to candidates/cohorts
-   Set duration
-   Schedule examinations
-   Monitor active candidates
-   View candidate activity
-   View suspicious activity
-   Review submissions
-   Override automated scores when necessary

### 3.3 Administrator

An administrator should be able to:

-   Manage users
-   Manage instructors
-   Manage cohorts
-   Manage organizations
-   Configure platform-level permissions
-   View system-level examination information

Administrator functionality is not required for the first MVP beyond
basic role management.

------------------------------------------------------------------------

## 4. MVP Scope

### Authentication

-   Registration/login
-   Logout
-   Password hashing
-   Authentication sessions/tokens
-   Role-based authorization

Roles:

-   `STUDENT`
-   `INSTRUCTOR`
-   `ADMIN`

### Examination

-   Create examination
-   Configure title/description
-   Configure duration
-   Configure start/end time
-   Assign examination to candidates/cohort
-   Publish/unpublish examination
-   Start examination
-   End examination

### Questions

Initial question type:

-   `PROGRAMMING`

Supported languages:

-   JavaScript
-   Python
-   C++
-   Java

Each programming question will contain:

-   Title
-   Description
-   Constraints
-   Input description
-   Output description
-   Sample input
-   Sample output
-   Time limit
-   Memory limit
-   Starter code
-   Test cases

------------------------------------------------------------------------

## 5. Student Examination Flow

``` text
Login
  ↓
Dashboard
  ↓
Available Examination
  ↓
Exam Instructions
  ↓
Start Examination
  ↓
Exam Environment
  ↓
Select Question
  ↓
Write Code
  ↓
Run Sample Tests
  ↓
Submit
  ↓
Code Execution
  ↓
Evaluation
  ↓
Score / Result
  ↓
Exam Submission
```

The server must remain the source of truth for examination state.

The client must not be trusted for:

-   Remaining time
-   Exam status
-   Submission validity
-   Authorization
-   Score
-   Candidate identity

------------------------------------------------------------------------

## 6. Code Editor

The coding interface will use **Monaco Editor**.

The initial editor should support:

-   Syntax highlighting
-   Autocomplete
-   Line numbers
-   Error indicators
-   Language selection
-   Starter code
-   Reset code
-   Run
-   Submit

Example layout:

``` text
┌───────────────────────────────────────────────┐
│ Exam: JavaScript Assessment       42:31       │
├──────────────┬────────────────────────────────┤
│ Questions    │ Monaco Editor                  │
│              │                                │
│ 1. Arrays    │ const solve = () => {          │
│ 2. Strings   │    ...                         │
│ 3. Objects   │ }                              │
│              │                                │
├──────────────┴────────────────────────────────┤
│ Input / Output / Test Results                 │
└────────────────────────────────────────────────┘
```

------------------------------------------------------------------------

## 7. Code Execution

The MVP will **not implement a custom code execution engine**.

Code execution will initially use an isolated execution service such as
**Judge0**.

Architecture:

``` text
Student
   ↓
API
   ↓
Execution Service
   ↓
Sandboxed Runtime
   ↓
Result
   ↓
API
   ↓
Student
```

The execution system must enforce:

-   Execution timeout
-   Memory limit
-   Restricted execution environment
-   Language restrictions
-   Output limits

### Security Requirement

The API server must never execute arbitrary student code directly.

Bad architecture:

``` text
Express Server → child_process.exec(studentCode)
```

Student code must run outside the API process in an isolated execution
environment.

------------------------------------------------------------------------

## 8. Grading System

Each question will contain hidden test cases.

``` text
Question
 ├── Public test cases
 └── Hidden test cases
```

The student can run public/sample tests.

Hidden tests are executed only during submission.

Example:

``` text
10 test cases
8 passed

Score = 80%
```

The grading engine should record:

-   Compilation status
-   Execution status
-   Passed test cases
-   Failed test cases
-   Execution time
-   Memory usage
-   Score

Possible statuses:

-   `QUEUED`
-   `RUNNING`
-   `ACCEPTED`
-   `WRONG_ANSWER`
-   `TIME_LIMIT_EXCEEDED`
-   `MEMORY_LIMIT_EXCEEDED`
-   `COMPILATION_ERROR`
-   `RUNTIME_ERROR`

------------------------------------------------------------------------

## 9. Examination Timer

The timer must be **server authoritative**.

The client may display:

``` text
42:31
```

but the server determines the actual remaining time.

Example:

``` text
exam_started_at
+
exam_duration
=
exam_deadline
```

If the browser is refreshed:

``` text
Browser
   ↓
GET /exam/:id/attempt
   ↓
Server calculates remaining time
```

The student cannot reset the timer by refreshing the page.

------------------------------------------------------------------------

## 10. Anti-Cheating / Proctoring

The MVP will implement **cheating detection and deterrence**, not claim
to make cheating impossible.

### 10.1 Fullscreen

When the examination begins:

``` text
requestFullscreen()
```

If the student exits fullscreen:

``` text
proctoring_event:
    FULLSCREEN_EXIT
```

### 10.2 Tab Visibility

Use:

``` text
document.visibilityState
```

Detect:

-   `visible`
-   `hidden`

A hidden state creates a proctoring event.

### 10.3 Window Blur

Detect focus changes using:

``` text
window.blur
window.focus
```

These events should be logged but not automatically treated as proof of
cheating.

### 10.4 Warning System

Example:

``` text
Warning limit: 2

Strike 1 → Warning
Strike 2 → Final warning
Strike 3 → Auto-disqualification
```

The instructor should be able to configure this policy.

### 10.5 Clipboard Restrictions

Inside the examination environment:

-   Disable paste
-   Disable copy
-   Disable cut
-   Disable context menu

These are deterrents, not security boundaries.

### 10.6 DevTools

The platform may detect common DevTools-related signals and log
suspicious activity.

It must not pretend that browser JavaScript can completely prevent
DevTools.

------------------------------------------------------------------------

## 11. Proctoring Events

Every suspicious event should be stored.

Example:

``` text
PROCTORING_EVENT

id
attempt_id
type
timestamp
metadata
```

Possible events:

-   `TAB_SWITCH`
-   `WINDOW_BLUR`
-   `FULLSCREEN_EXIT`
-   `COPY_ATTEMPT`
-   `PASTE_ATTEMPT`
-   `CONTEXT_MENU`
-   `DEVTOOLS_SIGNAL`

The instructor dashboard can display:

``` text
Tarun
🟢 Active

Warnings: 1

Latest:
TAB_SWITCH
20:41:32
```

------------------------------------------------------------------------

## 12. Real-Time Communication

WebSockets will be used for genuinely real-time functionality.

Technology:

**Socket.IO**

Potential events:

-   `student:joined`
-   `student:presence`
-   `student:idle`
-   `proctoring:event`
-   `exam:started`
-   `exam:ending`
-   `exam:ended`
-   `submission:created`
-   `submission:running`
-   `submission:completed`

Normal CRUD operations will remain HTTP APIs.

WebSockets will not be used for everything.

------------------------------------------------------------------------

## 13. Instructor Dashboard

The instructor dashboard should provide a candidate grid.

Example:

``` text
┌────────────┬────────────┬────────────┐
│ Tarun      │ Rahul      │ Aman       │
│ 🟢 Active  │ 🟢 Active  │ 🟡 Idle    │
│ 1 warning  │ 0 warnings │ 2 warnings │
├────────────┼────────────┼────────────┤
│ Priya      │ Neha       │ Rohit      │
│ 🔴 Flagged │ 🟢 Active  │ Submitted  │
└────────────┴────────────┴────────────┘
```

Candidate statuses:

-   `ACTIVE`
-   `IDLE`
-   `FLAGGED`
-   `DISQUALIFIED`
-   `SUBMITTED`
-   `OFFLINE`

Instructor can open a candidate to see:

-   Current question
-   Submission status
-   Last activity
-   Proctoring events
-   Warnings
-   Score

------------------------------------------------------------------------

## 14. Database

Primary database:

**PostgreSQL**

ORM:

**Prisma**

Initial core entities:

-   `User`
-   `Organization`
-   `Cohort`
-   `Exam`
-   `ExamQuestion`
-   `Question`
-   `TestCase`
-   `ExamAttempt`
-   `Submission`
-   `ProctoringEvent`

High-level relationship:

``` text
Organization
    │
    ├── Users
    │
    └── Cohorts
          │
          └── Users

Instructor
    │
    └── Exams
          │
          ├── Questions
          │     │
          │     └── TestCases
          │
          └── ExamAttempts
                 │
                 ├── Submissions
                 │
                 └── ProctoringEvents
```

The actual ER model will be designed separately before writing the
Prisma schema.

------------------------------------------------------------------------

## 15. Backend Architecture

``` text
apps/api

src/
├── config/
├── controllers/
├── services/
├── repositories/
├── routes/
├── middleware/
├── validators/
├── websocket/
├── utils/
├── types/
└── server.ts
```

Architecture:

``` text
Route
  ↓
Controller
  ↓
Service
  ↓
Repository
  ↓
Prisma
  ↓
PostgreSQL
```

Business logic should not be dumped directly inside route handlers.

------------------------------------------------------------------------

## 16. Frontend Architecture

``` text
apps/web

src/
├── app/
├── components/
├── features/
│   ├── auth/
│   ├── exams/
│   ├── editor/
│   ├── submissions/
│   └── proctoring/
├── hooks/
├── lib/
├── services/
└── types/
```

The initial project is currently a Next.js application. The repository
structure may evolve into a workspace/monorepo when the backend is
introduced.

Next.js + React + TypeScript will be used.

Monaco will be isolated as an editor feature rather than spreading
editor-specific logic throughout the application.

------------------------------------------------------------------------

## 17. Security Requirements

### Authentication

-   Secure password hashing
-   Authentication sessions/tokens
-   Token expiration
-   Logout/invalidation
-   Role-based authorization

### API Security

-   Input validation with Zod
-   Rate limiting
-   CORS configuration
-   Request authentication
-   Authorization checks
-   Secure HTTP headers

### Database

-   Parameterized queries through Prisma
-   Foreign-key constraints
-   Unique constraints
-   Appropriate indexes

### Code Execution

Student code must run outside the API process.

------------------------------------------------------------------------

## 18. Performance Requirements

Initial target:

**60 simultaneous candidates**

Target behavior:

-   API p95 \< 300 ms for normal requests
-   Real-time event propagation target \< 500 ms under normal load
-   Submission creation succeeds under 60-user load
-   One student's execution workload must not starve other users

These numbers must be validated through load testing rather than treated
as assumptions.

------------------------------------------------------------------------

## 19. MVP Non-Goals

The following are explicitly not part of the MVP:

-   AI cheating detection
-   Webcam proctoring
-   Face recognition
-   Screen recording
-   Custom multi-language Docker judge
-   React sandbox
-   Full-stack MERN sandbox
-   In-browser MongoDB
-   Advanced plagiarism detection
-   Guaranteed secondary-monitor detection
-   Mobile examination support

------------------------------------------------------------------------

## 20. Phase 2 --- Frontend Assessment

Support:

-   HTML
-   CSS
-   JavaScript
-   DOM testing

Example automated assertions:

``` text
#submit exists
#submit has correct text
click event works
DOM changes correctly
```

------------------------------------------------------------------------

## 21. Phase 3 --- React Assessment

Support:

-   React
-   JSX
-   Components
-   Props
-   State
-   Events

Automated tests can verify:

``` text
component renders
state updates
props work
events fire
expected DOM exists
```

------------------------------------------------------------------------

## 22. Phase 4 --- Full-Stack Assessment

Environment:

``` text
React
   │
   ▼
Node / Express
   │
   ▼
Isolated database
```

Each candidate receives an ephemeral isolated environment.

No candidate environment should have unrestricted access to the host
system or internal infrastructure.

------------------------------------------------------------------------

## 23. Development Roadmap

  ------------------------------------------------------------------------
  Phase                                     Duration Deliverable
  --------------------- ---------------------------- ---------------------
  Phase 0                                  2--3 days Architecture, DB
                                                     design, API
                                                     contracts, repository
                                                     setup

  Phase 1                                 Weeks 1--4 Authentication,
                                                     exams, questions,
                                                     Monaco, execution,
                                                     submissions

  Phase 2                                 Weeks 4--5 Proctoring,
                                                     WebSockets,
                                                     instructor dashboard

  Phase 3                                 Weeks 6--7 Load testing,
                                                     security hardening,
                                                     deployment

  Phase 4                                 Weeks 8--9 HTML/CSS/JS DOM
                                                     assessment

  Phase 5                               Weeks 10--11 React/full-stack
                                                     prototype
  ------------------------------------------------------------------------

The schedule may change based on actual development progress.

------------------------------------------------------------------------

## 24. Definition of Done --- MVP

The MVP is considered complete when the following end-to-end flow works:

``` text
Instructor
    ↓
Creates exam
    ↓
Adds questions
    ↓
Adds hidden test cases
    ↓
Publishes exam
    ↓
Assigns candidates
          ↓
Student logs in
    ↓
Starts exam
    ↓
Timer begins
    ↓
Writes code
    ↓
Runs sample tests
    ↓
Submits solution
    ↓
Execution service evaluates code
    ↓
Score generated
    ↓
Submission stored
    ↓
Instructor sees result
    ↓
Instructor sees live candidate status
    ↓
Proctoring events recorded
```

This flow must be tested with multiple concurrent students, not only a
single browser session.

------------------------------------------------------------------------

## 25. Technology Stack

### Frontend

-   Next.js
-   React
-   TypeScript
-   Monaco Editor
-   Tailwind CSS

### Backend

-   Node.js
-   Express
-   TypeScript
-   Prisma
-   Zod
-   Socket.IO

### Database

-   PostgreSQL

### Code Execution

-   Judge0 initially

### Infrastructure

-   Docker
-   Redis when required
-   AWS or equivalent cloud infrastructure

------------------------------------------------------------------------

## 26. Core Engineering Principle

> **The browser is an untrusted client.**

Never trust:

-   Client timer
-   Client score
-   Client role
-   Client submission status
-   Client proctoring state
-   Client authorization

The server decides what is valid.

------------------------------------------------------------------------

## 27. Immediate Next Step

After the repository and PRD are committed, the next engineering
document is:

**Database Design v1**

It will define:

-   Tables
-   Primary keys
-   Foreign keys
-   Relationships
-   Cardinality
-   Constraints
-   Unique indexes
-   Performance indexes
-   Exam-attempt lifecycle
-   Submission lifecycle
-   Data that belongs in PostgreSQL versus Redis

The database design should be completed before implementing the backend
models.
