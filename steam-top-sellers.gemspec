# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.authors       = ["Mitul Mistry"]
  spec.email         = ["MitulMistryArt@gmail.com"]
  spec.description   = "CLI application that allows you to automatically retrieve top sellers and get more detailed info on each game"
  spec.summary       = "Top selling games on Steam"
  spec.homepage      = "https://github.com/MitulMistry/"

  spec.files         = `git ls-files`.split($\)
  spec.executables   = ["steam-top-sellers"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.name          = "steam-top-sellers"
  spec.require_paths = ["lib", "lib/steam_top_sellers"]
  spec.version       = 1.0
  spec.license       = "MIT"

  spec.add_dependency "nokogiri"
  spec.add_dependency "json"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
