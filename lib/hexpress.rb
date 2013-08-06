require 'kramdown'
require 'hexp'

# Hexpress namespace module
module Hexpress
  def self.convert(element)
    Hexpress::Converter.new.convert(element)
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

require 'hexpress/version'
require 'hexpress/converter'
require 'hexpress/document'
require 'hexpress/processors/add_impress_js'
require 'hexpress/processors/hr_to_steps'
