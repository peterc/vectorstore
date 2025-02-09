require 'vectorstore'

v = VectorStore.new(quantized: true)

test_strings = [
  # Technical Facts
  "The quicksort algorithm has an average time complexity of O(n log n).",
  "Rust guarantees memory safety without a garbage collector.",
  "Git uses SHA-1 hashes to track content integrity in repositories.",
  "Lambda functions in Python are anonymous, single-expression functions.",
  "Docker containers share the host OS kernel but remain isolated.",
  "Kubernetes automates the deployment, scaling, and operation of application containers.",
  "PostgreSQL supports JSONB for efficient semi-structured data storage.",
  "A blockchain is a decentralized ledger that records transactions in immutable blocks.",
  "The Linux kernel manages system processes, memory, and hardware interactions.",
  "Regular expressions enable pattern matching in text processing applications.",

  # Cooking Facts
  "Caramelization occurs when sugar is heated above 320°F (160°C).",
  "Salt enhances flavor by suppressing bitterness and amplifying sweetness.",
  "Sous-vide cooking involves vacuum-sealing food and cooking it in a precisely controlled water bath.",
  "The Maillard reaction creates complex flavors by browning proteins and sugars.",
  "Gluten development gives bread its elasticity and chewy texture.",
  "Olive oil has a lower smoke point than vegetable oil, making it less ideal for frying.",
  "Fermentation is responsible for the tangy flavor of sourdough bread and kimchi.",
  "Umami, the fifth taste, is found in foods like mushrooms, soy sauce, and Parmesan cheese.",
  "Egg yolks act as emulsifiers in sauces like mayonnaise and hollandaise.",
  "Baking soda is an alkaline leavening agent, while baking powder contains both acid and base."
]

i = 0
test_strings.each do |thing|
  v.add_with_openai("#{thing[/^([A-Za-z]+)/,1]}#{i}", thing)
  i += 1
end

filename = "vector_store.json"
v.save(filename)