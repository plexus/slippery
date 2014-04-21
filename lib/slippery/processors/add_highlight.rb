module Slippery
  module Processors
    class AddHighlight

      DEFAULT_STYLE   = :default
      DEFAULT_VERSION = '8.0'

      def initialize(style = DEFAULT_STYLE, version = DEFAULT_VERSION)
        @style = style
        @version = version
      end

      def call(doc)
        doc.rewrite 'head' do |head|
          head <<= H[:link, rel: "stylesheet", href: "http://yandex.st/highlightjs/#{@version}/styles/#{@style}.min.css"]
          head <<= H[:script, src: "http://yandex.st/highlightjs/#{@version}/highlight.min.js"]
          head <<= H[:script, 'hljs.initHighlightingOnLoad();']
        end
      end
    end
  end
end
