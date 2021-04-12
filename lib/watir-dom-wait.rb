require 'watir'
require 'watir/dom/elements/element'

module Watir
  module DOM
    module Wait
      class << self
        attr_writer :minimum_script_timeout

        def minimum_script_timeout
          @minimum_script_timeout ||= 2
        end
      end
    end
  end
end
