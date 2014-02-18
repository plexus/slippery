module Slippery
  class Presentation
    include Hexp

    DEFAULT_OPTIONS = {
      type: :reveal_js,
      local: true
    }.freeze

    def initialize(document, options = {})
      @document = document
      @options = DEFAULT_OPTIONS.merge(options).freeze

      Assets::embed_locally if @options[:local]
    end

    def processors
      {
        impress_js: [
          Processors::HrToSections.new(H[:div, class: 'step']),
          Processors::ImpressJs::AddImpressJs.new(Assets::path_composer(@options[:local]), js_options),
          Processors::ImpressJs::AutoOffsets.new,
        ],
        reveal_js: [
          Processors::HrToSections.new(H[:section]),
          Processors::RevealJs::AddRevealJs.new(Assets::path_composer(@options[:local]), js_options),
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
