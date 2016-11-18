require 'spec_helper'

describe Watir::Element do
  describe "#when_dom_changed" do
    context "when DOM is changed" do
      context "when block is not given" do
        it "waits using mutation observer" do
          @browser.button(id: "quick").click
          expect(@browser.div.wait_until(&:dom_changed?).spans.count).to eq(20)
        end

        it "waits using custom interval" do
          @browser.button(id: "long").click
          expect(@browser.div.wait_until(&:dom_changed?).spans.count).to eq(5)
        end

        it "raises timeout error" do
          @browser.button(id: "quick").click
          expect { @browser.div.wait_until(timeout: 1, &:dom_changed?) }.to raise_error(Watir::Wait::TimeoutError)
        end

        context "when run more than one time" do
          it "waits for DOM consecutively" do
            3.times do |i|
              sleep 1
              @browser.button(id: "quick").click
              expect(@browser.div.wait_until(&:dom_changed?).spans.count).to eq(20 * (i + 1))
            end
          end
        end
      end
    end

    context "when DOM is not changed" do
      it "doesn't raise any exception" do
        expect(@browser.div.wait_until(&:dom_changed?).spans.count).to eq(0)
      end
    end

    context "when effects are used" do
      it "properly handles fading" do
        @browser.button(id: 'fade').click
        text = @browser.div(id: 'container3').wait_until(&:dom_changed?).span.text
        expect(text).to eq('Faded')
      end
    end

    context "when element goes stale" do
      it "relocates element" do
        @browser.button(id: 'stale').click
        expect { @browser.div(id: 'container2').wait_until(&:dom_changed?) }.not_to raise_error
      end
    end

    context "when element cannot be located" do
      it "raises error" do
        div = @browser.div(id: 'doesnotexist')
        expect { div.wait_until(&:dom_changed?) }.to raise_error(Watir::Exception::UnknownObjectException)
      end
    end
  end
end
