require 'slippery'
#require 'devtools/spec_helper'

# Helper to load markdown files under spec/fixtures
#
module FixtureLoader
  # Given its base name, load the Markdown file from spec/fixtures/#{name}.md
  #
  # @param name [String] The short name
  # @return [String]
  # @api private
  #
  def load_fixture(name)
    IO.read(File.expand_path(File.join('../fixtures', name) + '.md', __FILE__))
  end
end

RSpec.configure do |config|
  config.include(FixtureLoader)
end
