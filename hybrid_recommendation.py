import psycopg2
import numpy as np
import pandas
import scikitlearn
from sklearn.feature_extraction.text import TfidfVectorizer
from pgvector.psycopg2 import register_vector
# Tech Stack: 
# Pgvector - https://github.com/pgvector/pgvector-python
# Tfidf - https://www.geeksforgeeks.org/understanding-tf-idf-term-frequency-inverse-document-frequency/


class HybridRecomender:
    # Features used for recommendation:
    # 1. List of companies that user follows (eg: Microsoft, Pinterest)
    # 2. List of interview questions that user liked (eg: TwoSum, How to reverse linked list, What is core affinity)
    # 3. List of interests that user provided (eg: Cloud Computing, ML, Leetcode)

  def __init__(self, db_credentials):
    """Initialize the HybridRecomender class."""
    self.conn = psycopg2.connect(db_credentials)
    # Need to register the vector type in the underlying driver
    register_vector(self.conn)
    self.vectorizer = TfidfVectorizer(stop_words="english")


  def database_setup(self):
    """Set up the database with its tables and indeces"""
    with self.conn.cursor() as cursor:
      cursor.execute("CREATE EXTENSION IF NOT EXISTS vector;")

      cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
          user_id SERIAL PRIMARY KEY, 
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
          embedding VECTOR(1536)
        );
        """)
      

  def create_user_profile(self, user_id):
    """Create a user profile according to the features we have defined."""
    with self.conn.cursor() as cursor:
      # 1. Fetch companies that user follows
      cursor.execute("""
        SELECT company_name FROM user_company_following 
        WHERE user_id = %s;
      """, (user_id,))
      following_companies = [row[0] for row in cursor.fetchall()]

      # 2. Fetch interview questions that user liked
      cursor.execute("""
        SELECT question FROM user_liked_questions 
        WHERE user_id = %s;
      """, (user_id,))
      liked_questions = [row[0] for row in cursor.fetchall()]

      # 3. Fetch interests that user provided
      cursor.execute("""
        SELECT interest FROM user_interests 
        WHERE user_id = %s;
      """, (user_id,))

      # Append the features on top of each other into a single text
      profile_text = ''.join([
          ' '.join(following_companies),
          ' '.join([q[0] for q in liked_questions]),  # question texts
          ' '.join([q[1] for q in liked_questions]),  # company names
          ' '.join([' '.join(q[2]) for q in liked_questions]),  # topics
          ' '.join(interests)
      ])
      return profile_text

  
  def create_vector_embeddings_for_questions(self):
    """Create vector embeddings for all the questions in the db."""
    with self.conn.cursor() as cursor:
      cursor.execute("SELECT question_id, question_content, company_name, topics FROM questions;")
      questions = cursor.fetchall()

      # Create tfidf vector embeddings on the questions
      question_texts = [f"{q[1]} {q[2]} {' '.join(q[3])}" for q in questions]
      tfidf_vector_embeddings = self.vectorizer.fit_transform(question_texts)

      # store all of these embeddings
      for i, q in enumerate(questions):
        question_id = q[0]
        # tfidf_vector_embeddings returns a 2d matrix. We only need the first one, as we only passed 1 document (question_texts) to the vectorizer
        vector = tfidf_vector_embeddings[i].toarray()[0]

        cursor.execute("""
          UPDATE questions 
          SET vector = %s
          WHERE question_id = %s;
        """, vector, question_id)
      self.conn.commit()


def get_recommendations(self, user_id, number_of_recommendations=5):
  """Recommend interview questions for a user!"""
  profile_text = self.prepare_user_profile(user_id)
  profile_vector = self.vectorizer.transform([profile_text])

  # Use K-nearest-neighbour and cosine similarity for similarity search
  with self.conn.cursor() as cursor:
    cursor.execute("""
      SELECT question_id, question_text, company_name, topics, 1 - (embedding <=> %s) AS cosine_similarity
      FROM questions
      WHERE id NOT IN (
        SELECT question_id FROM user_liked_questions WHERE user_id = %s
      )
      ORDER BY cosine_similarity DESC
      LIMIT %s;
    """, (profile_vector, user_id, number_of_recommendations))
    recommendations = cursor.fetchall()

  return [{
      'question_id': recommendation[0],
      'question_text': recommendation[1],
      'company_name': recommendation[2],
      'topics': recommendation[3],
      'cosine_similarity': recommendation[4]
  } for recommendation in recommendations]
