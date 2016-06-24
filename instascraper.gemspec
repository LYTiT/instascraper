# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'instascraper/version'

Gem::Specification.new do |spec|
  spec.name          = "instascraper"
  spec.version       = Instascraper::VERSION
  spec.authors       = ["llukyanov"]
  spec.email         = ["leonid@lytit.com"]

  spec.summary       = "Instagram web scrapper."
  spec.description   = "Workaround the Instagram API."
  spec.homepage      = "https://www.lytit.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  

  spec.add_runtime_dependency "capybara", "~> 2.7.1", ">= 2.7.1"
  #spec.add_runtime_dependency "phantomjs", "~> 2.1.1.0", ">= 2.1.1.0"
  spec.add_runtime_dependency "poltergeist", "~> 1.9.0", ">= 1.9.0"
end
