module Slippery
  module Processors
    class JQuery < Processor
      JQUERY = ProcessorHelpers.asset_uri('jquery/jquery-2.1.0.min.js')
      #JQUERY = 'https://code.jquery.com/jquery-2.1.0.min.js'

      processor :add_jquery, 'head' do |head|
        head.add(javascript_include_tag(JQUERY))
      end
    end
  end
end
