module Watir
  class Element
    DOM_WAIT_JS = File.read("#{File.dirname(__FILE__)}/../extensions/js/waitForDom.js").freeze

    #
    # Returns true if DOM is changed within the element.
    #
    # @example Wait until DOM is changed inside element with default delay
    #   browser.div(id: 'test').wait_until(&:dom_changed?).click
    #
    # @example Wait until DOM is changed inside element with default delay
    #   browser.div(id: 'test').wait_until do |element|
    #     element.dom_changed?(delay: 5)
    #   end
    #
    # @param delay [Integer, Float] how long to wait for DOM modifications to start
    #

    def dom_changed?(delay: 1.1)
      driver.manage.timeouts.script_timeout = delay + 1
      driver.execute_async_script(DOM_WAIT_JS, wd, delay)
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry
    ensure
      # TODO: make sure we rollback to user-defined timeout
      # blocked by https://github.com/seleniumhq/selenium-google-code-issue-archive/issues/6608
      driver.manage.timeouts.script_timeout = 1
    end
  end # Element
end # Watir
