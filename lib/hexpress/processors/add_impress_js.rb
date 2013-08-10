module Hexpress
  module Processors
    class AddImpressJs
      def self.call(doc)
        self.new.call(doc)
      end

      def call(doc)
        doc.rewrite('body') do |body|
          body % {id: 'impress', "data-transition-duration" => '1000'} \
               << H[:script, src: impress_js_path] \
               << H[:script, "impress().init();"]
        end
      end

      def impress_js_path
        "file://#{File.expand_path('../../../../js/impress.js', __FILE__)}"
      end
    end
  end
end
