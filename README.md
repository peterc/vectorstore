# VectorStore

VectorStore is a simple Ruby library for storing and querying vectors with optional quantization. It provides an easy-to-use interface for adding vectors, computing cosine similarity, finding the closest vectors, and serializing to JSON. It also features quantized storage for improved performance with large datasets.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vectorstore'
```

Then execute:
```bash
bundle install
```

Or install it directly using RubyGems:
```bash
gem install vectorstore
```

## Basic Usage

Here's a simple example to get you started:

```ruby
require 'vectorstore'

# Create a new VectorStore
store = VectorStore.new

# Add some vectors
store.add("vector1", [1.0, 2.0, 3.0])
store.add("vector2", [2.0, 3.0, 4.0])
store.add("vector3", [3.0, 4.0, 5.0])
store.add("vector4", [0.0, 0.0, 0.0])  # Zero vector edge case

# Calculate cosine similarity between two vectors
similarity = store.cosine_similarity([1.0, 2.0, 3.0], [2.0, 3.0, 4.0])
puts "Cosine similarity: #{similarity}"

# Find the closest vectors to a query vector
closest = store.find_closest([2.0, 3.0, 4.0], 2)
puts "Closest vectors: #{closest.inspect}"

# Save the store to disk
store.save("vector_store.json")

# Load the store from disk
loaded_store = VectorStore.new
loaded_store.load("vector_store.json")
```

### Working with Quantized Vectors

VectorStore also supports quantized mode for memory efficient storage. Simply initialise the store with the `quantized: true` option:

```ruby
store = VectorStore.new(quantized: true)
store.add("vectorQ", [1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0])
```

## Features

- **Vector Storage:** Easily add and retrieve vectors with unique keys.
- **Cosine Similarity:** Compute similarities between vectors.
- **Closest Match:** Find the closest vectors to a given query vector.
- **Serialization:** Serialize the vector store to JSON for persistence.
- **Quantization:** Optional 1-bit quantization to reduce memory footprint.
- **Save/Load:** Persist vector store to disk and reload it.

## Running the Tests

This project uses Minitest. To run the tests, simply execute:

```bash
rake test
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
