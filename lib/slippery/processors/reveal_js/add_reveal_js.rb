module Slippery
  module Processors
    module RevealJs
      class AddRevealJs
        include ProcessorHelpers

        def self.call(doc)
          self.new.call(doc)
        end

        attr_reader :attributes

        DEFAULT_OPTIONS = {theme: 'default'}.freeze

        def initialize(path_composer, options = {})
          @path_composer = path_composer
          @options = DEFAULT_OPTIONS.merge(options).freeze
        end

        def call(doc)
          doc.process(
            reveal_wrap,
            add_reveal_js,
            add_reveal_css,
            add_theme,
            add_settings
          )
        end

        processor :add_reveal_js, 'body' do |body|
          body = include_local_javascript(body, @path_composer.call('reveal.js/lib/js/head.min.js'))
          include_local_javascript(body, @path_composer.call('reveal.js/js/reveal.js'))
        end

        processor :add_reveal_css, 'head' do |head|
          include_local_css(head, @path_composer.call('reveal.js/css/reveal.min.css'))
        end

        processor :add_theme, 'head' do |head|
          include_local_css(head, @path_composer.call("reveal.js/css/theme/#{@options[:theme]}.css"))
        end

        processor :add_settings, 'body' do |body|
          body.add(H[:script, "Reveal.initialize({ #{plugin_settings}, #{settings.map { |k, v| "#{k}:#{v.inspect}" }.join(',')} });"])
        end

        processor :reveal_wrap, 'body' do |body|
          body.set_children(
            H[:div, {class: 'reveal'}, [
                H[:div, {class: 'slides'}, body.children]
              ]
            ]
          )
        end

        def settings
          @options.reject { |key, _| [:theme, :plugins].include? key }
        end

        def plugin_settings
          'dependencies: [' +
          Array(@options.fetch(:plugins, [])).map do |name|
            plugin_config name
          end.join(',') + ']'
        end

        def plugins(name)
          {
            notes: 'plugin/notes/notes.js'
          }[name]
        end

        def plugin_config(plugin)
          "{ src: #{plugins(plugin).inspect}, async: true, condition: function() { return !!document.body.classList; } }"
        end
      end
    end
  end
end
