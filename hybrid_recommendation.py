import psycopg2
import numpy as np
import pandas
import sklearn
from sklearn.feature_extraction.text import TfidfVectorizer
from pgvector.psycopg2 import register_vector
import logging
# Tech Stack: 
# Pgvector - https://github.com/pgvector/pgvector-python
# Tfidf - https://www.geeksforgeeks.org/understanding-tf-idf-term-frequency-inverse-document-frequency/

logging.basicConfig(
    level=logging.DEBUG,  # Log all levels: DEBUG and above
    format="%(asctime)s [%(levelname)s] %(message)s",  # Log format
)

LOGGER = logging.getLogger(__name__)

class HybridRecommender:
    # Features used for recommendation:
    # 1. List of companies that user follows (eg: Microsoft, Pinterest)
    # 2. List of interview questions that user liked (eg: TwoSum, How to reverse linked list, What is core affinity)
    # 3. List of interests that user provided (eg: Cloud Computing, ML, Leetcode)

  def __init__(self, connection_dict):
    """Initialize the HybridRecomender class."""
    self.conn = psycopg2.connect(**connection_dict)
    LOGGER.info("Connected to database")

    # Need to register the vector type in the underlying driver
    register_vector(self.conn)
    self.vectorizer = TfidfVectorizer(
          stop_words="english",
          max_features=1024
        )


  def prepare_user_profile(self, user_id):
    """Create a user profile according to the features we have defined."""
    with self.conn.cursor() as cursor:
      # 1. Fetch companies that user follows
      cursor.execute("""
        SELECT DISTINCT c.company_name 
        FROM user_company_following u
        JOIN companies c ON u.company_id = c.company_id
        WHERE user_id = %s;
      """, (user_id,))
      following_companies = [row[0] for row in cursor.fetchall()]

      # 2. Fetch interview questions that user liked
      cursor.execute("""
        SELECT q.question_text
        FROM user_liked_questions u
        JOIN questions q ON u.question_id = q.question_id
        WHERE user_id = %s;
      """, (user_id,))
      liked_questions = [row[0] for row in cursor.fetchall()]

      # 3. Fetch topic interests that user provided
      cursor.execute("""
        SELECT topics FROM users
        WHERE user_id = %s;
      """, (user_id,))
      topic_of_interests = [row[0] for row in cursor.fetchall()]

      # Append the features on top of each other into a single text
      profile_text = ''.join([
          ' '.join(following_companies),   # companies user is following
          ' '.join([q[0] for q in liked_questions]),  # question texts from liked posts
          ' '.join([q[1] for q in liked_questions]),  # company names from liked posts
          ' '.join(topic_of_interests)   # user list of interests
      ])
      
      profile_text = ' '.join([
          'following: ' + ' '.join(following_companies),
          'liked_questions: ' + ' '.join([q[0] for q in liked_questions]),
          'liked_companies: ' + ' '.join([q[1] for q in liked_questions]),
          'interests: ' + ' '.join(topic_of_interests)
      ])
      return profile_text


  def create_vector_embeddings_for_questions(self):
    """Create vector embeddings for all the questions in the db."""
    with self.conn.cursor() as cursor:
      cursor.execute("""
        SELECT DISTINCT u.question_id, u.question_text, c.company_name, u.topics
        FROM questions u
        JOIN companies c ON u.company_id = c.company_id;
        """)
      questions = cursor.fetchall()

      # Create tfidf vector embeddings on the questions
      question_texts = [
          f"question: {q[1]} company: {q[2]} topics: {' '.join(q[3])}" 
          for q in questions
      ]

      LOGGER.info(question_texts)

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
        """, (vector, question_id))

      self.conn.commit()


  def get_recommendations(self, user_id, number_of_recommendations=5):
    """Recommend interview questions for a user."""
    profile_text = self.prepare_user_profile(user_id)
    profile_vector = self.vectorizer.transform([profile_text]).toarray()[0]

    LOGGER.info("profile_vector", profile_vector)

    # Use K-nearest-neighbour and cosine similarity for similarity search
    with self.conn.cursor() as cursor:
      cursor.execute("""
        SELECT question_id, question_text, answer_text, topics, 1 - (vector <=> %s) AS cosine_similarity
        FROM questions
        WHERE question_id NOT IN (
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


def main():
  connection_dict = {
      "dbname": "mydatabase",
      "user": "postgres",
      "host": "localhost",
      "port": "5432"
  }

  Recommender = HybridRecommender(connection_dict)

  Recommender.create_vector_embeddings_for_questions()
  LOGGER.info("created embeddings for questions")

  recommendations = Recommender.get_recommendations(user_id=1)
  
  # Loop through each recommendation and log them in one line
  LOGGER.info("Top 5 recommendations:")
  for recommendation in recommendations:
    LOGGER.info(
        "Question ID: %d | Question Text: %s | Company Name: %s | Topics: %s | Cosine Similarity: %.4f",
        recommendation['question_id'],
        recommendation['question_text'],
        recommendation['company_name'],
        recommendation['topics'],
        recommendation['cosine_similarity']
    )


if __name__ == "__main__":
  main()
