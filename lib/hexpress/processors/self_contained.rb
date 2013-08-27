require 'base64'
require 'open-uri'

module Hexpress
  module Processors
    class SelfContained
      def self.call(doc)
        self.new.call(doc)
      end

      def call(doc)
        doc
          .rewrite('link[rel=stylesheet]', &convert_stylesheet_to_inline)
          .rewrite('script[src]',          &convert_script_to_inline)
          .rewrite('img',                  &convert_image_to_data_uri)
          #.rewrite('style',                &convert_style_uri_to_data_uri)
      end

      def convert_stylesheet_to_inline
        ->(link) { H[:style, { type: 'text/css' }, read_uri(link[:href])] }
      end

      def convert_script_to_inline
        ->(script) do
          attrs = script.attributes.reject { |k,v| k=='src' }
          H[:script, attrs, read_uri(script[:src])]
        end
      end

      def convert_image_to_data_uri
        ->(img) { H[:img, img.attributes.merge(src: data_uri(img[:src]))] }
      end

      # def convert_style_uri_to_data_uri
      #   ->(style) {
      #     H[:style, style.attributes, style.children.first.gsub(/url\(['"]?[^'"\)]+['"]?\)/) {|url| "url('#{data_uri url[/url\(['"]?([^'"\)]+)/,1] }')"} ] }
      # end

      def read_uri(uri)
        @@download_cache ||= {}
        if uri =~ /http/
          @@download_cache[uri] ||= open(uri.sub('file://', '')).read
        else
          open(uri.sub('file://', '')).read
        end
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
