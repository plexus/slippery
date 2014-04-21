require 'rake/tasklib'
require 'rb-inotify'

module Slippery
  class RakeTasks < Rake::TaskLib
    attr_reader :name
    attr_accessor :presentations, :options, :processors

    def initialize(name = :slippery, &blk)
      @name = name
      @presentations = Pathname.glob('*.md')
      @options = {}
      @processors = []

      if block_given?
        if blk.arity == 0
          self.instance_eval(&blk)
        else
          yield self
        end
      end
      define
    end

    def presentation_names
      presentations.map {|path| [ path.basename(path.extname), path ] }
    end

    def markdown_to_hexp(infile, options = {})
      @infile = infile
      doc = Slippery::Document.new(infile.read)
      doc = Slippery::Presentation.new(doc, @options.merge(options))

      doc.process(*processors)
    end

    def processor(selector, &blk)
      processors << ->(node) do
        node.replace(selector) do |node|
          instance_exec(node, &blk)
        end
      end
    end

    def include_assets
      processors << method(:call_asset_packer)
    end
    alias self_contained include_assets

    def call_asset_packer(doc)
      AssetPacker::Processor::Local.new(
        @infile.to_s,
        @infile.dirname.join('assets'),
        @infile
      ).(doc)
    end

    def title(title)
      processor 'head' do |head|
        head <<= H[:title, title]
      end
    end

    def add_highlighting(style = Slippery::Processors::AddHighlight::DEFAULT_STYLE, version = Slippery::Processors::AddHighlight::DEFAULT_VERSION)
      processors << Slippery::Processors::AddHighlight.new(style, version)
    end

    def define
      namespace @name do
        desc "build all"
        task :build => presentation_names.map(&:first).map {|name| "#{@name}:build:#{name}"}

        namespace :build do
          presentation_names.each do |name, path|
            desc "build #{name}"
            task name do
              File.write("#{name}.html", markdown_to_hexp(path).to_html)
            end
          end
        end

        namespace :watch do
          presentation_names.each do |name, path|
            files = markdown_to_hexp(path, skip_self_contained: true).select('link,script').map {|link| link.attr('href') || link.attr('src')}.compact
            files = files.select {|f| File.exist?(f)}

            desc "watch #{name} for changes"
            WatchTask.new(name, [path.to_s, *files]) do
              dest = Tempfile.new("#{name}.html")
              File.open("#{name}.html") { |src| FileUtils.copy_stream(src, dest) }
              dest.close
              Rake::Task["#{@name}:build:#{name}"].execute
              puts "="*60
              print `diff -u #{dest.path} #{name}.html | cut -c1-150` if File.exist? "#{name}.html"
            end
          end
        end
      end
    end
  end


  class WatchTask
    def initialize(name, files, &block)
      Rake::Task.define_task name do
        Array(files).each do |pattern|
          notifier.watch(pattern, :modify, &block)
        end
        at_exit do
          block.call
          notifier.run
        end
      end
    end

    def notifier
      @notifier ||= INotify::Notifier.new
    end
  end
end
