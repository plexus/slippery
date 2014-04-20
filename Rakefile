
require 'rspec/core/rake_task'
require 'mutant'

RSpec::Core::RakeTask.new

task :default => :spec

task :mutant do
  Mutant::CLI.run(%w[-Ilib -rslippery --use rspec Slippery*])
end

require 'rubygems/package_task'
spec = Gem::Specification.load(File.expand_path('../slippery.gemspec', __FILE__))
gem = Gem::PackageTask.new(spec)
gem.define

desc "Push gem to rubygems.org"
task :push => :gem do
  sh "git tag v#{Slippery::VERSION}"
  sh "git push --tags"
  sh "gem push pkg/slippery-#{Slippery::VERSION}.gem"
end
