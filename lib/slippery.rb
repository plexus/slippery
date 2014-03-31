require 'base64'
require 'pathname'
require 'open-uri'
require 'forwardable'

require 'kramdown'
require 'hexp'
require 'concord'

# Slippery namespace module
module Slippery
  ROOT = Pathname(__FILE__).dirname.parent

  def self.convert(element)
    Slippery::Converter.new.convert(element)
  end
end

# Core extension
class Class
  unless defined?(private_attr_accessor)
    # Like attr_accessor, but only available inside the class
    #
    # @param args [Array<Symbol>] The attributes to define
    # @api private
    #
    def private_attr_accessor(*args)
      attr_accessor(*args)
      private(*args)
      private(*args.map {|method| "#{method}=".intern })
    end
  end
end

require 'slippery/version'
require 'slippery/converter'
require 'slippery/document'
require 'slippery/assets'
require 'slippery/presentation'

require 'slippery/processor_helpers'

require 'slippery/processors/add_google_font'
require 'slippery/processors/graphviz_dot'
require 'slippery/processors/hr_to_sections'
require 'slippery/processors/bundle_assets'
require 'slippery/processors/add_highlight'

require 'slippery/processors/impress_js/add_impress_js'
require 'slippery/processors/impress_js/auto_offsets'

require 'slippery/processors/reveal_js/add_reveal_js'

require 'slippery/rake_tasks'
