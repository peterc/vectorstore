# VectorStore

A pure Ruby library for storing and querying vectors with optional 1 bit quantization. It provides an easy-to-use interface for adding vectors, computing cosine similarity, finding the closest vectors, and serializing to JSON. It also features quantized storage for reduced memory requirements (roughly a 34x reduction!)

## Features

- **Vector Storage:** Easily add and retrieve vectors with unique keys.
- **Closest Match:** Find the closest vectors to a given query vector using cosine similarity.
- **Serialization:** Serialize the vector store to JSON for persistence.
- **Quantization:** Optional 1-bit quantization to reduce memory footprint.
- **Save/Load:** Persist vector store to disk and reload it.

## Installation

In a `Gemfile`:

```ruby
gem 'vectorstore'
```

Or directly:
```bash
gem install vectorstore
```

## Basic Usage

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

VectorStore also supports 1 bit vector quantization so that vectors can be stored in a bitfield (using a string) for a significant memory use reduction at the cost of accuracy, particularly on low dimension vectors (high dimension vectors such as used for text embeddings will do a LOT better). Initialize the store with the `quantized: true` option:

```ruby
store = VectorStore.new(quantized: true)
store.add("vectorQ", [1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0])
```

## Running the Tests

This project uses Minitest. To run the tests:

```bash
rake test
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
