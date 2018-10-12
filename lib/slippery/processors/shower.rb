module Slippery
  module Processors
    class Shower
      include ProcessorHelpers

      def self.call(doc)
        self.new.call(doc)
      end

      attr_reader :attributes

      DEFAULT_OPTIONS = {theme: :material,
                         ratio: '4x3',
                         color_key: '#4caf50'
                        }.freeze

      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options).freeze
      end

      def theme
        @options[:theme]
      end

      def ratio
        @options[:ratio].sub('x', ' / ')
      end

      def color_key
        @options[:color_key]
      end

      def call(doc)
        doc.process(
          add_shower_js,
          add_shower_css,
          set_body_classes,
          meta_tags,
          header
        )
      end

      processor :add_shower_js, 'body' do |body|
        include_local_javascript(body, 'shower/shower.min.js')
      end

      processor :add_shower_css, 'head' do |head|
        include_local_css(head, "shower/themes/#{theme}/styles/styles.css")
          .add_child(H[:style, ".shower {--slide-ratio: calc(#{ratio}); --color-key: #{color_key};} "])
      end

      processor :meta_tags, 'head' do |head|
        head
          .add_child(H[:meta, {"charset" => "utf-8"}])
          .add_child(H[:meta, {"http-equiv" => "x-ua-compatible",
                               "content" => "ie=edge"}])
          .add_child(H[:meta, {"name" => "viewport",
                               "content" => "width=device-width, initial-scale=1"}])
      end

      processor :set_body_classes, 'body' do |body|
        body.attr('class', 'shower list')
      end

      processor :header, 'section:first-child' do |section|
        section.set_tag(:header).attr('class', 'caption')
      end

    end
  end
end
