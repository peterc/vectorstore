require 'vectorstore'
require 'tempfile'
require 'base64'

# Create a new quantized VectorStore
store = VectorStore.new(quantized: true)

# Define a sample vector that will be quantized.
vector = [1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0]

# Add the vector with identifier "vectorQ"
store.add("vectorQ", vector)

# Save the vector store to a temporary file
file = File.new('vector_store_quantized', 'w')
filename = file.path
store.save(filename)

# Create a new VectorStore and load the saved quantized data
loaded_store = VectorStore.new(quantized: true)
loaded_store.load(filename)

# Fetch the vector from loaded store and output its Base64 encoded version
stored_vector = loaded_store.get("vectorQ")
encoded_vector = Base64.strict_encode64(stored_vector)
puts "Encoded vector from loaded store: #{encoded_vector}"

file.close
#file.unlink if File.exist?(filename)
