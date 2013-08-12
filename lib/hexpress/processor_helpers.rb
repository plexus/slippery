module Hexpress
  module ProcessorHelpers
    def include_local_javascript(element, relative_path)
      element.add javascript_include_tag(asset_uri(relative_path))
    end

    def asset_uri(path)
      'file://' + File.expand_path('../../../assets/'+ path, __FILE__)
    end


    def javascript_include_tag(path)
      H[:script, {src: path, type: 'text/javascript'}]
    end
  end
end
