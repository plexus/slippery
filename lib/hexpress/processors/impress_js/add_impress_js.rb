module Hexpress
  module Processors
    module ImpressJs
     class AddImpressJs
       include ProcessorHelpers

       def self.call(doc)
         self.new.call(doc)
       end

       attr_reader :attributes

       def initialize(attributes = {'transition-duration' => 1000})
         @attributes = attributes
       end

       def call(doc)
         doc =
         doc.replace('body') do |body|
           include_local_javascript(body, 'impress.js/js/impress.js')
             .set_attributes({id: 'impress'}.merge(data_attributes))
             .add H[:script, "impress().init();"]
         end
       end

       def data_attributes
         Hash[*attributes.flat_map {|k,v| ["data-#{k}", v]}]
       end

     end
   end
 end
end
