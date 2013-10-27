module Slippery
  class Presentation
    include Hexp

    DEFAULT_OPTIONS = {
      type: :reveal_js
    }.freeze

    def initialize(document, options = {})
      @document = document
      @options = DEFAULT_OPTIONS.merge(options).freeze
    end

    def processors
      {
        :impress_js => [
          HrToSections.new(H[:div, class: 'step']),
          ImpressJs::AddImpressJs.new(js_options),
          ImpressJs::AutoOffsets.new,
        ],
        :reveal_js => [
          HrToSections.new(H[:section]),
          RevealJs::AddRevealJs.new(js_options),
        ]
      }[@options[:type]]
    end

    def js_options
      @options.reject {|key,_| [:type].include? key }
    end

    def to_hexp
      @document.process(*processors)
    end
  end
end
