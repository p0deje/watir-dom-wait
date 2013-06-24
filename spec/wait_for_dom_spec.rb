require 'spec_helper'

describe Watir::Element do
  describe "#when_dom_changed" do
    context "when DOM is changed" do
      context "when block is not given" do
        it "waits using event handler" do
          @browser.button(:id, "quick").click
          @browser.div.when_dom_changed.should have(20).spans
        end

        it "may be run more than one time" do
          (1..3).each do |i|
            @browser.button(:id, "quick").click
            @browser.div.when_dom_changed.should have(20 * i).spans
          end
        end

        it "waits using custom interval" do
          @browser.button(:id, "long").click
          @browser.div.when_dom_changed(:interval => 1.1).should have(5).spans
        end

        it "raises timeout error" do
          @browser.button(:id, "quick").click
          lambda { @browser.div.when_dom_changed(:timeout => 2).spans }.should raise_error(Watir::Wait::TimeoutError)
        end
      end

      context "when block given" do
        it "waits using event handler" do
          @browser.button(:id, "quick").click
          @browser.div.when_dom_changed do |div|
            div.should have(20).spans
          end
        end

        it "waits using custom interval" do
          @browser.button(:id, "long").click
          @browser.div.when_dom_changed(:interval => 1.1) do |div|
            div.should have(5).spans
          end
        end

        it "raises timeout error" do
          @browser.button(:id, "quick").click
          lambda do
            @browser.div.when_dom_changed(:timeout => 2) { |div| div.spans }
          end.should raise_error(Watir::Wait::TimeoutError)
        end
      end
    end

    context "when DOM is not changed" do
      it "doesn't raise any exception" do
        @browser.div.when_dom_changed.should have(0).spans
      end
    end
  end
end
