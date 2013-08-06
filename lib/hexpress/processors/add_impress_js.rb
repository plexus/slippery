module Hexpress
  module Processors
    class AddImpressJs
      def call(doc)
        doc.rewrite('body') do |body|
          body.
            attr('id', 'impress').
            attr('data-transition-duration', '1000').
            add_child(H[:script, src: impress_js_path]).
            add_child(H[:script, "impress().init();"])
        end
      end

      def impress_js_path
        "file://#{File.expand_path('../../../../js/impress.js', __FILE__)}"
      end
    end
  end
end
