module Hexpress
  module Processors
    class AddImpressJs
      def self.call(doc)
        self.new.call(doc)
      end

      attr_reader :attributes

      def initialize(attributes = {'transition-duration' => 1000})
        @attributes = attributes
      end

      def call(doc)
        doc.rewrite('body') do |body|
          body % {id: 'impress'}.merge(data_attributes) \
               << H[:script, src: impress_js_path] \
               << H[:script, "impress().init();"]
        end
      end

      def data_attributes
        Hash[*attributes.flat_map {|k,v| ["data-#{k}", v]}]
      end

      def impress_js_path
        "file://#{File.expand_path('../../../../js/impress.js', __FILE__)}"
      end
    end
  end
end
