module Hexpress
  class Document
    include Hexp

    private_attr_accessor :processors

    def initialize(markdown, processors = [])
      @markdown = markdown
      @processors = processors
    end

    def kramdown_document
      @kramdown_document ||= Kramdown::Document.new(@markdown)
    end

    def hexp_document
      Hexpress::Converter.new.convert(kramdown_document.root)
    end

    def to_hexp
      @hexp ||= begin
                  hexp = hexp_document
                  processors.each do |proc|
                    hexp = proc.call hexp
                  end
                  hexp
                end
    end
  end
end
