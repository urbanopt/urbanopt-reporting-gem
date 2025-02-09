lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'urbanopt/reporting/version'

Gem::Specification.new do |spec|
  spec.name          = 'urbanopt-reporting'
  spec.version       = URBANopt::Reporting::VERSION
  spec.authors       = ['Rawad El Kontar', 'Dan Macumber']
  spec.email         = ['rawad.elkontar@nrel.gov']

  spec.summary       = 'Library to report URBANopt results'
  spec.description   = 'Library include scenario default reporting measure and scenario defaults reports schema and classes'
  spec.homepage      = 'https://github.com/urbanopt'
  spec.licenses      = 'Nonstandard'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|lib.measures.*tests|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  # We support exactly Ruby v3.2.2 because os-extension requires bundler==2.4.10 and that requires Ruby 3.2.2: https://stdgems.org/bundler/
  # It would be nice to be able to use newer patches of Ruby 3.2, which would require os-extension to relax its dependency on bundler.
  spec.required_ruby_version = '3.2.2'

  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'simplecov', '0.22.0'
  spec.add_development_dependency 'simplecov-lcov', '0.8.0'

  spec.add_runtime_dependency 'json_pure', '~> 2.7'
  spec.add_runtime_dependency 'json-schema', '~> 4.3.1'
  spec.add_dependency 'openstudio-extension', '~> 0.8.3'
end
