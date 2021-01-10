# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.authors       = ["Mitul Mistry"]
  spec.email         = ["MitulMistryDev@gmail.com"]
  spec.description   = "CLI application that allows you to automatically retrieve top sellers and get more detailed info on each game"
  spec.summary       = "Top selling games on Steam"
  spec.homepage      = "https://github.com/MitulMistry/steam-top-sellers-cli-gem"

  spec.files         = `git ls-files`.split($\)
  spec.executables   = ["steam-top-sellers"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.name          = "steam-top-sellers"
  spec.require_paths = ["lib", "lib/steam_top_sellers"]
  spec.version       = "1.0.1"
  spec.license       = "MIT"

  spec.add_dependency "nokogiri", "~> 1.11", ">= 1.11.1"
  spec.add_dependency "json", "~> 2.5", ">= 2.5.1"
  spec.add_development_dependency "bundler", "~> 2.1", ">= 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0", ">= 13.0.3"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "pry", "~> 0.13.1"
end
