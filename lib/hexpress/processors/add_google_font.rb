require 'cgi'

module Hexpress
  module Processors
    class AddGoogleFont
      def initialize(font_name, variants = [])
        @font_name = font_name.freeze
        @variants  = variants.freeze
      end

      def call(doc)
        doc.rewrite('head', &add_font_link)
      end

      def add_font_link
        ->(head) {
          head << H[:link, {rel: 'stylesheet', type: 'text/css', href: href}]
        }
      end

      def href
        'http://fonts.googleapis.com/css?family=' +
          CGI.escape(@font_name) + (@variants.empty? ? '' : ':' + @variants.join(','))
      end
    end
  end
end
