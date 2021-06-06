lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nbppl/version"

Gem::Specification.new do |spec|
  spec.name          = "nbppl"
  spec.version       = Nbppl::VERSION
  spec.authors       = ["Mateusz Juraszek"]
  spec.email         = ["meceo00@gmail.com"]

  spec.summary       = %q{Simple API client for NBP PL exchange rate service}
  spec.description   = %q{Provides simple API client to fetch exchange rates for selected date from http://api.nbp.pl}
  spec.homepage      = "http://github.com/meceo/nbppl"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://github.com/meceo/nbppl"
  spec.metadata["changelog_uri"] = "http://github.com/meceo/nbppl"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
