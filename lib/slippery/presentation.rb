module Slippery
  class Presentation
    include Hexp

    DEFAULT_OPTIONS = {
      type: :reveal_js,
      local: true,
      history: true
    }.freeze

    def initialize(document, options = {})
      @document = document
      @options = DEFAULT_OPTIONS.merge(options).freeze
    end

    def processors
      {
        impress_js: [
          Processors::HrToSections.new(H[:div, class: 'step']),
          Processors::ImpressJs::AddImpressJs.new(js_options),
          (Processors::ImpressJs::AutoOffsets.new unless @options.fetch(:manual_offsets, false)),
        ].compact,
        reveal_js: [
          Processors::HrToSections.new(H[:section]),
          Processors::RevealJs::AddRevealJs.new(js_options),
        ]
      }[@options[:type]]
    end

    def js_options
      @options.reject { |key, _| [:type].include? key }
    end

    def to_hexp
      @document.process(*processors)
    end
  end
end
