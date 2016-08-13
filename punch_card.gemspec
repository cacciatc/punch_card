# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'punch_card/version'

Gem::Specification.new do |spec|
  spec.name          = 'punch_card'
  spec.version       = PunchCard::VERSION
  spec.authors       = ['Chris Cacciatore']
  spec.email         = ['chris.cacciatore@gmail.com']
  spec.summary       = 'For all those punch cards you have laying around.'
  spec.description   = 'Create punch cards in various formats and save as PNGs.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rubocop'
end
