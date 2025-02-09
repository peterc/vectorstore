require 'vectorstore'

filename = "vector_store.json"
v = VectorStore.new
v.load(filename)

puts v.find_closest_with_openai("apple released a framework for coding server apps", 3)
puts "----"
p v.find_closest_with_key("Kubernetes5", 5)