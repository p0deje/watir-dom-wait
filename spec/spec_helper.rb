require "watir-dom-wait"

RSpec.configure do |spec|
  spec.filter_run_excluding bug: /\d+/

  spec.before(:all) do
    Selenium::WebDriver::Chrome.path = "#{File.dirname(__FILE__)}/../bin/google-chrome" if ENV['TRAVIS']
    @browser = Watir::Browser.new(:chrome, opts)
    @browser.goto "data:text/html,#{File.read('spec/support/html/wait_for_dom.html')}"
  end

  spec.after(:all) do
    @browser.quit
  end

  spec.after(:each) do |example|
    @browser.refresh
  end
end
