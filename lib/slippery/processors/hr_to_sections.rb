module Slippery
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

      def initialize(wrapper = H[:section], selector = 'body', options = {})
        @selector, @wrapper, @anchor = selector, wrapper, options.fetch(:anchor, true)
      end

      def call(doc)
        doc.replace(@selector) { |element| hr_to_section(element) }
      end

      def hr_to_section(element)
        sections = [@wrapper]
        page = 1
        element.children.each do |child|
          if child.tag == :hr
            last_section = @wrapper.merge_attrs(child)
            if @anchor
              last_section = last_section.merge_attrs(name: "#{page}")
              page += 1
            end
            sections << last_section
          else
            sections[-1] = sections.last << child
          end
        end
        element.set_children(sections)
      end

    end
  end
end
