module Hexpress
  module Processors
    class HrToSteps
      def self.call(doc)
        self.new.call(doc)
      end

      def initialize(offset_x = 1000, offset_y = 0)
        @offset_x, @offset_y = offset_x, offset_y
      end

      def call(doc)
        @pos_x=0
        @pos_y=0
        doc.rewrite('body') do |body|
          hr_to_div(body)
        end.rewrite('.step') do |step|
          @pos_x += @offset_x
          @pos_y += @offset_y
          step % {'data-x' => @pos_x, 'data-y' => @pos_y}
        end
      end

      def hr_to_div(hexp)
        divs = [H[:div]]
        hexp.children.each do |child|
          if child.tag == :hr
            divs << H[:div, child.attributes].add_class('step')
          else
            divs[-1] = divs.last << child
          end
        end
        H[hexp.tag, hexp.attributes, divs]
      end

    end
  end
end
