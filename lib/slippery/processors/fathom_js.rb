module Slippery
  module Processors
    # http://markdalgleish.com/projects/fathom/
    class FathomJs
      include ProcessorHelpers

      FATHOM = 'https://raw.githubusercontent.com/markdalgleish/fathom/master/fathom.min.js'
      def initialize(options)
        @options = options
      end

      processor :add_fathom, 'head' do |head|
        head.add(javascript_include_tag(JQUERY))
      end

      processor :wrap_presentation, 'body' do |body|
        body.set_children(H[:div, {id: 'presentation'}, body.children])
      end

      processor :init_fathom, 'head' do |head|
        head.add(H[:script, {type: 'text/javascript'}, <<"JS"])
$(document).ready(function(){
  $('#presentation').fathom({
    #{hash_to_js(@options)}
  });
});
JS
      end
    end
  end
end
