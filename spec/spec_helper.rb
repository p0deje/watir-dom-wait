require "watir/dom/wait"

RSpec.configure do |spec|
  spec.before(:all) do
    @browser = Watir::Browser.new
    @browser.goto "data:text/html,#{File.read('spec/html/wait_for_dom.html')}"
  end

  spec.after(:all) do
    @browser.quit
  end

  spec.after(:each) do
    @browser.refresh
  end
end
