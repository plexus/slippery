require 'fileutils'

module Slippery
  module Assets
    ASSETS_PATH = '../../../assets/'

    def self.embed_locally
      FileUtils.cp_r(File.expand_path(ASSETS_PATH, __FILE__), './')
    end

    def self.path_composer(local)
      if local
        ->(path){File.join('assets', path)}
      else
        ->(path){"file://#{File.expand_path(File.join(ASSETS_PATH, path), __FILE__)}"}
      end
    end
  end
end

