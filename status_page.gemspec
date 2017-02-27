lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'status_page/version'

Gem::Specification.new do |s|
  s.name        = 'status_page-api'
  s.version     = StatusPage::VERSION
  s.date        = '2016-05-26'
  s.summary     = "Ruby client for StatusPage API"
  s.description = "Ruby client for StatusPage API"
  s.authors     = ["Eric Griffis"]
  s.email       = 'eric.griffis@nyu.edu'

  s.files         = `git ls-files`.split($/)
  s.test_files    = %w[spec/lib/status_page/api/base_spec.rb spec/lib/status_page/api/component_spec.rb spec/lib/status_page/api/component_list_spec.rb]
  s.require_paths = ["lib"]

  s.homepage    = 'https://github.com/NYULibraries/status_page'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.1'
  s.add_dependency 'rest-client', '>= 2.0'
  s.add_dependency 'json', '>= 1.0'

  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'climate_control', '~> 0.1'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'coveralls', '~> 0.8'
end
