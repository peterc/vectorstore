# VectorStore

A pure Ruby library for storing and querying vectors with optional 1 bit quantization. It provides an easy-to-use interface for adding vectors, computing cosine similarity, finding the closest vectors, and serializing to JSON. It also features a 1 bit quantization mode for **significantly** reduced memory requirements, suitable for high dimensional vectors.

> [!NOTE]  
> VectorStore is a simple, pure Ruby approach. For anything beyond local, low level volumes and experiments, consider [sqlite-vec](https://github.com/asg017/sqlite-vec), using Postgres with pgvector, or full-fat platforms like [Pinecone.](https://www.pinecone.io/)

## Features

- **Vector Storage:** Easily add and retrieve vectors with unique keys.
- **Closest Match:** Find the closest vectors to a given query vector using cosine similarity.
- **Serialization:** Serialize the vector store to JSON for persistence.
- **Quantization:** Optional 1-bit quantization to reduce memory footprint (significantly).
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

### Using OpenAI for vector embedding text

VectorStore can integrate with OpenAI's API to generate embeddings for text inputs and queries. To use this feature with quantization (STRONGLY RECOMMENDED), initialize the store with quantized mode.

> [!TIP]
> Let me iterate again, using quantization with OpenAI embeddings is strongly recommended with VectorStore as the normal way we currently store the vectors is very space inefficient, particularly when serializing to disk.

Example:

```ruby
store = VectorStore.new(quantized: true)

store.add_with_openai("example", "Your sample text to embed")

# You can query with text and have the text embedded automatically
store.find_closest_with_openai("Your query text", 3)

# You can also query by the key of the vector
store.find_closest_with_key("example")
```

Supporting other embedding systems in a nice way would be good for the future, but I like OpenAI's embedding mechanism and it's cheap, so this is just step one. You can see example scripts in `examples/example_openai_*.rb` for a broader demo.

> [!NOTE]  
> For now, your API key is assumed to be in the `OPENAI_API_KEY` environment variable. The `text-embedding-3-small` model is also used by default but this can be overridden in calls by using the `embedding_model` keyword argument on `find_closest_with_openai` and `add_with_openai` calls.

### Working with quantized vectors

VectorStore supports 1 bit vector quantization so that vectors can be stored in a bitfield (using a ASCII-encoded string with 8 bits per character for portability) for a significant memory use reduction. The cost is accuracy, especially on low dimension vectors – high dimension vectors such as used for text embeddings from OpenAI's API (see above) will fare a LOT better. Initialize the store with the `quantized: true` option:

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
