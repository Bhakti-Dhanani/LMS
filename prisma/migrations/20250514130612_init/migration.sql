-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'INSTRUCTOR', 'STUDENT');

-- CreateEnum
CREATE TYPE "ModuleType" AS ENUM ('VIDEO', 'TEXT', 'PDF', 'QUIZ', 'ASSIGNMENT');

-- CreateEnum
CREATE TYPE "QuestionType" AS ENUM ('MULTIPLE_CHOICE', 'TRUE_FALSE', 'SHORT_ANSWER', 'ESSAY', 'FILE_UPLOAD');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "emailVerified" TIMESTAMP(3),
    "password" TEXT,
    "image" TEXT,
    "role" "Role" NOT NULL DEFAULT 'STUDENT',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL,
    "sessionToken" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE "Course" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "thumbnail" TEXT,
    "price" DECIMAL(10,2),
    "published" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "creatorId" TEXT NOT NULL,

    CONSTRAINT "Course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Enrollment" (
    "id" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "enrolledAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "Enrollment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Module" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "type" "ModuleType" NOT NULL,
    "content" JSONB,
    "courseId" TEXT NOT NULL,
    "order" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Module_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ModuleProgress" (
    "id" TEXT NOT NULL,
    "moduleId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "completedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ModuleProgress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Assignment" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "dueDate" TIMESTAMP(3),
    "courseId" TEXT NOT NULL,
    "creatorId" TEXT NOT NULL,
    "moduleId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Assignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Submission" (
    "id" TEXT NOT NULL,
    "assignmentId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "fileUrl" TEXT,
    "content" TEXT,
    "grade" DOUBLE PRECISION,
    "feedback" TEXT,
    "submittedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "gradedAt" TIMESTAMP(3),

    CONSTRAINT "Submission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Quiz" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "courseId" TEXT NOT NULL,
    "timeLimit" INTEGER,
    "passingScore" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Quiz_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QuizQuestion" (
    "id" TEXT NOT NULL,
    "quizId" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "type" "QuestionType" NOT NULL,
    "options" JSONB,
    "correctAnswer" TEXT,
    "points" INTEGER NOT NULL DEFAULT 1,
    "order" INTEGER NOT NULL,

    CONSTRAINT "QuizQuestion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QuizAttempt" (
    "id" TEXT NOT NULL,
    "quizId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "score" DOUBLE PRECISION,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "QuizAttempt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QuizAnswer" (
    "id" TEXT NOT NULL,
    "attemptId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "userAnswer" TEXT NOT NULL,
    "isCorrect" BOOLEAN,
    "pointsAwarded" DOUBLE PRECISION,

    CONSTRAINT "QuizAnswer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ForumThread" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "pinned" BOOLEAN NOT NULL DEFAULT false,
    "locked" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ForumThread_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ForumReply" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "threadId" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ForumReply_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Certificate" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "courseId" TEXT NOT NULL,
    "templateId" TEXT,
    "pdf" TEXT,
    "issueDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Certificate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CertificateTemplate" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "template" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CertificateTemplate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CourseInstructor" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");

-- CreateIndex
CREATE UNIQUE INDEX "Enrollment_courseId_userId_key" ON "Enrollment"("courseId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "ModuleProgress_moduleId_userId_key" ON "ModuleProgress"("moduleId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "_CourseInstructor_AB_unique" ON "_CourseInstructor"("A", "B");

-- CreateIndex
CREATE INDEX "_CourseInstructor_B_index" ON "_CourseInstructor"("B");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Course" ADD CONSTRAINT "Course_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Enrollment" ADD CONSTRAINT "Enrollment_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Enrollment" ADD CONSTRAINT "Enrollment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Module" ADD CONSTRAINT "Module_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModuleProgress" ADD CONSTRAINT "ModuleProgress_moduleId_fkey" FOREIGN KEY ("moduleId") REFERENCES "Module"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModuleProgress" ADD CONSTRAINT "ModuleProgress_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Assignment" ADD CONSTRAINT "Assignment_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Assignment" ADD CONSTRAINT "Assignment_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Submission" ADD CONSTRAINT "Submission_assignmentId_fkey" FOREIGN KEY ("assignmentId") REFERENCES "Assignment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Submission" ADD CONSTRAINT "Submission_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Quiz" ADD CONSTRAINT "Quiz_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuizQuestion" ADD CONSTRAINT "QuizQuestion_quizId_fkey" FOREIGN KEY ("quizId") REFERENCES "Quiz"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuizAttempt" ADD CONSTRAINT "QuizAttempt_quizId_fkey" FOREIGN KEY ("quizId") REFERENCES "Quiz"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuizAttempt" ADD CONSTRAINT "QuizAttempt_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuizAnswer" ADD CONSTRAINT "QuizAnswer_attemptId_fkey" FOREIGN KEY ("attemptId") REFERENCES "QuizAttempt"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QuizAnswer" ADD CONSTRAINT "QuizAnswer_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "QuizQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ForumThread" ADD CONSTRAINT "ForumThread_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ForumThread" ADD CONSTRAINT "ForumThread_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ForumReply" ADD CONSTRAINT "ForumReply_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES "ForumThread"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ForumReply" ADD CONSTRAINT "ForumReply_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Certificate" ADD CONSTRAINT "Certificate_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Certificate" ADD CONSTRAINT "Certificate_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Certificate" ADD CONSTRAINT "Certificate_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "CertificateTemplate"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CourseInstructor" ADD CONSTRAINT "_CourseInstructor_A_fkey" FOREIGN KEY ("A") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CourseInstructor" ADD CONSTRAINT "_CourseInstructor_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
