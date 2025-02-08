-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- CONSTANTS:
-- Topics enum
CREATE TYPE topic as ENUM (
    'Cloud Computing',
    'Machine Learning',
    'LeetCode',
    'Web Design',
    'Networking'
);

-- Companies table
CREATE TABLE IF NOT EXISTS companies (
    company_id SERIAL PRIMARY KEY,
    company_name VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Questions table with vector storage
CREATE TABLE IF NOT EXISTS questions (
    question_id SERIAL PRIMARY KEY,
    question_text TEXT NOT NULL,
    answer_text TEXT NOT NULL,
    company_id INTEGER REFERENCES companies(company_id),
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('easy', 'medium', 'hard')),
    vector vector(1024) DEFAULT NULL,  -- Todo: CRON Job to update this periodically
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RECOMMENDATION SYSTEM'S FEATURES
-- User company following (many-to-many relationship)
CREATE TABLE IF NOT EXISTS user_company_following (
    user_id INTEGER REFERENCES users(user_id),
    company_id INTEGER REFERENCES companies(company_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, company_id)
);

-- User liked questions (many-to-many relationship)
CREATE TABLE IF NOT EXISTS user_liked_questions (
    user_id INTEGER REFERENCES users(user_id),
    question_id INTEGER REFERENCES questions(question_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, question_id)
);

-- INDICES
CREATE INDEX idx_user_company_following ON user_company_following(user_id);
CREATE INDEX idx_user_liked_questions ON user_liked_questions(user_id);
