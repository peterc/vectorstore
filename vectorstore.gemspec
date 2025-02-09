Gem::Specification.new do |spec|
  spec.name          = "vectorstore"
  spec.version       = "0.0.1"
  spec.authors       = ["Peter Cooper"]
  spec.email         = ["git@peterc.org"]
  spec.summary       = "A simple vector storage and querying library"
  spec.description   = "A library for storing and handling vectors with optional quantization."
  spec.homepage      = "http://github.com/peterc/vectorstore"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "~> 5.0"
end
