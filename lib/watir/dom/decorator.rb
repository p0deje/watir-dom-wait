module Watir
  #
  # Wraps an Element so that any subsequent method calls are
  # put on hold until the DOM subtree is modified within the element.
  #
  class WhenDOMChangedDecorator

    def initialize(element, opts, message)
      @element = element
      @opts    = opts
      @message = message
    end

    def method_missing(m, *args, &block)
      unless @element.respond_to?(m)
        raise NoMethodError, "undefined method `#{m}' for #{@element.inspect}:#{@element.class}"
      end

      Dom::Wait.wait_for_dom(@element, @opts, @message)
      @element.__send__(m, *args, &block)
    end

    def respond_to?(*args)
      @element.respond_to?(*args)
    end

  end # WhenDOMChangedDecorator
end # Watir
