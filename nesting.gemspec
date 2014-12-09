Gem::Specification.new do |spec|
  spec.name          = "nesting"
  spec.version       = File.read('VERSION')
  spec.date          = Time.now.strftime('%Y-%m-%d')
  spec.authors       = ["Kyrylo Silin"]
  spec.email         = ["silin@kyrylo.org"]
  spec.summary       = %q{Detects nesting of a module/class}
  spec.homepage      = "https://github.com/kyrylo/nesting"
  spec.license       = "zlib"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
