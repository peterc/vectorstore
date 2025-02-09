require 'minitest/autorun'
$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))
require 'vectorstore'
require 'tempfile'

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
    _key2, _sim2 = closest[1]
    # Expect vector2 to be the closest match (with similarity of 1.0)
    assert_equal "vector2", key1
    assert_in_delta 1.0, sim1, 1e-6
  end

  def test_save_and_load
    serialized_before = @store.serialize
    file = Tempfile.new('vector_store')
    filename = file.path
    @store.save(filename)

    loaded_store = VectorStore.new
    loaded_store.load(filename)
    serialized_after = loaded_store.serialize

    assert_equal serialized_before, serialized_after

    file.close
    file.unlink if File.exist?(filename)
  end

  def test_quantized_cosine_similarity
    store = VectorStore.new(quantized: true)
    vector_a = [1.0, -2.0, 3.0, -4.0, 5.0, -6.0, 7.0, -8.0]
    vector_b = [-1.0, 2.0, -3.0, 4.0, -5.0, 6.0, -7.0, 8.0]
    store.add("a", vector_a)
    store.add("b", vector_b)
    # With 1-bit quantization: vector_a becomes [1,0,1,0,1,0,1,0] and vector_b becomes [0,1,0,1,0,1,0,1]
    # Thus, their cosine similarity should be 0.0.
    similarity = store.cosine_similarity(vector_a, vector_b)
    assert_equal 0.0, similarity

    vector_c = [1.0, 0.0, 1.0, -1.0]
    vector_d = [0.0, 1.0, 0.0, -2.0]
    store.add("c", vector_c)
    store.add("d", vector_d)
    # With 1-bit quantization: vector_c becomes [1,1,1,0] and vector_d becomes [1,1,1,0]
    # Thus, their cosine similarity should be 1.0.
    similarity = store.cosine_similarity(vector_c, vector_d)
    assert_equal 1.0, similarity
  end

  def test_quantized_save_and_load
    store = VectorStore.new(quantized: true)
    vector = [1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0]
    store.add("vectorQ", vector)
    serialized_before = store.serialize

    file = Tempfile.new('vector_store_quantized')
    filename = file.path
    store.save(filename)

    loaded_store = VectorStore.new(quantized: true)
    loaded_store.load(filename)
    serialized_after = loaded_store.serialize

    assert_equal serialized_before, serialized_after

    file.close
    file.unlink if File.exist?(filename)
  end
end
