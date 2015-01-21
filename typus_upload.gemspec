# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'typus_upload/version'

Gem::Specification.new do |spec|
  spec.name          = "typus_upload"
  spec.version       = TypusUpload::VERSION
  spec.authors       = ["Thomas Koenig", "William Meleyal"]
  spec.email         = "team@wollzelle.com"
  spec.summary       = "Upload module for Typus"
  spec.description   = "Adds support for uploading files to Amazon S3"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "rails", ">= 4.2.0"
  spec.add_dependency "typus"
  spec.add_dependency "react-rails"
  spec.add_dependency "sprockets-coffee-react"
end
