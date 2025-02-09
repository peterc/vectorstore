#!/usr/bin/env ruby
require 'vector_store'

# Create a vector store instance and add sample vectors.
store = VectorStore.new
store.add("vector1", [1.0, 2.0, 3.0])
store.add("vector2", [2.0, 3.0, 4.0])
store.add("vector3", [3.0, 4.0, 5.0])
store.add("vector4", [0.0, 0.0, 0.0])  # Zero vector edge case

# Calculate results before saving.
similarity_before = store.cosine_similarity([1.0, 2.0, 3.0], [2.0, 3.0, 4.0])
closest_before = store.find_closest([2.0, 3.0, 4.0], 2)
serialized_before = store.serialize

# Save the current state to disk.
filename = "vector_store.json"
store.save(filename)

# Create a new instance and load the saved state.
loaded_store = VectorStore.new
loaded_store.load(filename)

# Calculate results after loading.
similarity_after = loaded_store.cosine_similarity([1.0, 2.0, 3.0], [2.0, 3.0, 4.0])
closest_after = loaded_store.find_closest([2.0, 3.0, 4.0], 2)
serialized_after = loaded_store.serialize

# Output the comparisons.
puts "Cosine similarity before saving: #{similarity_before}"
puts "Cosine similarity after loading: #{similarity_after}"
puts "Closest vectors before saving: #{closest_before.inspect}"
puts "Closest vectors after loading: #{closest_after.inspect}"
puts "Serialization match: #{serialized_before == serialized_after}"
