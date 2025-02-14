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
  (
    'Explain cloud computing.', 
   'Cloud computing is the on-demand availability of computer system resources, especially data storage and computing power, without direct active management by the user.', 
    2, 
    'medium'
  ),
  (
    'What is the significance of LeetCode?', 
    'LeetCode helps software engineers practice coding problems to prepare for technical interviews.', 
    3,
    'easy'
  ),
  (
    'What is the difference between supervised and unsupervised learning?',
    'Supervised learning involves training a model using labeled data, while unsupervised learning uses unlabeled data to find hidden patterns.',
    1,
    'medium'
  ),
  (
    'What are the advantages of using Docker?',
    'Docker allows developers to package applications and their dependencies into containers that can run anywhere, ensuring consistency across different environments.',
    2,
    'medium'
  ),
  (
    'Explain the concept of Big Data.',
    'Big Data refers to the large volume of structured and unstructured data that is difficult to process using traditional data management tools.',
    3,
    'hard'
  ),
  (
    'What is an API and why is it important?',
    'An API (Application Programming Interface) allows different software applications to communicate with each other, enabling integration and data exchange.',
    3,
    'easy'
  ),
  (
    'How does the MapReduce algorithm work?',
    'MapReduce is a programming model that processes large datasets by dividing the task into two stages: "map" to sort and "reduce" to aggregate results.',
    2,
    'hard'
  ),
  (
    'What is the role of a database index?',
    'A database index improves the speed of data retrieval operations by providing a quick lookup method for data, without having to scan the entire table.',
    1,
    'medium'
  ),
  (
    'Explain what a RESTful API is.',
    'A RESTful API follows principles like statelessness, resource-based URLs, and standard HTTP methods (GET, POST, PUT, DELETE) to enable communication between clients and servers.',
    2,
    'easy'
  ),
  (
    'What is an object-oriented programming paradigm?',
    'OOP is a programming paradigm based on the concept of objects, which contain data and methods that operate on the data. It helps in organizing code for reusability and maintainability.',
    1,
    'medium'
  ),
    ('What is the importance of algorithm optimization in machine learning?', 
   'Optimizing algorithms in machine learning helps in reducing time complexity, improving performance, and making the model scalable for larger datasets.', 
    1, 
    'medium'
  ),
  ('How does cloud computing improve data storage efficiency?', 
   'Cloud computing allows for on-demand access to scalable storage resources, reducing infrastructure costs and improving accessibility and efficiency.', 
    2, 
    'easy'
  ),
  ('What is the difference between supervised and unsupervised learning in machine learning?', 
   'Supervised learning uses labeled data to train models, while unsupervised learning discovers hidden patterns in unlabeled data.', 
    3, 
    'medium'
  ),
  ('Explain the concept of data encryption and why it is important in cybersecurity.', 
   'Data encryption is the process of converting data into a code to prevent unauthorized access. It is essential for maintaining privacy and security of sensitive information.', 
    1, 
    'hard'
  ),
  ('What are the key features of a microservices architecture?', 
   'Microservices architecture decomposes applications into small, loosely coupled services, enabling scalability, flexibility, and easier maintenance.', 
    2, 
    'medium'
  ),
  ('How does the process of regression analysis work in statistics?', 
   'Regression analysis involves determining the relationship between a dependent variable and one or more independent variables, often used for prediction.', 
    3, 
    'hard'
  ),
  ('What is the role of load balancing in a distributed system?', 
   'Load balancing distributes network traffic efficiently across multiple servers, ensuring reliability, fault tolerance, and optimal resource utilization.', 
    1, 
    'medium'
  ),
  ('Define polymorphism in object-oriented programming.',
   'Polymorphism allows objects of different classes to be treated as objects of a common superclass, enabling methods to be used interchangeably.', 
    2, 
    'hard'
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
