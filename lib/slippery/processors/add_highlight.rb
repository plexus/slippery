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
        js = asset_uri('highlight.js/highlight.pack.js')
        css = if @style == :default
          asset_uri('highlight.js/highlight-0.8.default.min.css')
        else
          asset_uri("highlight.js/styles/#{@style}.css")
        end

        doc.rewrite 'head' do |head|
          head <<= H[:link, rel: "stylesheet", href: css]
          head <<= H[:script, src: js]
          head <<= H[:script, 'hljs.initHighlightingOnLoad();']
        end
      end
    end
  end
end
