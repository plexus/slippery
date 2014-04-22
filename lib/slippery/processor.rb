module Slippery
  class Processor
    include ProcessorHelpers

    def initialize(options)
      @options = options
    end

    def options
      if defaults = self.class.const_get(:DEFAULT_OPTIONS)
        defaults.merge(@options)
      else
        @options
      end
    end

  end
end
