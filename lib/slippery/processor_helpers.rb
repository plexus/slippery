module Slippery
  module ProcessorHelpers
    def self.included(klz)
      klz.extend ClassMethods
    end

    def asset_uri(path)
      "file://" + Slippery::ROOT.join('assets', path).to_s
    end
    module_function :asset_uri

    def include_local_javascript(element, path)
      element.add javascript_include_tag(asset_uri(path))
    end

    def include_local_css(element, path)
      element.add stylesheet_link_tag(asset_uri(path))
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

    def hash_to_js(hsh)
      hsh.map { |k, v| "#{k}:#{v.inspect}" }.join(',') #:(
    end

    def call(doc)
      doc.process(*self.class.processors.map {|name| send(name) })
    end

    module ClassMethods
      def processors
        @processors ||= []
      end

      def processor(name, selector = nil, &blk)
        if selector
          define_method name do
            ->(node) { node.replace(selector) { |node| instance_exec(node, &blk) } }
          end
        else
          define_method name { ->(node) { blk.call(node) } }
        end
        processors << name
      end
    end
  end
end
