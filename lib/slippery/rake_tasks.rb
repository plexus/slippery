require 'rake/tasklib'
require 'listen'

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

    def type(type)
      @options[:type] = type
    end
    alias type= type

    def js_options(options)
      @options.merge!(options)
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

    def pack_assets
      @options[:include_assets] = true
    end
    alias self_contained pack_assets

    def pack_assets?
      !!@options[:include_assets]
    end

    def asset_packer
      if pack_assets?
        AssetPacker::Processor::Local.new(
          @infile.to_s,
          @infile.dirname.join('assets'),
          @infile
        )
      else
        ->(i) { i }
      end
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
              File.write("#{name}.html", asset_packer.((markdown_to_hexp(path))).to_html)
            end
          end
        end

        namespace :watch do
          presentation_names.each do |name, path|

            desc "watch #{name} for changes"
            task name do
              asset_files = markdown_to_hexp(path)
                .select('link,script')
                .map {|link| link.attr('href') || link.attr('src')}
                .compact
                .select {|uri| URI(uri).scheme == 'file' || URI(uri).scheme == '' || URI(uri).scheme.nil? }
                .map {|uri| Pathname(URI(uri).path) }
                .select(&:exist?)
                .map(&:to_s)

              watch(name, [path.to_s, *asset_files]) do
                target = Pathname("#{name}.html")
                before = target.exist? ? target.read : ''
                Rake::Task["#{@name}:build:#{name}"].execute
                puts "="*60

                tmpfile = Tempfile.new("#{name}.html")
                tmpfile << before
                tmpfile.close
                print `diff -u #{tmpfile.path} #{name}.html | cut -c1-150`
              end
            end
          end
        end
      end
    end

    def watch(name, files, &block)
      listener = Listen.to('.', :only => /#{files.join('|')}/, &block)

      at_exit do
        block.call
        listener.start # not blocking
        sleep
      end
    end
  end

end
