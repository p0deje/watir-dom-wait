require "watir-webdriver"
require "watir/dom/wait/version"
require "watir/dom/elements/element"

module Watir
  module Dom
    module Wait

      JAVASCRIPT = File.read("#{File.dirname(__FILE__)}/extensions/js/waitForDom.js")
      DOM_READY = "return watir.domReady;"


      class << self

        attr_writer :timeout
        attr_writer :interval
        attr_writer :delay

        def timeout
          @timeout ||= 30
        end

        def interval
          @interval ||= 0.5
        end

        def delay
          @delay ||= 1
        end

      end # << self
    end # Wait
  end # Dom


  #
  # Wraps an Element so that any subsequent method calls are
  # put on hold until the DOM subtree is modified within the element.
  #

  class WhenDOMChangedDecorator

    def initialize(element, opts, message = nil)
      @element = element
      @opts    = opts
      @message = message
      @js      = Dom::Wait::JAVASCRIPT.dup
    end

    def method_missing(m, *args, &block)
      unless @element.respond_to?(m)
        raise NoMethodError, "undefined method `#{m}' for #{@element.inspect}:#{@element.class}"
      end

      @element.browser.execute_script @js, @element, @opts[:interval], @opts[:delay]
      Watir::Wait.until(@opts[:timeout], @message) { @element.browser.execute_script(Dom::Wait::DOM_READY) == 0 }

      @element.__send__(m, *args, &block)
    end

    def respond_to?(*args)
      @element.respond_to?(*args)
    end

  end # WhenDOMChangedDecorator
end # Watir
