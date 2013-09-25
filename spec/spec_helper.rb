require "watir/dom/wait"

RSpec.configure do |spec|
  spec.filter_run_excluding bug: /\d+/

  spec.before(:all) do
    @browser = Watir::Browser.new
    @browser.goto "data:text/html,#{File.read('spec/support/html/wait_for_dom.html')}"
  end

  spec.after(:all) do
    @browser.quit
  end

  spec.after(:each) do
    @browser.refresh
  end
end
