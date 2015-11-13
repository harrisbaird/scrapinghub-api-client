# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrapinghub/version'

Gem::Specification.new do |spec|
  spec.name          = 'scrapinghub-api-client'
  spec.version       = Scrapinghub::VERSION
  spec.authors       = ['harrisbaird']
  spec.email         = ['mydancake@gmail.com']

  spec.summary       = 'Simple api client for Scrapinghub'
  spec.description   = 'Simple api client for Scrapinghub'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'httparty'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
