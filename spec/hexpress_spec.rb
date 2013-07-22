require 'spec_helper'

describe Hexpress, 'convert' do
  subject(:hexp)  { converter.convert(document.root) }
  let(:document)  { Kramdown::Document.new(markdown) }
  let(:converter) { Class.new(Hexpress::Converter) { def blank ; end }.new }

  def html(*children)
    H[:html, H[:body, children]]
  end

  context 'with a header and a paragraph' do
    let(:markdown) { load_fixture('header_and_paragraph') }

    it 'turns a Kramdown document into a Hexp' do
      expect(hexp).to eq(
        html(
          H[:h1, 'Hello, World!'],
          H[:p, 'This is a paragraph.']))
    end
  end

  context 'heading styles and levels' do
    let(:markdown) { load_fixture('headers') }

    it 'knows about all kinds of headings' do
      expect(hexp).to eq(
        html(
          H[:h1, 'Level 1'],
          H[:h2, 'Level 2'],
          H[:h3, 'Level 3'],
          H[:h1, 'Level 1 again'],
          H[:h2, 'Level 2'],
          H[:h6, 'Level 6']))
    end
  end

  describe 'blockquote' do
    let(:markdown) { load_fixture('blockquotes') }

    it 'understands block quotes' do
      expect(hexp).to eq(
        html(
          H[:blockquote, [
              H[:p, 'This is a block quote'],
              H[:p, 'With two paragraphs']
            ]],
          H[:blockquote, [
              H[:p, "This is a second block quote\nthat is hand-wrapped"]
            ]]))
    end
  end

  describe 'code_blocks' do
    let(:markdown) { load_fixture('code_blocks') }

    it 'understands code blocks' do
      expect(hexp).to eq(
        html(
          H[:pre, ["an indented code block\n"]],
          H[:pre, ["a fenced code block\n"]],
          H[:pre, { 'class' => 'language-ruby' },
                  ["code block with language specifier\n"]]))
    end
  end
end
