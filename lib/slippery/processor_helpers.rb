module Slippery
  module ProcessorHelpers
    def self.included(klz)
      klz.extend ClassMethods
    end

    def include_local_javascript(element, path)
      element.add javascript_include_tag(path)
    end

    def include_local_css(element, path)
      element.add stylesheet_link_tag(path)
    end

    def javascript_include_tag(path)
      H[:script, {src: path, type: 'text/javascript'}]
    end

    def stylesheet_link_tag(path)
      H[:link, {href: path, rel: 'stylesheet'}]
    end

    def data_attributes(attrs)
      Hash[*attrs.flat_map { |k, v| ["data-#{k}", v] }]
    end

    module ClassMethods
      def processor(name, selector = nil, &blk)
        if selector
          define_method name do
            ->(node) { node.replace(selector) { |node| instance_exec(node, &blk) } }
          end
        else
          define_method name { ->(node) { blk.call(node) } }
        end
      end
    end
  end
end
