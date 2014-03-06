module Slippery
  module Processors
    module ImpressJs
      class AutoOffsets
        def initialize(offset_x = 1000, offset_y = 0)
          @offsets  = [offset_x, offset_y]
          @position = [0,0]
        end

        def call(doc)
          doc.replace('.step') do |step|
            ['data-x', 'data-y'].each_with_index do |axis, idx|
              if step.has_attr?(axis)
                @position[idx] = step[axis].to_i
              else
                @position[idx] += @offsets[idx]
              end
            end
            step % { 'data-x' => @position[0], 'data-y' => @position[1] }
          end
        end
      end
    end
  end
end
