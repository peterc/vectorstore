Gem::Specification.new do |spec|
  spec.name          = "vectorstore"
  spec.version       = "0.1.0"
  spec.authors       = ["Your Name"]
  spec.email         = ["you@example.com"]
  spec.summary       = "A simple vector storage library"
  spec.description   = "A library for storing and handling vectors with optional quantization."
  spec.homepage      = "http://example.com/vectorstore"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "~> 5.0"
end
