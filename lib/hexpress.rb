require 'kramdown'
require 'hexp'

# Hexpress namespace module
module Hexpress
  def self.convert(element)
    type, value, attr, children, options =
      element.type, element.value, element.attr, element.children, element.options
    #attr = attr.merge(element.options)
    case type
    when :root
      H[:html, H[:body, attr, convert_children(children)]]
    when :text
      Hexp::TextNode.new(value)
    when :codespan
      Hexp::TextNode.new(value)
    when :blank
    when :header
      H["h#{options[:level]}".intern, attr, convert_children(children)]
    else
      H[type, attr, convert_children(children)]
    end
  end

  def self.convert_children(children)
    children.map {|ch| self.convert ch}.compact
  end


end

require 'hexpress/version'
