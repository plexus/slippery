module Slippery
  class Document
    include Hexp

    def initialize(markdown)
      @markdown = markdown
    end

    def kramdown_document
      @kramdown_document ||= Kramdown::Document.new(@markdown, input: 'GFM')
    end

    def to_hexp
      @hexp ||= Slippery::Converter.new.convert(kramdown_document.root).to_hexp
    end
  end
end
