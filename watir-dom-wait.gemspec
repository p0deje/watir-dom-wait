lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "watir-dom-wait"
  spec.version       = "0.3.2"
  spec.authors       = ["Alex Rodionov"]
  spec.email         = %w(p0deje@gmail.com)
  spec.description   = "Watir extension which provides with method to check for DOM changes."
  spec.summary       = "Watir extension which provides with method to check for DOM changes."
  spec.homepage      = "https://github.com/p0deje/watir-dom-wait"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "watir", ">= 6.4"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
