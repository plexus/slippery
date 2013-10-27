require 'spec_helper'

describe Slippery::Converter, 'convert' do
  subject(:converter) { Class.new(described_class) { def blank ; end }.new }
  let(:hexp)  { converter.convert(document.root) }
  let(:document)  { Kramdown::Document.new(markdown) }
  let(:markdown)  { load_fixture(fixture) }

  def html(*children)
    H[:html, [H[:head], H[:body, children]]]
  end

  SPECS = {
    'header_and_paragraph' => [
      H[:h1, 'Hello, World!'],
      H[:p, 'This is a paragraph.']
    ],
    'headers' => [
      H[:h1, 'Level 1'],
      H[:h2, 'Level 2'],
      H[:h3, 'Level 3'],
      H[:h1, 'Level 1 again'],
      H[:h2, 'Level 2'],
      H[:h6, 'Level 6']
    ],
    'blockquotes' => [
      H[:blockquote, [
          H[:p, 'This is a block quote'],
          H[:p, 'With two paragraphs']
        ]],
      H[:blockquote, [
          H[:p, "This is a second block quote\nthat is hand-wrapped"]
        ]]
    ],
    'code_blocks' => [
      H[:pre, [H[:code, ["an indented code block\n"]]]],
      H[:pre, [H[:code, ["a fenced code block\n"]]]],
      H[:pre, { 'class' => 'language-ruby' }, [H[:code,
          ["code block with language specifier\n"]]]]
    ],
    'unordered_list' => [
      H[:ul, [
          H[:li, [H[:p, 'banana']]],
          H[:li, [H[:p, 'apple']]],
          H[:li, [H[:p, 'guava']]]]]
    ],
    'ordered_list' => [
      H[:ol, [
          H[:li, [H[:p, 'ninjas']]],
          H[:li, [H[:p, 'pirates']]],
          H[:li, [H[:p, 'sales people']]]]]
    ],
    'definition_lists' => [
      H[:dl, [
          H[:dt, ['Jabberwocky']],
          H[:dd, [H[:p, 'mythical beast of poetic proportions']]]]]
    ]
  }

  SPECS.each do |fixture_name, result|
    context fixture_name do
      let(:fixture) { fixture_name }
      specify { expect(hexp).to eq html(*result) }
    end
  end

end
