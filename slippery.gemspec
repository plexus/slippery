# encoding: utf-8

require File.expand_path('../lib/slippery/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'slippery'
  gem.version     = Slippery::VERSION
  gem.authors     = [ 'Arne Brasseur' ]
  gem.email       = [ 'arne@arnebrasseur.net' ]
  gem.description = 'Make presentations with Markdown'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/plexus/slippery'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md LICENSE]

  gem.add_runtime_dependency 'hexp'         , '~> 0.4.6'
  gem.add_runtime_dependency 'kramdown'     , '~> 1.1'
  gem.add_runtime_dependency 'hexp-kramdown', '> 0'
  gem.add_runtime_dependency 'rake'         , '~> 10.1'
  gem.add_runtime_dependency 'listen'       , '~> 3.0'
  gem.add_runtime_dependency 'concord'      , '~> 0.1.4'
  gem.add_runtime_dependency 'asset_packer' , '~> 0.3.2'

  gem.add_development_dependency 'rspec'
  # gem.add_development_dependency 'mutant-rspec'
end
