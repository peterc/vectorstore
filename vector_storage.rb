require 'json'
require 'base64'
class VectorStore
  def initialize(quantized: false)
    # Internal store mapping primary key to vector (array of numbers)
    @vectors = {}
    @quantized = quantized
  end

  # Add a vector with the given primary key. Overwrites any existing vector.
  def add(key, vector)
    if @quantized
      @vectors[key] = quantize(vector)
    else
      @vectors[key] = vector
    end
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
    if @quantized
      vec1 = vec1.is_a?(String) ? vec1 : quantize(vec1)
      vec2 = vec2.is_a?(String) ? vec2 : quantize(vec2)
      return cosine_similarity_quantized(vec1, vec2)
    end
    if vec1.is_a?(String) && vec2.is_a?(String)
      return cosine_similarity_quantized(vec1, vec2)
    end
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
    if @quantized
      query_vector = quantize(query_vector)
    end
    similarities = @vectors.map do |key, vector|
      similarity = cosine_similarity(query_vector, vector)
      [key, similarity]
    end
    similarities.sort_by { |_, sim| -sim }.first(k)
  end

  # Compute cosine similarity for quantized vectors (bit strings).
  def cosine_similarity_quantized(str1, str2)
    dot = 0
    total_ones_str1 = 0
    total_ones_str2 = 0
    str1.each_byte.with_index do |byte1, index|
      byte2 = str2.getbyte(index)
      dot += (byte1 & byte2).to_s(2).count("1")
      total_ones_str1 += byte1.to_s(2).count("1")
      total_ones_str2 += byte2.to_s(2).count("1")
    end
    return 0.0 if total_ones_str1 == 0 || total_ones_str2 == 0
    sim = dot.to_f / (Math.sqrt(total_ones_str1) * Math.sqrt(total_ones_str2))
    sim = 1.0 if (1.0 - sim).abs < 1e-6
    sim
  end

  # Convert an array of floats to a 1-bit quantized bit string.
  def quantize(vector)
    bits = vector.map { |x| x >= 0 ? 1 : 0 }
    bytes = []
    bits.each_slice(8) do |slice|
      byte = slice.join.to_i(2)
      bytes << byte.chr
    end
    bytes.join
  end

  # Serialize the internal vector store to a JSON string.
  def serialize
    if @quantized
      encoded = {}
      @vectors.each do |k, v|
        encoded[k] = Base64.strict_encode64(v)
      end
      JSON.dump(encoded)
    else
      JSON.dump(@vectors)
    end
  end

  # Deserialize a JSON string and update the internal store.
  def deserialize(json_string)
    data = JSON.parse(json_string)
    if @quantized
      decoded = {}
      data.each do |k, v|
        decoded[k] = Base64.decode64(v)
      end
      @vectors = decoded
    else
      @vectors = data
    end
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
