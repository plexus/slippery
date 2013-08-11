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
          file = Tempfile.new(['hexpress','.dot'])
          file << node.text
          file.close
          Hexp.parse(`dot #{file.path} -Tsvg`)
        end
      end
    end
  end
end
