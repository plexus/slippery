
require 'rspec/core/rake_task'
require 'mutant'

RSpec::Core::RakeTask.new

task :default => :spec

desc "Push gem to rubygems.org"
task :push => :gem do
  sh "git tag v#{Slippery::VERSION}"
  sh "git push --tags"
  sh "gem push pkg/slippery-#{Slippery::VERSION}.gem"
end

task :mutant do
  Mutant::CLI.run(%w[-Ilib -rslippery --use rspec Slippery*])
end
