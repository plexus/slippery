module Hexpress
  module Processors
    # Take a flat list of elements, and wrap elements between <hr> lines into
    # a sections.
    #
    # @example
    #   HrToSections.new('body', H[:section]).call(doc)
    #
    class HrToSections
      def self.call(doc)
        self.new.call(doc)
      end

      def initialize(wrapper = H[:section], selector = 'body')
        @selector, @wrapper = selector, wrapper
      end

      def call(doc)
        doc.replace(@selector) { |element| hr_to_section(element) }
      end

      def hr_to_section(element)
        sections = [@wrapper]
        element.children.each do |child|
          if child.tag == :hr
            sections << @wrapper.merge_attrs(child)
          else
            sections[-1] = sections.last << child
          end
        end
        element.set_children(sections)
      end

    end
  end
end
