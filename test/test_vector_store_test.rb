require 'minitest/autorun'
require_relative '../vector_storage'

class TestVectorStore < Minitest::Test
  def setup
    @store = VectorStore.new
    @store.add("vector1", [1.0, 2.0, 3.0])
    @store.add("vector2", [2.0, 3.0, 4.0])
    @store.add("vector3", [3.0, 4.0, 5.0])
    @store.add("vector4", [0.0, 0.0, 0.0])
  end

  def test_cosine_similarity
    similarity = @store.cosine_similarity([1.0, 2.0, 3.0], [2.0, 3.0, 4.0])
    expected = 20.0/(Math.sqrt(14.0)*Math.sqrt(29.0))
    assert_in_delta expected, similarity, 1e-6
  end

  def test_find_closest
    query_vector = [2.0, 3.0, 4.0]
    closest = @store.find_closest(query_vector, 2)
    key1, sim1 = closest[0]
    key2, sim2 = closest[1]
    # Expect vector2 to be the closest match (with similarity of 1.0)
    assert_equal "vector2", key1
    assert_in_delta 1.0, sim1, 1e-6
  end

  def test_save_and_load
    serialized_before = @store.serialize
    filename = "test_vector_store.json"
    @store.save(filename)

    loaded_store = VectorStore.new
    loaded_store.load(filename)
    serialized_after = loaded_store.serialize

    assert_equal serialized_before, serialized_after

    # Clean up created file.
    File.delete(filename) if File.exist?(filename)
  end
end
