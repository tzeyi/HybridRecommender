-- Companies table
INSERT INTO companies (company_name) VALUES 
  ('Microsoft'),
  ('Apple'),
  ('NVIDIA');

-- Users table
INSERT INTO users (user_name, email) VALUES
  ('Alice', 'alice@example.com'),
  ('Bob', 'bob@example.com'),
  ('Charlie', 'charlie@example.com');

-- Questions table
INSERT INTO questions (question_text, answer_text, company_id, difficulty_level) VALUES
  (
    'What is machine learning?', 
    'Machine learning is a field of artificial intelligence that uses statistical techniques to give computer systems the ability to learn from data.', 
    1, 
    'easy'
  ),
  ('Explain cloud computing.', 
   'Cloud computing is the on-demand availability of computer system resources, especially data storage and computing power, without direct active management by the user.', 
    2, 
    'medium'),
  (
    'What is the significance of LeetCode?', 
    'LeetCode helps software engineers practice coding problems to prepare for technical interviews.', 
    3,
    'easy'
  );

-- RECOMMENDATION SYSTEM'S FEATURES
-- User_company_following table
INSERT INTO user_company_following (user_id, company_id) VALUES
  (1, 1),  -- Alice follows Microsoft
  (1, 2),  -- Alice follows Apple
  (2, 2),  -- Bob follows Apple
  (3, 3);  -- Charlie follows NVIDIA

-- User_liked_questions table
INSERT INTO user_liked_questions (user_id, question_id) VALUES
  (1, 1),  -- Alice likes the first question
  (1, 2),  -- Alice likes the second question
  (2, 2),  -- Bob likes the second question
  (3, 3);  -- Charlie likes the third question
