# -*- coding: utf-8 -*-
# Main class that does the conversion from Markdown/Kramdown to Hexp.
# Subclass this for custom behavior.
#
# See https://github.com/3/blob/master/lib/kramdown/element.rb for a list of
# types
#
class Hexpress::Converter
  private_attr_accessor :type, :value, :attr, :children, :options
  undef_method :p

  # Convert a Kramdown syntax tree into Hexp.
  #
  # @example
  #   markdown = "# Hello!\n\nChunky *bacon*!\n"
  #   document = Kramdown::Document.new(markdown)
  #   hexp = converter.convert(document.root)
  #
  # @param el [Kramdown::Element] The root element to convert
  # @return [Hexp::Node]
  # @api public
  #
  def convert(el)
    #Kernel.p el ; exit
    @type, @value, @attr, @children, @options =
      el.type, el.value, el.attr, el.children, el.options
    send(type)
  end

  # Process a Kramdown :root type element
  #
  # @return [Hexp::Node]
  # @api semipublic
  #
  def root
    H[:html, [H[:head], tag!(:body)]]
  end

  # Process a Kramdown :header type element
  #
  # @return [Hexp::Node]
  # @api semipublic
  #
  def header
    tag! "h#{options[:level]}".intern
  end

  # Process a Kramdown :codeblock type element
  #
  # @return [Hexp::Node]
  # @api semipublic
  #
  def codeblock
    H[:pre, attr, H[:code, value]]
  end

  def smart_quote
    {
      :lsquo => '‘',
      :rsquo => '’',
      :ldquo => '“',
      :rdquo => '”',
    }[value]
  end

  def html_element
    H[value.to_sym, attr, convert_children]
  end

  def entity
    value.char
  end

  # Create a Hexp::Node from the current element
  #
  # Helper for when you want to turn the Kramdown element straight into a
  # Hexp::Node with the same attributes, and a one-to-one mapping of the child
  # elements.
  #
  # @param tag [Symbol] The HTML tag to generate
  # @return [Hexp::Node]
  # @api semipublic
  #
  def tag!(tag)
    H[tag, attr, convert_children]
  end

  [:text, :codespan, :blank, :raw].each do |sym|
    define_method sym do
      Hexp::TextNode.new(value)
    end
  end

  [:p, :blockquote, :ul, :li, :ol, :dl, :dt, :dd, :em, :strong, :img, :a, :hr, :br].each do |sym|
    define_method sym do
      tag! type
    end
  end

  # Convert the children of the Kramdown element to Hexps
  #
  # In other words, recurse down the tree. This will pass each
  # child element into the converter.
  #
  # @return [Array<Hexp::Node>]
  # @api private
  #
  def convert_children
    children.map {|ch| convert ch }.compact
  end
end
