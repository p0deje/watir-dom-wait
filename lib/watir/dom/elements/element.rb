module Watir
  class Element

    #
    # Waits until DOM is changed within the element and returns/yields self.
    #
    # @example With self returned
    #   browser.div(id: 'test').when_dom_changed.a(id: 'link').click
    #
    # @example With passing block
    #   browser.div(id: 'test').when_dom_changed do |div|
    #     div.a(id: 'link').click
    #   end
    #
    # @example With timeout of 10 seconds
    #   browser.div(id: 'test').when_dom_changed(timeout: 10).a(id: 'link').click
    #
    # @example With interval of checking for subtree modifications of 2 seconds
    #   browser.div(id: 'test').when_dom_changed(interval: 2).a(id: 'link').click
    #
    # @example With 5 seconds delay of how long to waiting for DOM to start modifying
    #   browser.div(id: 'test').when_dom_changed(delay: 5).a(id: 'link').click
    #
    # @param [Hash] opts
    # @option opts [Fixnum] timeout seconds to wait before timing out
    # @option opts [Float] interval How long to wait between DOM nodes adding/removing in seconds. Defaults to 0.5
    # @option opts [Float] delay How long to wait for DOM modifications to start in seconds. Defaults to 1
    #

    def when_dom_changed(opts = {})
      message = "waiting for DOM subtree to finish modifying in #{selector_string}"
      opts[:timeout]  ||= Dom::Wait.timeout
      opts[:interval] ||= Dom::Wait.interval
      opts[:delay]    ||= Dom::Wait.delay

      if block_given?
        js = Dom::Wait::JAVASCRIPT.dup
        browser.execute_script js, self, opts[:interval], opts[:delay]
        Wait.until(opts[:timeout], message) { browser.execute_script(Dom::Wait::DOM_READY) == 0 }
        yield self
      else
        WhenDOMChangedDecorator.new(self, opts, message)
      end

    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      locate
    end

    #
    # Waits until DOM is changed within the element.
    #
    # @param [Hash] opts
    # @option opts [Fixnum] timeout seconds to wait before timing out
    # @option opts [Float] interval How long to wait between DOM nodes adding/removing in seconds. Defaults to 0.5
    # @option opts [Float] delay How long to wait for DOM modifications to start in seconds. Defaults to 1
    #

    def wait_until_dom_changed(opts = {})
      when_dom_changed(opts) do
        # just trigger waiting
      end
    end

  end # Element
end # Watir
