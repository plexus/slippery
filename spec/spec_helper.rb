require 'hexpress'
require 'devtools/spec_helper'

module FixtureLoader
  def load_fixture(name)
    IO.read(File.expand_path(File.join('../fixtures', name) + '.md', __FILE__))
  end
end

RSpec.configure do |config|
  config.include(FixtureLoader)
end
