module Slippery
  module Processors
    class AddHighlight
      include ProcessorHelpers

      DEFAULT_STYLE   = :default
      DEFAULT_VERSION = '8.0'

      def initialize(style = DEFAULT_STYLE, version = DEFAULT_VERSION)
        @style = style
        @version = version
      end

      def call(doc)
        # css = "http://yandex.st/highlightjs/#{@version}/styles/#{@style}.min.css"
        # js  = "http://yandex.st/highlightjs/#{@version}/highlight.min.js"

        js = asset_uri('highlight.js/highlight-0.8.min.js')
        css = asset_uri('highlight.js/highlight-0.8.default.min.css')

        doc.rewrite 'head' do |head|
          head <<= H[:link, rel: "stylesheet", href: css]
          head <<= H[:script, src: js]
          head <<= H[:script, 'hljs.initHighlightingOnLoad();']
        end
      end
    end
  end
end
