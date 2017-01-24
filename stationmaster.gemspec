# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "stationmaster/identity"

Gem::Specification.new do |spec|
  spec.name = Stationmaster::Identity.name
  spec.version = Stationmaster::Identity.version
  spec.platform = Gem::Platform::RUBY
  spec.authors = [""]
  spec.email = ["brandon.high@puppet.com"]
  spec.homepage = ""
  spec.summary = ""
  spec.license = "MIT"

  if File.exist?(Gem.default_key_path) && File.exist?(Gem.default_cert_path)
    spec.signing_key = Gem.default_key_path
    spec.cert_chain = [Gem.default_cert_path]
  end

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "thor_plus", "~> 4.1"
  spec.add_dependency "runcom", "~> 0.3"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "gemsmith", "~> 8.1"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "pry-state", "~> 0.1"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "reek", "~> 4.5"
  spec.add_development_dependency "rubocop", "~> 0.45"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0"

  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.executables << "stationmaster"
  spec.require_paths = ["lib"]
end
