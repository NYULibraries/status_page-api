lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'status_page/version'

Gem::Specification.new do |s|
  s.name        = 'status_page'
  s.version     = StatusPage::VERSION
  s.date        = '2016-05-26'
  s.summary     = "Ruby client for StatusPage API"
  s.description = "Ruby client for StatusPage API"
  s.authors     = ["Eric Griffis"]
  s.email       = 'eric.griffis@nyu.edu'

  s.files         = `git ls-files`.split($/)
  s.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.homepage    = 'https://github.com/NYULibraries/status_page'
  s.license     = 'MIT'

  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency 'rest-client', '>= 1.0'
end
