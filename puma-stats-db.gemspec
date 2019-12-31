Gem::Specification.new do |spec|
  spec.name     = "puma-stats-db"
  spec.version  = "0.0.1"
  spec.author   = "Matteo Alessani"
  spec.email    = "alessani@gmail.com"

  spec.summary  = "Puma integration with worker and db stats"
  spec.homepage = "https://www.extendi.it"
  spec.license  = "MIT"

  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE"]

  spec.add_runtime_dependency "puma", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end