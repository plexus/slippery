module Slippery
  class Document
    include Hexp

    def initialize(markdown)
      @markdown = markdown
    end

    def kramdown_document
      @kramdown_document ||= ::Kramdown::Document.new(@markdown, input: 'GFM')
    end

    def to_hexp
      @hexp ||= Hexp::Kramdown.convert(kramdown_document)
    end
  end
end
