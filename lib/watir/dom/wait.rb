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

        attr_writer :interval
        attr_writer :delay
        attr_writer :timeout

        def interval
          @interval ||= 0.5
        end

        def delay
          @delay ||= 1
        end

        def timeout
          @timeout ||= 30
        end

        #
        # Waits until DOM is changed.
        # @param [Watir::Element] element
        # @param [Hash] opts
        # @option opts [Float] interval How long to wait between DOM nodes adding/removing in seconds. Defaults to 0.5
        # @option opts [Float] delay How long to wait for DOM modifications to start
        # @option opts [Fixnum] timeout seconds to wait before timing out
        # @api private
        #

        def wait_for_dom(element, opts, message)
          response = self.rescue do
            js = JAVASCRIPT.dup
            driver = element.browser.driver
            # TODO make sure we rollback to user-defined timeout
            # blocked by https://code.google.com/p/selenium/issues/detail?id=6608
            driver.manage.timeouts.script_timeout = opts[:timeout] + 1
            response = driver.execute_async_script(js, element.wd, opts[:interval], opts[:delay], opts[:timeout])
            driver.manage.timeouts.script_timeout = 1
            
            response
          end
          # Response statuses:
          #   0: DOM modifications have started and successfully finished
          #   1: DOM modifications have started but exceeded timeout
          #   2: DOM modifications have not started
          if response == 1
            message = "timed out after #{timeout} seconds, #{message}"
            raise Watir::Wait::TimeoutError, message
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
          if error.is_a?(Exception::UnknownObjectException) && !error.message.include?(msg)
            raise error
          else
            # element became stale so we just retry DOM waiting
            retry
          end
        rescue Selenium::WebDriver::Error::JavascriptError
          # in rare cases, args passed to execute script are not correct, for example:
          #   correct:   [#<Selenium::WebDriver::Element:0x..fd5f048838948a830 id="{bdfa905e-b666-354c-9bf1-4dc693fd15a8}">, 300, 3000]    [el, interval, timeout]
          #   incorrect: [0.3, 3000, nil]                                                                                                  [interval, timeout, ??]
          # TODO there might be some logic (bug?) in Selenium which does this
          retry
        end

      end # << self
    end # Wait
  end # Dom
end # Watir
