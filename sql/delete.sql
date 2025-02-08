-- Drop all indices
DROP INDEX IF EXISTS idx_user_company_following;
DROP INDEX IF EXISTS idx_user_liked_uqestions;

-- Drop all feature tables
DROP TABLE IF EXISTS user_liked_questions CASCADE;
DROP TABLE IF EXISTS user_company_following CASCADE;

-- Drop all tables
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS companies CASCADE;

-- Drop constants
DROP TYPE IF EXISTS topic CASCADE;
