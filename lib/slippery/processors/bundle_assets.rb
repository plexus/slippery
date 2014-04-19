module Slippery
  module Processors
    class BundleAssets
      include Concord.new(:strategy)
      extend Forwardable

      def_delegators :strategy, :convert_stylesheet, :convert_script, :convert_image, :convert_style

      def call(doc)
        doc
          .rewrite('link[rel=stylesheet]', &method(:convert_stylesheet))
          .rewrite('script[src]',          &method(:convert_script))
          .rewrite('img',                  &method(:convert_image))
          .rewrite('style',                &method(:convert_style))
      end

      class NullStrategy
        def I(node) node end
        alias convert_stylesheet I
        alias convert_script     I
        alias convert_image      I
        alias convert_style      I
      end

      class StandAloneStrategy
        def convert_stylesheet(link)
          H[:style, { type: 'text/css' }, read_uri(link[:href])]
        end

        def convert_script(script)
          attrs = script.attributes.reject { |k,v| k=='src' }
          H[:script, attrs, read_uri(script[:src])]
        end

        def convert_image(img)
          H[:img, img.attributes.merge(src: data_uri(img[:src]))]
        end

        def convert_style(style)
          style
        end

        def read_uri(uri)
          @download_cache ||= {}
          @download_cache[uri] ||= open(uri.sub('file://', '')).read
        end

        def data_uri(uri)
          base64 = Base64.encode64(read_uri uri)
          ext    = File.extname(uri)
          type   = {
            '.jpg'  => 'image/jpeg',
            '.jpeg' => 'image/jpeg',
            '.png'  => 'image/png',
            '.gif'  => 'image/gif',
          }[ext.downcase]

          "data:#{type};base64,#{base64}"
        end
      end

      class CopyStrategy

        ASSETS_RELATIVE_PATH = 'assets'
        SOURCE_ASSETS_ABSOLUTE_PATH = ROOT.join(ASSETS_RELATIVE_PATH)

        def convert_stylesheet(link)
          copy_asset(link[:href])
          H[
            :link,
            link.attributes
            .merge(
              href: local_path(link[:href])
            )
          ]
        end

        def convert_script(script)
          copy_asset(script[:src])
          H[
            :script,
            script.attributes
            .merge(
              src: local_path(script[:src])
            )
          ]
        end

        def convert_image(img)
          img
        end

        def convert_style(style)
          style
        end

        private

        def local_path(file_path)
          File.join(ASSETS_RELATIVE_PATH, file_path)
        end

        def copy_asset(file_path)
          dir_path = File.dirname(file_path)
          FileUtils.mkdir_p(dir_path) unless File.exist?(dir_path)

          src = File.join(SOURCE_ASSETS_ABSOLUTE_PATH, file_path)
          dst = File.join('./', local_path(file_path))

          FileUtils.cp(
            src,
            dst,
            preserve: true
          ) unless FileUtils.compare_file(src, dst)
        end

      end
    end
  end
end
