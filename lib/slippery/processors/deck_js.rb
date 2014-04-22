module Slippery
  module Processors
    # http://imakewebthings.com/deck.js/
    class DeckJs < Processor
      #ROOT     = 'http://imakewebthings.com/deck.js/'
      ROOT     = ProcessorHelpers.asset_uri('deck.js/')
      CORE_JS  = URI.join(ROOT, 'core/deck.core.js')
      CORE_CSS = URI.join(ROOT, 'core/deck.core.css')

      DEFAULT_OPTIONS = {
        extensions: %w[menu goto status navigation scale],
        theme: 'web-2.0',
        transition_theme: 'horizontal-slide'
      }

      # HEAD

      processor :add_core_css, 'head' do |head|
        head.add(stylesheet_link_tag(CORE_CSS))
      end

      processor :add_extension_css, 'head' do |head|
          options.fetch(:extensions, []).inject(head) do |head, name|
            head.add(stylesheet_link_tag(
              URI.join(ROOT, "extensions/#{name}/deck.#{name}.css")
            ))
        end
      end

      processor :add_theme, 'head' do |head|
        if theme
          head.add(stylesheet_link_tag(URI.join(ROOT, "themes/style/#{theme}.css")).attr('id', 'style-theme-link'))
        else
          head
        end
      end

      processor :add_transition_theme, 'head' do |head|
        if transition_theme
          head.add(stylesheet_link_tag(URI.join(ROOT, "themes/transition/#{transition_theme}.css")).attr('id', 'transition-theme-link'))
        else
          head
        end
      end

      processor :add_modernizer, 'head' do |head|
        head.add(javascript_include_tag(URI.join(ROOT, 'modernizr.custom.js')))
      end

      # BODY

      processor :add_core_js, 'body' do |body|
        body.add(javascript_include_tag(CORE_JS))
      end

      processor :add_extension_js, 'body' do |body|
        options.fetch(:extensions, []).inject(body) do |body, name|
          body.add(javascript_include_tag(
              URI.join(ROOT, "extensions/#{name}/deck.#{name}.js")
          ))
        end
      end

      processor :init_deck_js, 'body' do |body|
        body.add(H[:script, "$(function() { $.deck('.slide'); });"])
      end

      processor :wrap_deck_container, 'body' do |body|
        H[:body, H[:div, {class: "deck-container"}, body.children]]
      end

      def theme
        options[:theme]
      end

      def transition_theme
        options[:transition_theme]
      end
    end
  end
end
