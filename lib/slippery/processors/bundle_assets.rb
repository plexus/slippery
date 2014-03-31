
module Slippery
  module Processors
    class BundleAssets
      include Concord.new(:strategy)
      extend Forwardable

      def_delegators :strategy, :convert_stylesheet, :convert_script, :convert_image, :convert_style

      def call(doc)
        doc
          .rewrite('link[rel=stylesheet]', &method(:convert_stylesheet))
          .rewrite('script[src]',          &method(:convert_script))
          .rewrite('img',                  &method(:convert_image))
          .rewrite('style',                &method(:convert_style))
      end

      class NullStrategy
        def I(node) node end
        alias convert_stylesheet I
        alias convert_script     I
        alias convert_image      I
        alias convert_style      I
      end

      class StandAloneStrategy
        def convert_stylesheet(link)
          H[:style, { type: 'text/css' }, read_uri(link[:href])]
        end

        def convert_script(script)
          attrs = script.attributes.reject { |k,v| k=='src' }
          H[:script, attrs, read_uri(script[:src])]
        end

        def convert_image(img)
          H[:img, img.attributes.merge(src: data_uri(img[:src]))]
        end

        def convert_style(style)
          style
        end

        def read_uri(uri)
          @download_cache ||= {}
          @download_cache[uri] ||= open(uri.sub('file://', '')).read
        end

        def data_uri(uri)
          base64 = Base64.encode64(read_uri uri)
          ext    = File.extname(uri)
          type   = {
            '.jpg'  => 'image/jpeg',
            '.jpeg' => 'image/jpeg',
            '.png'  => 'image/png',
            '.gif'  => 'image/gif',
          }[ext.downcase]

          "data:#{type};base64,#{base64}"
        end
      end
    end
  end
end
