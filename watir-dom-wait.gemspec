# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'watir/dom/wait/version'

Gem::Specification.new do |spec|
  spec.name          = "watir-dom-wait"
  spec.version       = Watir::Dom::Wait::VERSION
  spec.authors       = ["Alex Rodionov"]
  spec.email         = %w(p0deje@gmail.com)
  spec.description   = "Watir extension providing with DOM-based waiting"
  spec.summary       = "Watir extension providing with DOM-based waiting"
  spec.homepage      = "https://github.com/p0deje/watir-dom-wait"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "watir-webdriver"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
