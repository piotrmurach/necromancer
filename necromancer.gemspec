require_relative "lib/necromancer/version"

Gem::Specification.new do |spec|
  spec.name          = "necromancer"
  spec.version       = Necromancer::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = %q{Conversion from one object type to another with a bit of black magic.}
  spec.description   = %q{Conversion from one object type to another with a bit of black magic.}
  spec.homepage      = "https://github.com/piotrmurach/necromancer"
  spec.license       = "MIT"
  if spec.respond_to?(:metadata=)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["changelog_uri"] = "https://github.com/piotrmurach/necromancer/blob/master/CHANGELOG.md"
    spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/necromancer"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/piotrmurach/necromancer"
  end
  spec.files         = Dir["lib/**/*", "README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.extra_rdoc_files = ["README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
