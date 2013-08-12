require 'tempfile'

module Hexpress
  module Processors
    # Turn embedded dot files into embedded SVGs
    class GraphvizDot
      def initialize(selector)
        @selector = selector
      end

      def call(doc)
        doc
          .rewrite(@selector, &create_svg_from_dot)
          .rewrite('polygon[fill=white][stroke=white]') { [] }
      end

      def create_svg_from_dot
        ->(node) do
          dot_to_hexp(node.text).process(copy_width_height(node))
        end
      end

      def dot_to_hexp(dot_source)
        file = Tempfile.new(['hexpress','.dot'])
        file << dot_source
        file.close
        Hexp.parse(`dot #{file.path} -Tsvg`)
      end

      def copy_width_height(node)
        ->(svg) do
          return svg unless node[:width] || node[:height]
          [:width, :height].each do |attr|
            svg = svg.remove_attr(attr)
            svg = svg.attr(attr, node[attr]) if node[attr]
          end
          svg
        end
      end
    end
  end
end
