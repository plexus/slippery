require 'fileutils'

# Manage the assets and their URI/path
module Slippery
  module Assets
    ASSETS_PATH = '../../../assets/'

    # Copies the assets locally
    def self.embed_locally
      FileUtils.cp_r(File.expand_path(ASSETS_PATH, __FILE__), './')
    end

    # returns a composer returning a URI for a given relative file path
    # considering if the asset is local or not
    def self.path_composer(local)
      if local
        ->(path) { File.join('assets', path) }
      else
        ->(path) { "file://#{File.expand_path(File.join(ASSETS_PATH, path), __FILE__)}" }
      end
    end
  end
end
