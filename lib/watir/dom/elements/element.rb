module Watir
  class Element

    #
    # Waits until DOM is changed within the element.
    #
    # @example
    #   TODO
    #
    # @param [Hash] opts
    # @option opts [Fixnum] timeout seconds to wait before timing out
    # @option opts [Float] interval How long to wait between DOM nodes adding/removing in seconds. Defaults to 0.5
    # @option opts [Float] delay How long to wait for DOM modifications to start in seconds. Defaults to 1
    #
    # @see Watir::Wait
    # @see Watir::Element#dom_changed?
    #

    def when_dom_changed(opts = {})
      message = "waiting for DOM subtree to finish modifying in #{selector_string}"
      opts[:timeout]  ||= 30
      opts[:interval] ||= 0.5
      opts[:delay]    ||= 1

      if block_given?
        js = Dom::Wait::JAVASCRIPT.dup
        browser.execute_script js, self, opts[:interval], opts[:delay]
        Watir::Wait.until(opts[:timeout], message) { browser.execute_script(Dom::Wait::DOM_READY) == 0 }
        yield self
      else
        WhenDOMChangedDecorator.new(self, opts, message)
      end
    end

  end # Element
end # Watir
