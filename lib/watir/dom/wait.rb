require "watir-webdriver"
require "watir/dom/wait/version"
require "watir/dom/decorator"
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

        #
        # Waits until DOM is changed.
        # @param [Watir::Element] element
        # @param [Hash] opts
        # @option opts [Fixnum] timeout seconds to wait before timing out
        # @option opts [Float] interval How long to wait between DOM nodes adding/removing in seconds. Defaults to 0.5
        # @option opts [Float] delay How long to wait for DOM modifications to start in seconds. Defaults to 1
        # @api private
        #

        def wait_for_dom(element, opts, message)
          self.rescue do
            js = JAVASCRIPT.dup
            browser = element.browser
            browser.execute_script js, element, opts[:interval], opts[:delay]
            Watir::Wait.until(opts[:timeout], message) { browser.execute_script(DOM_READY) == 0 }
          end
        end

        #
        # Executes block rescuing all necessary exceptions.
        # @param [Proc] block
        # @api private
        #

        def rescue(&block)
          block.call
        rescue Selenium::WebDriver::Error::StaleElementReferenceError, Exception::UnknownObjectException => error
          msg = 'Element not found in the cache - perhaps the page has changed since it was looked up'
          if error.is_a?(Watir::Exception::UnknownObjectException) && !error.message.include?(msg)
            raise error
          else
            # element can become stale, so we just retry DOM waiting
            retry
          end
        rescue Selenium::WebDriver::Error::JavascriptError
          # in rare cases, args passed to execute script are not correct, for example:
          #   correct:   [#<Watir::Body:0x6bb2ccb9de06cb92 located=false selector={:element=>(webdriver element)}>, 300, 3000]    [el, interval, delay]
          #   incorrect: [0.3, 3000, nil]                                                                                         [interval, delay, ?]
          # TODO there might be some logic (bug?) in Selenium which does this
          retry
        end

      end # << self
    end # Wait
  end # Dom
end # Watir
