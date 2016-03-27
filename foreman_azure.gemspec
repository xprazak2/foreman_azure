require File.expand_path('../lib/foreman_azure/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_azure'
  s.version     = ForemanAzure::VERSION
  s.date        = Date.today.to_s
  s.authors     = ['The Foreman Team']
  s.email       = ['TODO: Your email']
  s.homepage    = 'TODO'
  s.summary     = 'Plugin providing Azure Compute resource'
  # also update locale/gemspec.rb
  s.description = 'TODO: Description of ForemanAzure.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
