module Slippery
  module Processors
    class AddHighlight
      include ProcessorHelpers

      DEFAULT_STYLE = :default

      def initialize(style = DEFAULT_STYLE)
        @style = style
      end

      def call(doc)
        js = asset_uri('highlight.js/highlight.pack.js')
        css = asset_uri("highlight.js/styles/#{@style}.css")

        doc.rewrite 'head' do |head|
          head <<= H[:link, rel: "stylesheet", href: css]
          head <<= H[:script, src: js]
          head <<= H[:script, 'hljs.initHighlightingOnLoad();']
        end
      end
    end
  end
end
