#!/usr/bin/env ruby
require 'vector_store'

# Create an instance of VectorStore
store = VectorStore.new

# Add sample vectors (primary key => vector array)
store.add("vector1", [1.0, 2.0, 3.0])
store.add("vector2", [2.0, 3.0, 4.0])
store.add("vector3", [3.0, 4.0, 5.0])
store.add("vector4", [0.0, 0.0, 0.0])  # Zero vector edge case

# Retrieve and display a vector by key
puts "Vector for 'vector1': #{store.get("vector1")}"

# Calculate and display cosine similarity between two vectors
similarity = store.cosine_similarity([1.0, 2.0, 3.0], [2.0, 3.0, 4.0])
puts "Cosine similarity between [1,2,3] and [2,3,4]: #{similarity}"

# Find the closest vectors to a query vector
query_vector = [2.0, 3.0, 4.0]
closest = store.find_closest(query_vector, 2)
puts "Closest vectors to [2,3,4]:"
closest.each do |key, sim|
  puts "Key: #{key}, Similarity: #{sim}"
end
