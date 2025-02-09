require 'json'
class VectorStore
  def initialize
    # Internal store mapping primary key to vector (array of numbers)
    @vectors = {}
  end

  # Add a vector with the given primary key. Overwrites any existing vector.
  def add(key, vector)
    @vectors[key] = vector
  end

  # Remove a vector by its primary key.
  def remove(key)
    @vectors.delete(key)
  end

  # Retrieve a vector by its primary key.
  def get(key)
    @vectors[key]
  end

  # Compute the cosine similarity between two vectors.
  def cosine_similarity(vec1, vec2)
    # Ensure vectors are of the same size
    return 0.0 if vec1.size != vec2.size

    dot_product = vec1.zip(vec2).map { |a, b| a * b }.sum
    norm1 = Math.sqrt(vec1.map { |x| x * x }.sum)
    norm2 = Math.sqrt(vec2.map { |x| x * x }.sum)
    return 0.0 if norm1 == 0 || norm2 == 0

    dot_product / (norm1 * norm2)
  end

  # Find the top k closest vectors to the query vector using cosine similarity.
  # Returns an array of [key, similarity] pairs.
  def find_closest(query_vector, k=1)
    similarities = @vectors.map do |key, vector|
      similarity = cosine_similarity(query_vector, vector)
      [key, similarity]
    end
    similarities.sort_by { |_, sim| -sim }.first(k)
  end

  # Serialize the internal vector store to a JSON string.
  def serialize
    JSON.dump(@vectors)
  end

  # Deserialize a JSON string and update the internal store.
  def deserialize(json_string)
    @vectors = JSON.parse(json_string)
  end

  # Save the internal vector store to a file.
  def save(filename)
    File.write(filename, serialize)
  end

  # Load the internal vector store from a file.
  def load(filename)
    json_string = File.read(filename)
    deserialize(json_string)
  end
end
