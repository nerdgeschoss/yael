# frozen_string_literal: true

require_relative "lib/yael/version"

Gem::Specification.new do |spec|
  spec.name          = "yael"
  spec.version       = Yael::VERSION
  spec.authors       = ["Jens Ravens"]
  spec.email         = ["jens@nerdgeschoss.de"]

  spec.summary       = "Event based Rails with ActiveJob"
  spec.description   = "Yael is Yet Another Event Library based on top of ActiveJob. It helps you dispatching events asynchronously in your code base and react to them just like routing in Rails."
  spec.homepage      = "https://nerdgeschoss.de"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nerdgeschoss/yael"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
